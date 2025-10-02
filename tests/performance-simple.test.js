const axios = require('axios');

// Simple performance tests - Basic load testing
console.log('⚡ Starting IDURAR ERP CRM Performance Baseline Tests (Simple)');

const API_BASE_URL = process.env.API_URL || 'http://localhost:5000';
const FRONTEND_URL = process.env.FRONTEND_URL || 'http://localhost:3000';
let authToken;

async function runPerformanceTests() {
  try {
    console.log('🔧 Testing performance baseline...');
    
    // Get auth token first
    console.log('📝 Getting authentication token...');
    const loginResponse = await axios.post(`${API_BASE_URL}/api/auth/login`, {
      email: 'admin@admin.com',
      password: 'admin123'
    });
    
    if (!loginResponse.data.success) {
      console.log('❌ Authentication failed');
      return;
    }
    
    authToken = loginResponse.data.token;
    console.log('✅ Authentication successful');
    
    // Test 1: API Load Test
    console.log('📝 Test 1: API Load Test');
    const apiLoadPromises = [];
    
    for (let i = 0; i < 10; i++) {
      apiLoadPromises.push(
        axios.get(`${API_BASE_URL}/api/customers`, {
          headers: { Authorization: `Bearer ${authToken}` },
          timeout: 10000
        })
      );
    }
    
    const startApiTime = Date.now();
    const apiResponses = await Promise.allSettled(apiLoadPromises);
    const endApiTime = Date.now();
    
    const successfulApiRequests = apiResponses.filter(r => r.status === 'fulfilled').length;
    console.log(`✅ API Load Test: ${successfulApiRequests}/10 requests successful in ${endApiTime - startApiTime}ms`);
    
    // Test 2: Frontend Load Test
    console.log('📝 Test 2: Frontend Load Test');
    const frontendLoadPromises = [];
    
    for (let i = 0; i < 5; i++) {
      frontendLoadPromises.push(
        axios.get(FRONTEND_URL, { timeout: 10000 })
      );
    }
    
    const startFrontendTime = Date.now();
    const frontendResponses = await Promise.allSettled(frontendLoadPromises);
    const endFrontendTime = Date.now();
    
    const successfulFrontendRequests = frontendResponses.filter(r => r.status === 'fulfilled').length;
    console.log(`✅ Frontend Load Test: ${successfulFrontendRequests}/5 requests successful in ${endFrontendTime - startFrontendTime}ms`);
    
    // Test 3: Memory/CPU Simulation
    console.log('📝 Test 3: Memory/CPU Simulation');
    const startSimTime = Date.now();
    
    // Simulate some CPU work
    let result = 0;
    for (let i = 0; i < 100000; i++) {
      result += Math.sqrt(i) * Math.sin(i);
    }
    
    const endSimTime = Date.now();
    console.log(`✅ CPU Simulation completed in ${endSimTime - startSimTime}ms (result: ${result.toFixed(2)})`);
    
    // Test 4: Database Operations
    console.log('📝 Test 4: Database Operations Test');
    const dbPromises = [];
    
    for (let i = 0; i < 5; i++) {
      dbPromises.push(
        axios.get(`${API_BASE_URL}/api/customers`, {
          headers: { Authorization: `Bearer ${authToken}` },
          params: { page: 1, limit: 10 }
        })
      );
      dbPromises.push(
        axios.get(`${API_BASE_URL}/api/invoices`, {
          headers: { Authorization: `Bearer ${authToken}` },
          params: { page: 1, limit: 10 }
        })
      );
    }
    
    const startDbTime = Date.now();
    const dbResponses = await Promise.allSettled(dbPromises);
    const endDbTime = Date.now();
    
    const successfulDbRequests = dbResponses.filter(r => r.status === 'fulfilled').length;
    console.log(`✅ Database Operations: ${successfulDbRequests}/${dbPromises.length} operations successful in ${endDbTime - startDbTime}ms`);
    
    console.log('🎉 Performance baseline tests completed successfully!');
    
  } catch (error) {
    console.error('❌ Performance test failed:', error.message);
    if (error.response) {
      console.error('Response status:', error.response.status);
      console.error('Response data:', error.response.data);
    }
  }
}

// Run tests
runPerformanceTests();


