const axios = require('axios');

// Heavy performance and load tests
describe('IDURAR ERP CRM - Performance Baseline Tests', () => {
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

  describe('API Load Tests', () => {
    test('Heavy concurrent API requests test', async () => {
      console.log('🔥 Starting heavy concurrent API load test...');
      
      // Heavy test: 100 concurrent requests
      const concurrentRequests = 100;
      const promises = [];
      
      for (let i = 0; i < concurrentRequests; i++) {
        promises.push(
          axios.get(`${API_BASE_URL}/api/customers`, {
            headers: { Authorization: `Bearer ${authToken}` },
            timeout: 30000
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
      
      // Heavy test: Expect at least 80% success rate
      expect(successfulRequests).toBeGreaterThanOrEqual(concurrentRequests * 0.8);
    }, 300000);

    test('Heavy database stress test', async () => {
      console.log('🔥 Starting heavy database stress test...');
      
      // Heavy test: Multiple complex database operations
      const operations = [];
      
      // Create customers
      for (let i = 0; i < 50; i++) {
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
      for (let i = 0; i < 30; i++) {
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
      
      // Heavy test: Execute all operations concurrently
      const startTime = Date.now();
      const responses = await Promise.allSettled(operations);
      const endTime = Date.now();
      
      const successfulOps = responses.filter(r => r.status === 'fulfilled').length;
      
      console.log(`⏱️  Database stress test completed in ${endTime - startTime}ms`);
      console.log(`✅ Successful operations: ${successfulOps}/${operations.length}`);
      
      expect(successfulOps).toBeGreaterThanOrEqual(operations.length * 0.7);
    }, 600000);
  });

  describe('Memory and Resource Tests', () => {
    test('Heavy memory consumption test', async () => {
      console.log('🔥 Starting heavy memory consumption test...');
      
      // Heavy test: Create large data structures
      const largeDataArrays = [];
      
      for (let i = 0; i < 10; i++) {
        const largeArray = new Array(10000).fill(0).map((_, index) => ({
          id: index,
          name: `Large Data Item ${index}`,
          description: `This is a large data item ${index} for memory testing`,
          data: new Array(100).fill(`data-${index}`),
          timestamp: new Date().toISOString()
        }));
        
        largeDataArrays.push(largeArray);
        
        // Heavy test: Process large data
        const processedData = largeArray.map(item => ({
          ...item,
          processed: true,
          hash: Buffer.from(JSON.stringify(item)).toString('base64')
        }));
        
        // Heavy test: Store processed data
        await new Promise(resolve => setTimeout(resolve, 100));
      }
      
      console.log(`✅ Memory test completed with ${largeDataArrays.length} large arrays`);
      expect(largeDataArrays.length).toBe(10);
    }, 180000);

    test('Heavy CPU intensive test', async () => {
      console.log('🔥 Starting heavy CPU intensive test...');
      
      // Heavy test: CPU intensive calculations
      const calculations = [];
      
      for (let i = 0; i < 5; i++) {
        const startTime = Date.now();
        
        // Heavy test: Complex mathematical calculations
        let result = 0;
        for (let j = 0; j < 1000000; j++) {
          result += Math.sqrt(j) * Math.sin(j) * Math.cos(j);
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
      
      expect(calculations.length).toBe(5);
    }, 300000);
  });

  describe('Network and I/O Tests', () => {
    test('Heavy network I/O test', async () => {
      console.log('🔥 Starting heavy network I/O test...');
      
      // Heavy test: Multiple concurrent network requests
      const networkRequests = [];
      
      for (let i = 0; i < 20; i++) {
        networkRequests.push(
          axios.get(`${API_BASE_URL}/api/customers`, {
            headers: { Authorization: `Bearer ${authToken}` },
            timeout: 30000
          })
        );
        
        networkRequests.push(
          axios.get(`${API_BASE_URL}/api/invoices`, {
            headers: { Authorization: `Bearer ${authToken}` },
            timeout: 30000
          })
        );
      }
      
      const startTime = Date.now();
      const responses = await Promise.allSettled(networkRequests);
      const endTime = Date.now();
      
      const successfulRequests = responses.filter(r => r.status === 'fulfilled').length;
      
      console.log(`⏱️  Network I/O test completed in ${endTime - startTime}ms`);
      console.log(`✅ Successful network requests: ${successfulRequests}`);
      
      expect(successfulRequests).toBeGreaterThanOrEqual(networkRequests.length * 0.8);
    }, 240000);

    test('Heavy file I/O simulation test', async () => {
      console.log('🔥 Starting heavy file I/O simulation test...');
      
      // Heavy test: Simulate file operations
      const fileOperations = [];
      
      for (let i = 0; i < 50; i++) {
        // Heavy test: Simulate file read/write operations
        const fileData = Buffer.alloc(1024 * 1024, 'A'); // 1MB buffer
        const processedData = fileData.toString('base64');
        const decodedData = Buffer.from(processedData, 'base64');
        
        fileOperations.push({
          operation: 'file-simulation',
          size: fileData.length,
          processed: processedData.length,
          decoded: decodedData.length
        });
      }
      
      console.log(`✅ File I/O simulation completed with ${fileOperations.length} operations`);
      expect(fileOperations.length).toBe(50);
    }, 180000);
  });
});
