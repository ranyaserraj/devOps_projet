const axios = require('axios');

// Simple baseline tests for frontend - Basic HTTP requests
console.log('🎨 Starting IDURAR ERP CRM Frontend Baseline Tests (Simple)');

const FRONTEND_URL = process.env.FRONTEND_URL || 'http://localhost:3000';

async function runFrontendTests() {
  try {
    console.log('🔧 Testing frontend endpoints...');
    
    // Test 1: Frontend page load
    console.log('📝 Test 1: Frontend page load');
    const startTime = Date.now();
    const frontendResponse = await axios.get(FRONTEND_URL, { timeout: 10000 });
    const endTime = Date.now();
    
    if (frontendResponse.status === 200) {
      console.log(`✅ Frontend loaded successfully in ${endTime - startTime}ms`);
    } else {
      console.log('❌ Frontend load failed');
      return;
    }
    
    // Test 2: Check if it's a React app
    console.log('📝 Test 2: Check React app structure');
    const htmlContent = frontendResponse.data;
    if (htmlContent.includes('react') || htmlContent.includes('React')) {
      console.log('✅ React application detected');
    } else {
      console.log('⚠️ React application not clearly detected');
    }
    
    // Test 3: Check for common elements
    console.log('📝 Test 3: Check for common UI elements');
    if (htmlContent.includes('login') || htmlContent.includes('signin')) {
      console.log('✅ Login/signin elements found');
    }
    
    if (htmlContent.includes('dashboard') || htmlContent.includes('menu')) {
      console.log('✅ Dashboard/menu elements found');
    }
    
    // Test 4: Performance test
    console.log('📝 Test 4: Frontend performance test');
    const performancePromises = [];
    
    for (let i = 0; i < 3; i++) {
      performancePromises.push(
        axios.get(FRONTEND_URL, { timeout: 5000 })
      );
    }
    
    const startPerfTime = Date.now();
    await Promise.all(performancePromises);
    const endPerfTime = Date.now();
    console.log(`✅ Frontend performance test completed in ${endPerfTime - startPerfTime}ms`);
    
    console.log('🎉 Frontend baseline tests completed successfully!');
    
  } catch (error) {
    console.error('❌ Frontend test failed:', error.message);
    if (error.response) {
      console.error('Response status:', error.response.status);
    }
  }
}

// Run tests
runFrontendTests();
