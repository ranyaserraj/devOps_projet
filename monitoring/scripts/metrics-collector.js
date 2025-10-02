const prometheus = require('prom-client');
const axios = require('axios');

// Create a Registry to register the metrics
const register = new prometheus.Registry();

// Add a default label which is added to all metrics
register.setDefaultLabels({
  app: 'idurar-erp-crm',
  environment: 'ci-cd'
});

// Enable the collection of default metrics
prometheus.collectDefaultMetrics({ register });

// Custom metrics for CI/CD baseline monitoring
const testDurationHistogram = new prometheus.Histogram({
  name: 'test_duration_seconds',
  help: 'Duration of test execution in seconds',
  labelNames: ['test_type', 'test_suite'],
  buckets: [0.1, 0.5, 1, 2, 5, 10, 30, 60, 120, 300, 600]
});

const testTotalCounter = new prometheus.Counter({
  name: 'test_total',
  help: 'Total number of tests executed',
  labelNames: ['test_type', 'result', 'test_suite']
});

const testCoverageGauge = new prometheus.Gauge({
  name: 'test_coverage_percent',
  help: 'Test coverage percentage',
  labelNames: ['test_suite', 'coverage_type']
});

const apiResponseTimeHistogram = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'endpoint', 'status_code'],
  buckets: [0.1, 0.5, 1, 2, 5, 10, 30]
});

const apiRequestCounter = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'endpoint', 'status_code']
});

const resourceUsageGauge = new prometheus.Gauge({
  name: 'resource_usage',
  help: 'Resource usage metrics',
  labelNames: ['resource_type', 'container_name', 'metric_type']
});

// Register custom metrics
register.registerMetric(testDurationHistogram);
register.registerMetric(testTotalCounter);
register.registerMetric(testCoverageGauge);
register.registerMetric(apiResponseTimeHistogram);
register.registerMetric(apiRequestCounter);
register.registerMetric(resourceUsageGauge);

class MetricsCollector {
  constructor() {
    this.startTime = Date.now();
  }

  // Record test execution metrics
  recordTestExecution(testType, testSuite, duration, result) {
    testDurationHistogram
      .labels({ test_type: testType, test_suite: testSuite })
      .observe(duration);
    
    testTotalCounter
      .labels({ test_type: testType, result: result, test_suite: testSuite })
      .inc();
  }

  // Record test coverage
  recordTestCoverage(testSuite, coverageType, percentage) {
    testCoverageGauge
      .labels({ test_suite: testSuite, coverage_type: coverageType })
      .set(percentage);
  }

  // Record API metrics
  recordApiRequest(method, endpoint, statusCode, duration) {
    apiResponseTimeHistogram
      .labels({ method, endpoint, status_code: statusCode })
      .observe(duration);
    
    apiRequestCounter
      .labels({ method, endpoint, status_code: statusCode })
      .inc();
  }

  // Record resource usage
  recordResourceUsage(resourceType, containerName, metricType, value) {
    resourceUsageGauge
      .labels({ resource_type: resourceType, container_name: containerName, metric_type: metricType })
      .set(value);
  }

  // Get metrics in Prometheus format
  async getMetrics() {
    return register.metrics();
  }

  // Collect Docker container metrics
  async collectContainerMetrics() {
    try {
      const response = await axios.get('http://localhost:8080/api/v1.3/containers');
      const containers = response.data;

      containers.forEach(container => {
        if (container.spec && container.stats) {
          const stats = container.stats[container.stats.length - 1];
          
          // CPU usage
          const cpuUsage = this.calculateCpuUsage(stats);
          this.recordResourceUsage('cpu', container.name, 'usage_percent', cpuUsage);
          
          // Memory usage
          const memoryUsage = stats.memory.usage / (1024 * 1024); // Convert to MB
          this.recordResourceUsage('memory', container.name, 'usage_mb', memoryUsage);
          
          // Network I/O
          const networkRx = stats.network.rx_bytes;
          const networkTx = stats.network.tx_bytes;
          this.recordResourceUsage('network', container.name, 'rx_bytes', networkRx);
          this.recordResourceUsage('network', container.name, 'tx_bytes', networkTx);
        }
      });
    } catch (error) {
      console.error('Error collecting container metrics:', error.message);
    }
  }

  calculateCpuUsage(stats) {
    const cpuDelta = stats.cpu.usage.total - (stats.cpu.usage.per_cpu_usage?.reduce((a, b) => a + b, 0) || 0);
    const systemDelta = stats.cpu.usage.system_cpu_usage || 0;
    
    if (systemDelta > 0) {
      return (cpuDelta / systemDelta) * 100;
    }
    return 0;
  }

  // Start metrics collection
  startCollection(intervalMs = 30000) {
    setInterval(() => {
      this.collectContainerMetrics();
    }, intervalMs);
  }
}

module.exports = { MetricsCollector, register };



