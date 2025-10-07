const express = require('express');
const axios = require('axios');
const { exec } = require('child_process');
const { promisify } = require('util');
const execAsync = promisify(exec);

const app = express();
const port = 9091;

// Middleware pour parser JSON
app.use(express.json());

// Jenkins configuration
const JENKINS_URL = process.env.JENKINS_URL || 'http://jenkins:8080';
const JENKINS_USER = process.env.JENKINS_USER || 'admin';
const JENKINS_TOKEN = process.env.JENKINS_TOKEN || '';
const JENKINS_PASSWORD = process.env.JENKINS_PASSWORD || '';
const JENKINS_AUTH_DISABLED = process.env.JENKINS_AUTH_DISABLED === 'true';

// Energy metrics storage
let energyMetrics = {
  builds: new Map(),
  systemMetrics: {
    cpuUsage: 0,
    memoryUsage: 0,
    diskUsage: 0,
    networkUsage: 0,
    powerConsumption: 0
  },
  jenkinsMetrics: {
    activeBuilds: 0,
    queuedBuilds: 0,
    totalBuilds: 0,
    successRate: 0
  }
};

// Jenkins API client
class JenkinsApiClient {
  constructor(baseUrl, username, password, authDisabled = false) {
    this.baseUrl = baseUrl;
    this.authDisabled = authDisabled;
    if (!authDisabled && username && password) {
      this.auth = Buffer.from(`${username}:${password}`).toString('base64');
    }
  }

  async getJobs() {
    try {
      const headers = {};
      if (!this.authDisabled && this.auth) {
        headers.Authorization = `Basic ${this.auth}`;
      }
      
      const response = await axios.get(`${this.baseUrl}/api/json`, { headers });
      return response.data.jobs || [];
    } catch (error) {
      console.error('Error fetching Jenkins jobs:', error.message);
      return [];
    }
  }

  async getJobDetails(jobName) {
    try {
      const headers = {};
      if (!this.authDisabled && this.auth) {
        headers.Authorization = `Basic ${this.auth}`;
      }
      
      const response = await axios.get(`${this.baseUrl}/job/${jobName}/api/json`, { headers });
      return response.data;
    } catch (error) {
      console.error(`Error fetching job details for ${jobName}:`, error.message);
      return null;
    }
  }

  async getBuildDetails(jobName, buildNumber) {
    try {
      const headers = {};
      if (!this.authDisabled && this.auth) {
        headers.Authorization = `Basic ${this.auth}`;
      }
      
      const response = await axios.get(`${this.baseUrl}/job/${jobName}/${buildNumber}/api/json`, { headers });
      return response.data;
    } catch (error) {
      console.error(`Error fetching build details for ${jobName}#${buildNumber}:`, error.message);
      return null;
    }
  }

  async getRunningBuilds() {
    try {
      const headers = {};
      if (!this.authDisabled && this.auth) {
        headers.Authorization = `Basic ${this.auth}`;
      }
      
      const response = await axios.get(`${this.baseUrl}/api/json?tree=jobs[name,lastBuild[number,result,building,timestamp,duration]]`, { headers });
      return response.data.jobs.filter(job => job.lastBuild && job.lastBuild.building);
    } catch (error) {
      console.error('Error fetching running builds:', error.message);
      return [];
    }
  }
}

const jenkinsClient = new JenkinsApiClient(JENKINS_URL, JENKINS_USER, JENKINS_TOKEN, JENKINS_AUTH_DISABLED);

// System metrics collection
async function collectSystemMetrics() {
  try {
    // CPU usage
    const { stdout: cpuStdout } = await execAsync("grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage}'");
    energyMetrics.systemMetrics.cpuUsage = parseFloat(cpuStdout.trim());

    // Memory usage
    const { stdout: memStdout } = await execAsync("free | grep Mem | awk '{printf \"%.2f\", $3/$2 * 100.0}'");
    energyMetrics.systemMetrics.memoryUsage = parseFloat(memStdout.trim());

    // Disk usage
    const { stdout: diskStdout } = await execAsync("df -h / | awk 'NR==2{printf \"%.2f\", $5}' | sed 's/%//'");
    energyMetrics.systemMetrics.diskUsage = parseFloat(diskStdout.trim());

    // Network usage (simplified)
    const { stdout: netStdout } = await execAsync("cat /proc/net/dev | grep eth0 | awk '{print $2+$10}'");
    energyMetrics.systemMetrics.networkUsage = parseInt(netStdout.trim()) || 0;

    // Power consumption estimation (based on CPU and memory usage)
    const powerEstimate = (energyMetrics.systemMetrics.cpuUsage * 0.8) + 
                         (energyMetrics.systemMetrics.memoryUsage * 0.2) + 
                         (energyMetrics.systemMetrics.diskUsage * 0.1);
    energyMetrics.systemMetrics.powerConsumption = Math.min(powerEstimate, 100);

  } catch (error) {
    console.error('Error collecting system metrics:', error.message);
  }
}

// Jenkins metrics collection
async function collectJenkinsMetrics() {
  try {
    const jobs = await jenkinsClient.getJobs();
    const runningBuilds = await jenkinsClient.getRunningBuilds();
    
    energyMetrics.jenkinsMetrics.activeBuilds = runningBuilds.length;
    energyMetrics.jenkinsMetrics.totalBuilds = jobs.length;
    
    // Calculate success rate
    let successfulBuilds = 0;
    let totalCompletedBuilds = 0;
    
    for (const job of jobs) {
      const jobDetails = await jenkinsClient.getJobDetails(job.name);
      if (jobDetails && jobDetails.lastCompletedBuild) {
        totalCompletedBuilds++;
        if (jobDetails.lastCompletedBuild.result === 'SUCCESS') {
          successfulBuilds++;
        }
      }
    }
    
    energyMetrics.jenkinsMetrics.successRate = totalCompletedBuilds > 0 ? 
      (successfulBuilds / totalCompletedBuilds) * 100 : 0;

  } catch (error) {
    console.error('Error collecting Jenkins metrics:', error.message);
  }
}

// Start monitoring for a specific build
async function startBuildMonitoring(buildId, jobName, buildType) {
  const startTime = Date.now();
  const buildKey = `${jobName}-${buildId}`;
  
  energyMetrics.builds.set(buildKey, {
    buildId,
    jobName,
    buildType,
    startTime,
    endTime: null,
    duration: 0,
    energyConsumption: 0,
    cpuUsage: [],
    memoryUsage: [],
    powerConsumption: [],
    status: 'running'
  });

  console.log(`🔋 Started energy monitoring for build: ${buildKey}`);
  return buildKey;
}

// Stop monitoring for a specific build
async function stopBuildMonitoring(buildKey, status = 'completed') {
  const build = energyMetrics.builds.get(buildKey);
  if (!build) {
    console.error(`Build ${buildKey} not found in monitoring`);
    return null;
  }

  const endTime = Date.now();
  const duration = (endTime - build.startTime) / 1000; // seconds
  
  build.endTime = endTime;
  build.duration = duration;
  build.status = status;

  // Calculate average energy consumption
  if (build.cpuUsage.length > 0) {
    const avgCpu = build.cpuUsage.reduce((a, b) => a + b, 0) / build.cpuUsage.length;
    const avgMemory = build.memoryUsage.reduce((a, b) => a + b, 0) / build.memoryUsage.length;
    const avgPower = build.powerConsumption.reduce((a, b) => a + b, 0) / build.powerConsumption.length;
    
    // Energy consumption in watt-hours (simplified calculation)
    build.energyConsumption = (avgPower * duration) / 3600;
  }

  console.log(`🔋 Stopped energy monitoring for build: ${buildKey}, Energy: ${build.energyConsumption.toFixed(4)} Wh`);
  return build;
}

// Update build metrics during execution
async function updateBuildMetrics(buildKey) {
  const build = energyMetrics.builds.get(buildKey);
  if (!build || build.status !== 'running') return;

  try {
    await collectSystemMetrics();
    
    build.cpuUsage.push(energyMetrics.systemMetrics.cpuUsage);
    build.memoryUsage.push(energyMetrics.systemMetrics.memoryUsage);
    build.powerConsumption.push(energyMetrics.systemMetrics.powerConsumption);
    
    // Keep only last 100 measurements
    if (build.cpuUsage.length > 100) {
      build.cpuUsage = build.cpuUsage.slice(-100);
      build.memoryUsage = build.memoryUsage.slice(-100);
      build.powerConsumption = build.powerConsumption.slice(-100);
    }
  } catch (error) {
    console.error('Error updating build metrics:', error.message);
  }
}

// Generate Prometheus metrics
function generatePrometheusMetrics() {
  let metrics = '';
  
  // System metrics
  metrics += `# HELP system_cpu_usage_percent CPU usage percentage\n`;
  metrics += `# TYPE system_cpu_usage_percent gauge\n`;
  metrics += `system_cpu_usage_percent ${energyMetrics.systemMetrics.cpuUsage}\n\n`;
  
  metrics += `# HELP system_memory_usage_percent Memory usage percentage\n`;
  metrics += `# TYPE system_memory_usage_percent gauge\n`;
  metrics += `system_memory_usage_percent ${energyMetrics.systemMetrics.memoryUsage}\n\n`;
  
  metrics += `# HELP system_disk_usage_percent Disk usage percentage\n`;
  metrics += `# TYPE system_disk_usage_percent gauge\n`;
  metrics += `system_disk_usage_percent ${energyMetrics.systemMetrics.diskUsage}\n\n`;
  
  metrics += `# HELP system_power_consumption_estimate Power consumption estimate\n`;
  metrics += `# TYPE system_power_consumption_estimate gauge\n`;
  metrics += `system_power_consumption_estimate ${energyMetrics.systemMetrics.powerConsumption}\n\n`;
  
  // Jenkins metrics
  metrics += `# HELP jenkins_active_builds Number of active builds\n`;
  metrics += `# TYPE jenkins_active_builds gauge\n`;
  metrics += `jenkins_active_builds ${energyMetrics.jenkinsMetrics.activeBuilds}\n\n`;
  
  metrics += `# HELP jenkins_total_builds Total number of builds\n`;
  metrics += `# TYPE jenkins_total_builds gauge\n`;
  metrics += `jenkins_total_builds ${energyMetrics.jenkinsMetrics.totalBuilds}\n\n`;
  
  metrics += `# HELP jenkins_success_rate_percent Jenkins build success rate\n`;
  metrics += `# TYPE jenkins_success_rate_percent gauge\n`;
  metrics += `jenkins_success_rate_percent ${energyMetrics.jenkinsMetrics.successRate}\n\n`;
  
  // Build metrics
  for (const [buildKey, build] of energyMetrics.builds) {
    const labels = `job_name="${build.jobName}",build_type="${build.buildType}",status="${build.status}"`;
    
    metrics += `# HELP jenkins_build_duration_seconds Build duration in seconds\n`;
    metrics += `# TYPE jenkins_build_duration_seconds gauge\n`;
    metrics += `jenkins_build_duration_seconds{${labels}} ${build.duration}\n\n`;
    
    metrics += `# HELP jenkins_build_energy_consumption_wh Build energy consumption in watt-hours\n`;
    metrics += `# TYPE jenkins_build_energy_consumption_wh gauge\n`;
    metrics += `jenkins_build_energy_consumption_wh{${labels}} ${build.energyConsumption}\n\n`;
    
    if (build.cpuUsage.length > 0) {
      const avgCpu = build.cpuUsage.reduce((a, b) => a + b, 0) / build.cpuUsage.length;
      metrics += `# HELP jenkins_build_avg_cpu_usage_percent Average CPU usage during build\n`;
      metrics += `# TYPE jenkins_build_avg_cpu_usage_percent gauge\n`;
      metrics += `jenkins_build_avg_cpu_usage_percent{${labels}} ${avgCpu}\n\n`;
    }
  }
  
  return metrics;
}

// API endpoints
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    service: 'jenkins-energy-metrics',
    timestamp: new Date().toISOString(),
    activeBuilds: energyMetrics.builds.size
  });
});

app.get('/metrics', (req, res) => {
  try {
    const metrics = generatePrometheusMetrics();
    res.set('Content-Type', 'text/plain');
    res.send(metrics);
  } catch (error) {
    console.error('Error generating metrics:', error);
    res.status(500).send('Error generating metrics');
  }
});

// Start monitoring endpoint
app.post('/start-monitoring', (req, res) => {
  try {
    const { buildId, jobName, buildType = 'standard' } = req.body;
    
    if (!buildId || !jobName) {
      return res.status(400).json({ 
        error: 'Missing required fields: buildId, jobName' 
      });
    }
    
    const buildKey = startBuildMonitoring(buildId, jobName, buildType);
    
    res.json({ 
      success: true, 
      message: `Energy monitoring started for build: ${buildKey}`,
      buildKey: buildKey
    });
  } catch (error) {
    console.error('Error starting monitoring:', error);
    res.status(500).json({ error: 'Failed to start monitoring' });
  }
});

// Stop monitoring endpoint
app.post('/stop-monitoring', (req, res) => {
  try {
    const { buildKey, status = 'completed' } = req.body;
    
    if (!buildKey) {
      return res.status(400).json({ 
        error: 'Missing required field: buildKey' 
      });
    }
    
    const build = stopBuildMonitoring(buildKey, status);
    
    if (!build) {
      return res.status(404).json({ 
        error: 'Build not found in monitoring' 
      });
    }
    
    res.json({ 
      success: true, 
      message: 'Energy monitoring stopped and metrics recorded',
      build: build
    });
  } catch (error) {
    console.error('Error stopping monitoring:', error);
    res.status(500).json({ error: 'Failed to stop monitoring' });
  }
});

// Get current metrics endpoint
app.get('/current-metrics', (req, res) => {
  try {
    const activeBuilds = Array.from(energyMetrics.builds.values())
      .filter(build => build.status === 'running');
    
    res.json({
      systemMetrics: energyMetrics.systemMetrics,
      jenkinsMetrics: energyMetrics.jenkinsMetrics,
      activeBuilds: activeBuilds,
      totalMonitoredBuilds: energyMetrics.builds.size
    });
  } catch (error) {
    console.error('Error getting current metrics:', error);
    res.status(500).json({ error: 'Failed to get current metrics' });
  }
});

// Update build metrics endpoint
app.post('/update-build-metrics', (req, res) => {
  try {
    const { buildKey } = req.body;
    
    if (!buildKey) {
      return res.status(400).json({ 
        error: 'Missing required field: buildKey' 
      });
    }
    
    updateBuildMetrics(buildKey);
    
    res.json({ 
      success: true, 
      message: 'Build metrics updated'
    });
  } catch (error) {
    console.error('Error updating build metrics:', error);
    res.status(500).json({ error: 'Failed to update build metrics' });
  }
});

// Start server
app.listen(port, () => {
  console.log(`🔋 Jenkins Energy Metrics Server running on port ${port}`);
  console.log(`📊 Metrics endpoint: http://localhost:${port}/metrics`);
  console.log(`🔍 Health check: http://localhost:${port}/health`);
  console.log(`🎯 Ready to monitor Jenkins build energy consumption!`);
});

// Start periodic metrics collection
setInterval(async () => {
  await collectSystemMetrics();
  await collectJenkinsMetrics();
}, 30000); // Collect every 30 seconds

// Update active build metrics every 10 seconds
setInterval(async () => {
  for (const [buildKey, build] of energyMetrics.builds) {
    if (build.status === 'running') {
      await updateBuildMetrics(buildKey);
    }
  }
}, 10000);

module.exports = app;

