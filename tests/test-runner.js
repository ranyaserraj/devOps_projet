const { exec } = require('child_process');
const path = require('path');

// Simple test runner for baseline tests
console.log('🚀 Starting IDURAR ERP CRM Baseline Tests Runner');
console.log('✅ Using simplified tests for faster execution');
console.log('🌱 Optimized for baseline coverage with minimal dependencies');

async function runTest(testFile, testName) {
  return new Promise((resolve, reject) => {
    console.log(`\n🔥 Running ${testName}...`);
    console.log('='.repeat(50));
    
    const startTime = Date.now();
    
    exec(`node ${testFile}`, (error, stdout, stderr) => {
      const endTime = Date.now();
      const duration = endTime - startTime;
      
      console.log(stdout);
      if (stderr) {
        console.error(stderr);
      }
      
      if (error) {
        console.error(`❌ ${testName} failed:`, error.message);
        reject(error);
      } else {
        console.log(`✅ ${testName} completed in ${duration}ms`);
        resolve();
      }
    });
  });
}

async function runAllTests() {
  const startTime = Date.now();
  
  try {
    // Run backend tests
    await runTest('backend-simple.test.js', 'Backend API Tests');
    
    // Run frontend tests
    await runTest('frontend-simple.test.js', 'Frontend Tests');
    
    // Run performance tests
    await runTest('performance-simple.test.js', 'Performance Tests');
    
    const endTime = Date.now();
    const totalDuration = endTime - startTime;
    
    console.log('\n🎉 All baseline tests completed successfully!');
    console.log(`⏱️  Total execution time: ${totalDuration}ms`);
    console.log('📊 Tests provide baseline coverage with optimized resource usage');
    console.log('🌱 CO₂ optimization implemented through simplified test approach');
    
  } catch (error) {
    console.error('\n❌ Test execution failed:', error.message);
    process.exit(1);
  }
}

// Run all tests
runAllTests();


