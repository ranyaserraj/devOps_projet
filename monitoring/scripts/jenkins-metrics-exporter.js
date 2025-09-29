const express = require('express');
const axios = require('axios');
const { MetricsCollector } = require('./metrics-collector');

const app = express();
const metricsCollector = new MetricsCollector();

// Jenkins configuration
const JENKINS_URL = process.env.JENKINS_URL || 'http://jenkins:8080';
const JENKINS_USER = process.env.JENKINS_USER || 'admin';
const JENKINS_TOKEN = process.env.JENKINS_TOKEN || '';

// Start metrics collection
metricsCollector.startCollection(30000); // Collect every 30 seconds

// Jenkins API client
class JenkinsApiClient {
  constructor(baseUrl, username, token) {
    this.baseUrl = baseUrl;
    this.auth = Buffer.from(`${username}:${token}`).toString('base64');
  }

  async getJobs() {
    try {
      const response = await axios.get(`${this.baseUrl}/api/json`, {
        headers: { Authorization: `Basic ${this.auth}` }
      });
      return response.data.jobs;
    } catch (error) {
      console.error('Error fetching Jenkins jobs:', error.message);
      return [];
    }
  }

  async getJobDetails(jobName) {
    try {
      const response = await axios.get(`${this.baseUrl}/job/${jobName}/api/json`, {
        headers: { Authorization: `Basic ${this.auth}` }
      });
      return response.data;
    } catch (error) {
      console.error(`Error fetching job details for ${jobName}:`, error.message);
      return null;
    }
  }

  async getBuildDetails(jobName, buildNumber) {
    try {
      const response = await axios.get(`${this.baseUrl}/job/${jobName}/${buildNumber}/api/json`, {
        headers: { Authorization: `Basic ${this.auth}` }
      });
      return response.data;
    } catch (error) {
      console.error(`Error fetching build details for ${jobName}#${buildNumber}:`, error.message);
      return null;
    }
  }
}

const jenkinsClient = new JenkinsApiClient(JENKINS_URL, JENKINS_USER, JENKINS_TOKEN);

// Collect Jenkins metrics
async function collectJenkinsMetrics() {
  try {
    const jobs = await jenkinsClient.getJobs();
    
    for (const job of jobs) {
      const jobDetails = await jenkinsClient.getJobDetails(job.name);
      
      if (jobDetails) {
        // Record job metrics
        const lastBuild = jobDetails.lastBuild;
        if (lastBuild) {
          const buildDetails = await jenkinsClient.getBuildDetails(job.name, lastBuild.number);
          
          if (buildDetails) {
            // Record build duration
            const duration = buildDetails.duration / 1000; // Convert to seconds
            metricsCollector.recordTestExecution(
              'jenkins_build',
              job.name,
              duration,
              buildDetails.result === 'SUCCESS' ? 'success' : 'failure'
            );

            // Record build result
            metricsCollector.recordTestExecution(
              'jenkins_build',
              job.name,
              0,
              buildDetails.result === 'SUCCESS' ? 'success' : 'failure'
            );
          }
        }

        // Record job status
        const result = jobDetails.lastCompletedBuild?.result || 'UNKNOWN';
        metricsCollector.recordTestExecution(
          'jenkins_job',
          job.name,
          0,
          result === 'SUCCESS' ? 'success' : 'failure'
        );
      }
    }
  } catch (error) {
    console.error('Error collecting Jenkins metrics:', error.message);
  }
}

// Start Jenkins metrics collection
setInterval(collectJenkinsMetrics, 60000); // Collect every minute

// API endpoints
app.get('/metrics', async (req, res) => {
  try {
    const metrics = await metricsCollector.getMetrics();
    res.set('Content-Type', 'text/plain');
    res.send(metrics);
  } catch (error) {
    res.status(500).send('Error generating metrics');
  }
});

app.get('/health', (req, res) => {
  res.json({ status: 'healthy', timestamp: new Date().toISOString() });
});

// Start server
const PORT = process.env.PORT || 9091;
app.listen(PORT, () => {
  console.log(`Jenkins metrics exporter running on port ${PORT}`);
  console.log(`Metrics available at http://localhost:${PORT}/metrics`);
});

// Initial metrics collection
collectJenkinsMetrics();

