const express = require('express');
const { exec } = require('child_process');
const { promisify } = require('util');
const axios = require('axios');

const app = express();
const port = 9094;

const execAsync = promisify(exec);

// Configuration
const PROMETHEUS_URL = process.env.PROMETHEUS_URL || 'http://prometheus:9090';
const JENKINS_URL = process.env.JENKINS_URL || 'http://jenkins:8080';
const COLLECTION_INTERVAL = parseInt(process.env.COLLECTION_INTERVAL) || 30;

// Energy metrics storage
let energyData = {
  systemPower: 0,
  cpuPower: 0,
  memoryPower: 0,
  diskPower: 0,
  networkPower: 0,
  jenkinsPower: 0,
  totalPower: 0,
  energyEfficiency: 0,
  carbonFootprint: 0
};

// Power consumption calculation functions
async function getCPUPower() {
  try {
    // Get CPU frequency and usage
    const { stdout: freqStdout } = await execAsync("cat /proc/cpuinfo | grep 'cpu MHz' | head -1 | awk '{print $4}'");
    const { stdout: usageStdout } = await execAsync("grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage}'");
    
    const frequency = parseFloat(freqStdout.trim());
    const usage = parseFloat(usageStdout.trim());
    
    // Simplified power calculation: P = V² × f × C × U
    // Where V = voltage (estimated), f = frequency, C = capacitance (estimated), U = usage
    const basePower = (frequency / 1000) * (usage / 100) * 0.8; // Base power in watts
    return Math.min(basePower, 150); // Cap at 150W
  } catch (error) {
    console.error('Error calculating CPU power:', error.message);
    return 0;
  }
}

async function getMemoryPower() {
  try {
    const { stdout: memStdout } = await execAsync("free | grep Mem | awk '{printf \"%.2f\", $3/$2 * 100.0}'");
    const usage = parseFloat(memStdout.trim());
    
    // Memory power scales with usage
    const baseMemoryPower = 5; // Base memory power in watts
    return baseMemoryPower + (usage / 100) * 10; // Additional 10W at 100% usage
  } catch (error) {
    console.error('Error calculating memory power:', error.message);
    return 0;
  }
}

async function getDiskPower() {
  try {
    const { stdout: diskStdout } = await execAsync("iostat -d 1 1 | grep -E '^[a-z]' | awk '{sum+=$4} END {print sum}'");
    const ioRate = parseFloat(diskStdout.trim()) || 0;
    
    // Disk power based on I/O activity
    const baseDiskPower = 3; // Base disk power in watts
    return baseDiskPower + (ioRate / 100) * 5; // Additional 5W at high I/O
  } catch (error) {
    console.error('Error calculating disk power:', error.message);
    return 3; // Default disk power
  }
}

async function getNetworkPower() {
  try {
    const { stdout: netStdout } = await execAsync("cat /proc/net/dev | grep eth0 | awk '{print $2+$10}'");
    const bytes = parseInt(netStdout.trim()) || 0;
    
    // Network power based on data transfer
    const baseNetworkPower = 2; // Base network power in watts
    const transferPower = (bytes / 1000000) * 0.1; // 0.1W per MB
    return Math.min(baseNetworkPower + transferPower, 10); // Cap at 10W
  } catch (error) {
    console.error('Error calculating network power:', error.message);
    return 2; // Default network power
  }
}

async function getJenkinsPower() {
  try {
    // Get Jenkins process information
    const { stdout: jenkinsStdout } = await execAsync("ps aux | grep jenkins | grep -v grep | awk '{sum+=$3} END {print sum}'");
    const cpuUsage = parseFloat(jenkinsStdout.trim()) || 0;
    
    // Jenkins power based on CPU usage
    return (cpuUsage / 100) * 20; // Up to 20W for Jenkins
  } catch (error) {
    console.error('Error calculating Jenkins power:', error.message);
    return 0;
  }
}

async function calculateSystemPower() {
  try {
    energyData.cpuPower = await getCPUPower();
    energyData.memoryPower = await getMemoryPower();
    energyData.diskPower = await getDiskPower();
    energyData.networkPower = await getNetworkPower();
    energyData.jenkinsPower = await getJenkinsPower();
    
    // Total system power
    energyData.totalPower = energyData.cpuPower + 
                           energyData.memoryPower + 
                           energyData.diskPower + 
                           energyData.networkPower + 
                           energyData.jenkinsPower;
    
    // System base power (idle power consumption)
    const basePower = 20; // Base system power in watts
    energyData.systemPower = basePower + energyData.totalPower;
    
    // Energy efficiency calculation (work done per watt)
    const workEfficiency = energyData.jenkinsPower > 0 ? 
      (energyData.jenkinsPower / energyData.totalPower) * 100 : 0;
    energyData.energyEfficiency = workEfficiency;
    
    // Carbon footprint calculation (simplified)
    // Assuming 0.5 kg CO2 per kWh
    const carbonIntensity = 0.5; // kg CO2 per kWh
    const powerInKW = energyData.systemPower / 1000;
    energyData.carbonFootprint = powerInKW * carbonIntensity;
    
  } catch (error) {
    console.error('Error calculating system power:', error.message);
  }
}

// Send metrics to Prometheus
async function sendMetricsToPrometheus() {
  try {
    const metrics = generatePrometheusMetrics();
    
    // Send to Prometheus pushgateway or direct API
    const response = await axios.post(`${PROMETHEUS_URL}/api/v1/import/prometheus`, metrics, {
      headers: { 'Content-Type': 'text/plain' }
    });
    
    console.log('✅ Metrics sent to Prometheus');
  } catch (error) {
    console.error('Error sending metrics to Prometheus:', error.message);
  }
}

// Generate Prometheus metrics
function generatePrometheusMetrics() {
  let metrics = '';
  
  // System power metrics
  metrics += `# HELP system_power_consumption_watts Total system power consumption\n`;
  metrics += `# TYPE system_power_consumption_watts gauge\n`;
  metrics += `system_power_consumption_watts ${energyData.systemPower}\n\n`;
  
  metrics += `# HELP cpu_power_consumption_watts CPU power consumption\n`;
  metrics += `# TYPE cpu_power_consumption_watts gauge\n`;
  metrics += `cpu_power_consumption_watts ${energyData.cpuPower}\n\n`;
  
  metrics += `# HELP memory_power_consumption_watts Memory power consumption\n`;
  metrics += `# TYPE memory_power_consumption_watts gauge\n`;
  metrics += `memory_power_consumption_watts ${energyData.memoryPower}\n\n`;
  
  metrics += `# HELP disk_power_consumption_watts Disk power consumption\n`;
  metrics += `# TYPE disk_power_consumption_watts gauge\n`;
  metrics += `disk_power_consumption_watts ${energyData.diskPower}\n\n`;
  
  metrics += `# HELP network_power_consumption_watts Network power consumption\n`;
  metrics += `# TYPE network_power_consumption_watts gauge\n`;
  metrics += `network_power_consumption_watts ${energyData.networkPower}\n\n`;
  
  metrics += `# HELP jenkins_power_consumption_watts Jenkins power consumption\n`;
  metrics += `# TYPE jenkins_power_consumption_watts gauge\n`;
  metrics += `jenkins_power_consumption_watts ${energyData.jenkinsPower}\n\n`;
  
  metrics += `# HELP energy_efficiency_percent Energy efficiency percentage\n`;
  metrics += `# TYPE energy_efficiency_percent gauge\n`;
  metrics += `energy_efficiency_percent ${energyData.energyEfficiency}\n\n`;
  
  metrics += `# HELP carbon_footprint_kg_co2 Carbon footprint in kg CO2\n`;
  metrics += `# TYPE carbon_footprint_kg_co2 gauge\n`;
  metrics += `carbon_footprint_kg_co2 ${energyData.carbonFootprint}\n\n`;
  
  return metrics;
}

// API endpoints
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    service: 'energy-collector',
    timestamp: new Date().toISOString(),
    systemPower: energyData.systemPower
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

app.get('/energy-data', (req, res) => {
  try {
    res.json({
      timestamp: new Date().toISOString(),
      energyData: energyData
    });
  } catch (error) {
    console.error('Error getting energy data:', error);
    res.status(500).json({ error: 'Failed to get energy data' });
  }
});

app.post('/calculate-energy', async (req, res) => {
  try {
    await calculateSystemPower();
    res.json({
      success: true,
      message: 'Energy calculation completed',
      energyData: energyData
    });
  } catch (error) {
    console.error('Error calculating energy:', error);
    res.status(500).json({ error: 'Failed to calculate energy' });
  }
});

// Start server
app.listen(port, () => {
  console.log(`⚡ Energy Collector Server running on port ${port}`);
  console.log(`📊 Metrics endpoint: http://localhost:${port}/metrics`);
  console.log(`🔍 Health check: http://localhost:${port}/health`);
  console.log(`🎯 Ready to collect energy metrics!`);
});

// Start periodic energy calculation
setInterval(async () => {
  await calculateSystemPower();
  console.log(`⚡ System Power: ${energyData.systemPower.toFixed(2)}W, Efficiency: ${energyData.energyEfficiency.toFixed(2)}%`);
}, COLLECTION_INTERVAL * 1000);

// Send metrics to Prometheus every 5 minutes
setInterval(async () => {
  await sendMetricsToPrometheus();
}, 300000);

// Initial calculation
calculateSystemPower();

module.exports = app;





