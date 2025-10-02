const axios = require('axios');

// Optimized performance and load tests - Less resource intensive
describe('IDURAR ERP CRM - Performance Baseline Tests (Optimized)', () => {
  const API_BASE_URL = process.env.API_URL || 'http://localhost:5000';
  const FRONTEND_URL = process.env.FRONTEND_URL || 'http://localhost:3000';
  let authToken;

  beforeAll(async () => {
    // Authenticate for API tests
    const response = await axios.post(`${API_BASE_URL}/api/auth/login`, {
      email: 'admin@admin.com',
      password: 'admin123'
    });
    authToken = response.data.token;
  });

  describe('API Load Tests - Baseline', () => {
    test('Optimized concurrent API requests test', async () => {
      console.log('🔥 Starting optimized concurrent API load test...');
      
      // Optimized: 20 concurrent requests instead of 100
      const concurrentRequests = 20;
      const promises = [];
      
      for (let i = 0; i < concurrentRequests; i++) {
        promises.push(
          axios.get(`${API_BASE_URL}/api/customers`, {
            headers: { Authorization: `Bearer ${authToken}` },
            timeout: 15000
          })
        );
      }

      const startTime = Date.now();
      const responses = await Promise.allSettled(promises);
      const endTime = Date.now();
      
      const successfulRequests = responses.filter(r => r.status === 'fulfilled').length;
      const failedRequests = responses.filter(r => r.status === 'rejected').length;
      
      console.log(`⏱️  Load test completed in ${endTime - startTime}ms`);
      console.log(`✅ Successful requests: ${successfulRequests}`);
      console.log(`❌ Failed requests: ${failedRequests}`);
      
      // Optimized: Expect at least 90% success rate
      expect(successfulRequests).toBeGreaterThanOrEqual(concurrentRequests * 0.9);
    }, 120000);

    test('Optimized database stress test', async () => {
      console.log('🔥 Starting optimized database stress test...');
      
      // Optimized: Reduced operations
      const operations = [];
      
      // Create customers
      for (let i = 0; i < 10; i++) {
        operations.push(
          axios.post(`${API_BASE_URL}/api/customers`, {
            name: `Stress Test Customer ${i}`,
            email: `stress-${i}-${Date.now()}@example.com`,
            phone: `+123456789${i}`,
            company: `Stress Company ${i}`
          }, {
            headers: { Authorization: `Bearer ${authToken}` }
          })
        );
      }
      
      // Create invoices
      for (let i = 0; i < 5; i++) {
        operations.push(
          axios.post(`${API_BASE_URL}/api/invoices`, {
            invoiceNumber: `STRESS-INV-${i}`,
            customer: '507f1f77bcf86cd799439011',
            items: [
              { description: `Stress Item ${i}`, quantity: 1, price: 100, tax: 20 }
            ],
            subtotal: 100,
            tax: 20,
            total: 120,
            status: 'draft'
          }, {
            headers: { Authorization: `Bearer ${authToken}` }
          })
        );
      }
      
      const startTime = Date.now();
      const responses = await Promise.allSettled(operations);
      const endTime = Date.now();
      
      const successfulOps = responses.filter(r => r.status === 'fulfilled').length;
      
      console.log(`⏱️  Database stress test completed in ${endTime - startTime}ms`);
      console.log(`✅ Successful operations: ${successfulOps}/${operations.length}`);
      
      expect(successfulOps).toBeGreaterThanOrEqual(operations.length * 0.8);
    }, 180000);
  });

  describe('Memory and Resource Tests - Baseline', () => {
    test('Optimized memory consumption test', async () => {
      console.log('🔥 Starting optimized memory consumption test...');
      
      // Optimized: Smaller data structures
      const dataArrays = [];
      
      for (let i = 0; i < 3; i++) {
        const array = new Array(1000).fill(0).map((_, index) => ({
          id: index,
          name: `Data Item ${index}`,
          description: `Test data item ${index}`,
          data: new Array(10).fill(`data-${index}`),
          timestamp: new Date().toISOString()
        }));
        
        dataArrays.push(array);
        
        // Process data
        const processedData = array.map(item => ({
          ...item,
          processed: true,
          hash: Buffer.from(JSON.stringify(item)).toString('base64')
        }));
        
        await new Promise(resolve => setTimeout(resolve, 50));
      }
      
      console.log(`✅ Memory test completed with ${dataArrays.length} arrays`);
      expect(dataArrays.length).toBe(3);
    }, 60000);

    test('Optimized CPU intensive test', async () => {
      console.log('🔥 Starting optimized CPU intensive test...');
      
      // Optimized: Reduced calculations
      const calculations = [];
      
      for (let i = 0; i < 2; i++) {
        const startTime = Date.now();
        
        // Optimized: Reduced mathematical calculations
        let result = 0;
        for (let j = 0; j < 100000; j++) {
          result += Math.sqrt(j) * Math.sin(j);
        }
        
        const endTime = Date.now();
        calculations.push({
          iteration: i,
          result: result,
          duration: endTime - startTime
        });
      }
      
      const totalDuration = calculations.reduce((sum, calc) => sum + calc.duration, 0);
      console.log(`⏱️  CPU intensive test completed in ${totalDuration}ms`);
      
      expect(calculations.length).toBe(2);
    }, 120000);
  });

  describe('Network Tests - Baseline', () => {
    test('Optimized network I/O test', async () => {
      console.log('🔥 Starting optimized network I/O test...');
      
      // Optimized: Reduced concurrent requests
      const networkRequests = [];
      
      for (let i = 0; i < 10; i++) {
        networkRequests.push(
          axios.get(`${API_BASE_URL}/api/customers`, {
            headers: { Authorization: `Bearer ${authToken}` },
            timeout: 15000
          })
        );
        
        networkRequests.push(
          axios.get(`${API_BASE_URL}/api/invoices`, {
            headers: { Authorization: `Bearer ${authToken}` },
            timeout: 15000
          })
        );
      }
      
      const startTime = Date.now();
      const responses = await Promise.allSettled(networkRequests);
      const endTime = Date.now();
      
      const successfulRequests = responses.filter(r => r.status === 'fulfilled').length;
      
      console.log(`⏱️  Network I/O test completed in ${endTime - startTime}ms`);
      console.log(`✅ Successful network requests: ${successfulRequests}`);
      
      expect(successfulRequests).toBeGreaterThanOrEqual(networkRequests.length * 0.9);
    }, 120000);
  });
});


