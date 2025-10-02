/**
 * IDURAR ERP CRM Enhanced Connectivity Tests
 * Tests with better error handling and retry logic
 */

const axios = require('axios');

console.log('🌐 Starting IDURAR ERP CRM Enhanced Connectivity Tests');
console.log('🔧 Testing connectivity with enhanced error handling...');

// Configuration
const BACKEND_URL = process.env.API_URL || 'http://host.docker.internal:5000';
const FRONTEND_URL = process.env.FRONTEND_URL || 'http://host.docker.internal:3000';
const MAX_RETRIES = 3;
const RETRY_DELAY = 2000; // 2 seconds

// Helper function for retry logic
const retryRequest = async (url, maxRetries = MAX_RETRIES) => {
    for (let attempt = 1; attempt <= maxRetries; attempt++) {
        try {
            console.log(`  Attempt ${attempt}/${maxRetries}: Testing ${url}`);
            const response = await axios.get(url, { 
                timeout: 5000,
                validateStatus: (status) => status < 500 // Accept 4xx as valid responses
            });
            return { success: true, status: response.status, data: response.data };
        } catch (error) {
            console.log(`  ❌ Attempt ${attempt} failed: ${error.message}`);
            if (attempt < maxRetries) {
                console.log(`  ⏳ Waiting ${RETRY_DELAY}ms before retry...`);
                await new Promise(resolve => setTimeout(resolve, RETRY_DELAY));
            }
        }
    }
    return { success: false, error: 'All retry attempts failed' };
};

// Test 1: Backend connectivity with retry
console.log('📝 Test 1: Backend connectivity (Enhanced)');
const backendResult = await retryRequest(BACKEND_URL);
if (backendResult.success) {
    console.log(`✅ Backend accessible - Status: ${backendResult.status}`);
} else {
    console.log(`❌ Backend not accessible - ${backendResult.error}`);
}

// Test 2: Frontend connectivity with retry
console.log('📝 Test 2: Frontend connectivity (Enhanced)');
const frontendResult = await retryRequest(FRONTEND_URL);
if (frontendResult.success) {
    console.log(`✅ Frontend accessible - Status: ${frontendResult.status}`);
} else {
    console.log(`❌ Frontend not accessible - ${frontendResult.error}`);
}

// Test 3: Backend health check
console.log('📝 Test 3: Backend health check');
const healthResult = await retryRequest(`${BACKEND_URL}/health`);
if (healthResult.success) {
    console.log(`✅ Backend health check passed - Status: ${healthResult.status}`);
} else {
    console.log(`⚠️ Backend health check failed - ${healthResult.error}`);
}

// Test 4: Frontend static assets
console.log('📝 Test 4: Frontend static assets');
const assetsResult = await retryRequest(`${FRONTEND_URL}/static`);
if (assetsResult.success) {
    console.log(`✅ Frontend assets accessible - Status: ${assetsResult.status}`);
} else {
    console.log(`⚠️ Frontend assets not accessible - ${assetsResult.error}`);
}

// Test 5: API endpoints structure
console.log('📝 Test 5: API endpoints structure');
const apiEndpoints = [
    '/api/auth/login',
    '/api/users',
    '/api/orders',
    '/api/products'
];

let accessibleEndpoints = 0;
for (const endpoint of apiEndpoints) {
    const result = await retryRequest(`${BACKEND_URL}${endpoint}`);
    if (result.success) {
        accessibleEndpoints++;
        console.log(`  ✅ ${endpoint} - Status: ${result.status}`);
    } else {
        console.log(`  ❌ ${endpoint} - ${result.error}`);
    }
}

console.log(`✅ API structure validation: ${accessibleEndpoints}/${apiEndpoints.length} endpoints accessible`);

// Test 6: Response time analysis
console.log('📝 Test 6: Response time analysis');
const measureResponseTime = async (url) => {
    const start = Date.now();
    try {
        await axios.get(url, { timeout: 10000 });
        return Date.now() - start;
    } catch (error) {
        return null;
    }
};

const backendTime = await measureResponseTime(BACKEND_URL);
const frontendTime = await measureResponseTime(FRONTEND_URL);

if (backendTime !== null) {
    console.log(`✅ Backend response time: ${backendTime}ms`);
} else {
    console.log('❌ Backend response time: Unable to measure');
}

if (frontendTime !== null) {
    console.log(`✅ Frontend response time: ${frontendTime}ms`);
} else {
    console.log('❌ Frontend response time: Unable to measure');
}

// Test 7: Network configuration analysis
console.log('📝 Test 7: Network configuration analysis');
console.log('  Network configuration:');
console.log(`  - Backend URL: ${BACKEND_URL}`);
console.log(`  - Frontend URL: ${FRONTEND_URL}`);
console.log(`  - Max retries: ${MAX_RETRIES}`);
console.log(`  - Retry delay: ${RETRY_DELAY}ms`);

// Summary
console.log('📊 Enhanced Connectivity Summary:');
console.log(`  - Backend connectivity: ${backendResult.success ? '✅' : '❌'}`);
console.log(`  - Frontend connectivity: ${frontendResult.success ? '✅' : '❌'}`);
console.log(`  - Backend health: ${healthResult.success ? '✅' : '⚠️'}`);
console.log(`  - Frontend assets: ${assetsResult.success ? '✅' : '⚠️'}`);
console.log(`  - API endpoints: ${accessibleEndpoints}/${apiEndpoints.length} accessible`);
console.log(`  - Backend response time: ${backendTime !== null ? `${backendTime}ms` : 'N/A'}`);
console.log(`  - Frontend response time: ${frontendTime !== null ? `${frontendTime}ms` : 'N/A'}`);

// Overall success rate
const totalTests = 7;
const passedTests = [
    backendResult.success,
    frontendResult.success,
    healthResult.success,
    assetsResult.success,
    accessibleEndpoints > 0,
    backendTime !== null,
    frontendTime !== null
].filter(Boolean).length;

const successRate = (passedTests / totalTests) * 100;
console.log(`  - Overall success rate: ${successRate.toFixed(1)}%`);

if (successRate >= 80) {
    console.log('🎉 Enhanced connectivity tests completed successfully!');
} else if (successRate >= 50) {
    console.log('⚠️ Enhanced connectivity tests completed with warnings!');
} else {
    console.log('❌ Enhanced connectivity tests failed!');
}
