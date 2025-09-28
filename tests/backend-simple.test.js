const axios = require('axios');

// Simple baseline tests for backend API - No external dependencies
console.log('🔥 Starting IDURAR ERP CRM Backend API Baseline Tests (Simple)');

const API_BASE_URL = process.env.API_URL || 'http://localhost:5000';
let authToken;

async function runBackendTests() {
  try {
    console.log('🔧 Testing backend API endpoints...');
    
    // Test 1: Login
    console.log('📝 Test 1: Authentication');
    const loginResponse = await axios.post(`${API_BASE_URL}/api/auth/login`, {
      email: 'admin@admin.com',
      password: 'admin123'
    });
    
    if (loginResponse.data.success) {
      console.log('✅ Login successful');
      authToken = loginResponse.data.token;
    } else {
      console.log('❌ Login failed');
      return;
    }
    
    // Test 2: Get customers
    console.log('📝 Test 2: Get customers');
    const customersResponse = await axios.get(`${API_BASE_URL}/api/customers`, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    console.log(`✅ Customers retrieved: ${customersResponse.data.result?.length || 0} items`);
    
    // Test 3: Get invoices
    console.log('📝 Test 3: Get invoices');
    const invoicesResponse = await axios.get(`${API_BASE_URL}/api/invoices`, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    console.log(`✅ Invoices retrieved: ${invoicesResponse.data.result?.length || 0} items`);
    
    // Test 4: Create customer
    console.log('📝 Test 4: Create customer');
    const customerData = {
      name: `Test Customer ${Date.now()}`,
      email: `customer-${Date.now()}@example.com`,
      phone: '+1234567890',
      company: 'Test Company'
    };
    
    const createCustomerResponse = await axios.post(`${API_BASE_URL}/api/customers`, customerData, {
      headers: { Authorization: `Bearer ${authToken}` }
    });
    
    if (createCustomerResponse.data.success) {
      console.log('✅ Customer created successfully');
    } else {
      console.log('❌ Customer creation failed');
    }
    
    // Test 5: Performance test
    console.log('📝 Test 5: Performance test');
    const startTime = Date.now();
    const performancePromises = [];
    
    for (let i = 0; i < 5; i++) {
      performancePromises.push(
        axios.get(`${API_BASE_URL}/api/customers`, {
          headers: { Authorization: `Bearer ${authToken}` }
        })
      );
    }
    
    await Promise.all(performancePromises);
    const endTime = Date.now();
    console.log(`✅ Performance test completed in ${endTime - startTime}ms`);
    
    console.log('🎉 Backend API baseline tests completed successfully!');
    
  } catch (error) {
    console.error('❌ Backend test failed:', error.message);
    if (error.response) {
      console.error('Response status:', error.response.status);
      console.error('Response data:', error.response.data);
    }
  }
}

// Run tests
runBackendTests();
