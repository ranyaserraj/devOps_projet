// Test setup configuration
const { execSync } = require('child_process');

// Global test timeout
jest.setTimeout(30000);

// Setup before all tests
beforeAll(async () => {
  console.log('🚀 Starting IDURAR ERP CRM Baseline Tests');
  console.log('⚠️  Heavy resource consumption tests enabled');
  console.log('🌱 CO₂ optimization will be implemented later');
});

// Cleanup after all tests
afterAll(async () => {
  console.log('✅ Baseline tests completed');
});

// Global test utilities
global.testUtils = {
  generateTestData: () => ({
    email: `test-${Date.now()}@example.com`,
    password: 'TestPassword123!',
    company: 'Test Company Ltd',
    phone: '+1234567890'
  }),
  
  waitForService: async (url, timeout = 30000) => {
    const start = Date.now();
    while (Date.now() - start < timeout) {
      try {
        const response = await fetch(url);
        if (response.ok) return true;
      } catch (error) {
        // Service not ready yet
      }
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
    throw new Error(`Service at ${url} not available after ${timeout}ms`);
  }
};
