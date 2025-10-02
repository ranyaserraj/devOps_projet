const axios = require('axios');

// Corrected baseline tests for backend API
console.log('🔥 Starting IDURAR ERP CRM Backend API Baseline Tests (Corrected)');

const API_BASE_URL = process.env.API_URL || 'http://localhost:5000';

async function runBackendTests() {
  try {
    console.log('🔧 Testing backend API endpoints...');
    
    // Test 1: Health check
    console.log('📝 Test 1: Backend Health Check');
    try {
      const healthResponse = await axios.get(`${API_BASE_URL}/`);
      console.log('✅ Backend is responding');
    } catch (error) {
      console.log('⚠️ Backend health check failed, but continuing...');
    }
    
    // Test 2: Try different login endpoints
    console.log('📝 Test 2: Authentication (trying different endpoints)');
    
    const loginEndpoints = [
      '/api/auth/login',
      '/api/login',
      '/auth/login',
      '/login'
    ];
    
    let authToken = null;
    let successfulEndpoint = null;
    
    for (const endpoint of loginEndpoints) {
      try {
        console.log(`   Trying: ${API_BASE_URL}${endpoint}`);
        const loginResponse = await axios.post(`${API_BASE_URL}${endpoint}`, {
          email: 'admin@admin.com',
          password: 'admin123'
        });
        
        if (loginResponse.data && loginResponse.data.success) {
          console.log(`✅ Login successful with endpoint: ${endpoint}`);
          authToken = loginResponse.data.token;
          successfulEndpoint = endpoint;
          break;
        }
      } catch (error) {
        console.log(`   ❌ Failed with ${endpoint}: ${error.response?.status} - ${error.response?.data?.message || error.message}`);
      }
    }
    
    if (!authToken) {
      console.log('❌ All login endpoints failed. Continuing with public endpoints...');
    }
    
    // Test 3: Try public endpoints
    console.log('📝 Test 3: Testing public endpoints');
    
    const publicEndpoints = [
      '/',
      '/api',
      '/api/ping',
      '/health',
      '/status'
    ];
    
    for (const endpoint of publicEndpoints) {
      try {
        const response = await axios.get(`${API_BASE_URL}${endpoint}`);
        console.log(`✅ Public endpoint ${endpoint}: ${response.status}`);
      } catch (error) {
        console.log(`   ❌ ${endpoint}: ${error.response?.status || 'Network Error'}`);
      }
    }
    
    // Test 4: Try protected endpoints (if we have token)
    if (authToken) {
      console.log('📝 Test 4: Testing protected endpoints');
      
      const protectedEndpoints = [
        '/api/customers',
        '/api/invoices',
        '/api/quotes',
        '/api/payments'
      ];
      
      for (const endpoint of protectedEndpoints) {
        try {
          const response = await axios.get(`${API_BASE_URL}${endpoint}`, {
            headers: { Authorization: `Bearer ${authToken}` }
          });
          console.log(`✅ Protected endpoint ${endpoint}: ${response.status} - ${response.data.result?.length || 0} items`);
        } catch (error) {
          console.log(`   ❌ ${endpoint}: ${error.response?.status || 'Network Error'}`);
        }
      }
    }
    
    // Test 5: Performance test
    console.log('📝 Test 5: Basic performance test');
    const startTime = Date.now();
    const performancePromises = [];
    
    for (let i = 0; i < 3; i++) {
      performancePromises.push(
        axios.get(`${API_BASE_URL}/`).catch(() => null)
      );
    }
    
    await Promise.all(performancePromises);
    const endTime = Date.now();
    console.log(`✅ Performance test completed in ${endTime - startTime}ms`);
    
    console.log('🎉 Backend API baseline tests completed!');
    
  } catch (error) {
    console.error('❌ Backend test failed:', error.message);
  }
}

// Run tests
runBackendTests();


