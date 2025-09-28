const request = require('supertest');
const axios = require('axios');

// Heavy baseline tests for backend API
describe('IDURAR ERP CRM - Backend API Baseline Tests', () => {
  const API_BASE_URL = process.env.API_URL || 'http://localhost:5000';
  let authToken;
  let testUserId;

  beforeAll(async () => {
    console.log('🔧 Setting up backend API tests...');
    // Wait for service to be ready
    await global.testUtils.waitForService(`${API_BASE_URL}/api`);
  });

  describe('Authentication Endpoints', () => {
    test('POST /api/auth/login - Heavy login test with multiple attempts', async () => {
      const testData = global.testUtils.generateTestData();
      
      // Heavy test: Multiple login attempts with different scenarios
      const loginScenarios = [
        { email: 'admin@admin.com', password: 'admin123' },
        { email: testData.email, password: testData.password },
        { email: 'invalid@test.com', password: 'wrongpassword' },
        { email: '', password: '' },
        { email: 'admin@admin.com', password: '' }
      ];

      for (const scenario of loginScenarios) {
        const response = await request(API_BASE_URL)
          .post('/api/auth/login')
          .send(scenario)
          .expect('Content-Type', /json/);

        if (scenario.email === 'admin@admin.com' && scenario.password === 'admin123') {
          expect(response.body.success).toBe(true);
          authToken = response.body.token;
        }
      }
    }, 60000);

    test('POST /api/auth/register - Heavy registration test', async () => {
      const testData = global.testUtils.generateTestData();
      
      // Heavy test: Multiple registration attempts
      for (let i = 0; i < 5; i++) {
        const userData = {
          ...testData,
          email: `test-${Date.now()}-${i}@example.com`
        };

        const response = await request(API_BASE_URL)
          .post('/api/auth/register')
          .send(userData)
          .expect('Content-Type', /json/);

        if (i === 0) {
          expect(response.body.success).toBe(true);
          testUserId = response.body.user?.id;
        }
      }
    }, 60000);
  });

  describe('Customer Management - Heavy Load Tests', () => {
    test('GET /api/customers - Heavy customer listing test', async () => {
      // Heavy test: Multiple concurrent requests
      const promises = [];
      for (let i = 0; i < 10; i++) {
        promises.push(
          request(API_BASE_URL)
            .get('/api/customers')
            .set('Authorization', `Bearer ${authToken}`)
            .expect('Content-Type', /json/)
        );
      }

      const responses = await Promise.all(promises);
      responses.forEach(response => {
        expect(response.status).toBe(200);
        expect(response.body.success).toBe(true);
      });
    }, 120000);

    test('POST /api/customers - Heavy customer creation test', async () => {
      // Heavy test: Create multiple customers with complex data
      const customerPromises = [];
      
      for (let i = 0; i < 20; i++) {
        const customerData = {
          name: `Customer ${i} - ${Date.now()}`,
          email: `customer-${i}-${Date.now()}@example.com`,
          phone: `+123456789${i}`,
          address: {
            street: `Test Street ${i}`,
            city: 'Test City',
            country: 'Test Country',
            zipCode: `1234${i}`
          },
          company: `Company ${i}`,
          notes: `This is a test customer ${i} created during baseline testing`
        };

        customerPromises.push(
          request(API_BASE_URL)
            .post('/api/customers')
            .set('Authorization', `Bearer ${authToken}`)
            .send(customerData)
            .expect('Content-Type', /json/)
        );
      }

      const responses = await Promise.all(customerPromises);
      responses.forEach(response => {
        expect(response.status).toBe(201);
        expect(response.body.success).toBe(true);
      });
    }, 180000);
  });

  describe('Invoice Management - Resource Intensive Tests', () => {
    test('POST /api/invoices - Heavy invoice creation test', async () => {
      // Heavy test: Create complex invoices with multiple line items
      const invoicePromises = [];
      
      for (let i = 0; i < 15; i++) {
        const invoiceData = {
          customer: testUserId || '507f1f77bcf86cd799439011',
          invoiceNumber: `INV-${Date.now()}-${i}`,
          date: new Date().toISOString(),
          dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
          items: Array.from({ length: Math.floor(Math.random() * 10) + 1 }, (_, idx) => ({
            description: `Test Item ${idx + 1}`,
            quantity: Math.floor(Math.random() * 10) + 1,
            price: Math.floor(Math.random() * 1000) + 10,
            tax: 20
          })),
          subtotal: 0,
          tax: 0,
          total: 0,
          status: 'draft',
          notes: `Test invoice ${i} created during baseline testing`
        };

        // Calculate totals
        invoiceData.subtotal = invoiceData.items.reduce((sum, item) => 
          sum + (item.quantity * item.price), 0);
        invoiceData.tax = invoiceData.subtotal * 0.2;
        invoiceData.total = invoiceData.subtotal + invoiceData.tax;

        invoicePromises.push(
          request(API_BASE_URL)
            .post('/api/invoices')
            .set('Authorization', `Bearer ${authToken}`)
            .send(invoiceData)
            .expect('Content-Type', /json/)
        );
      }

      const responses = await Promise.all(invoicePromises);
      responses.forEach(response => {
        expect(response.status).toBe(201);
        expect(response.body.success).toBe(true);
      });
    }, 240000);
  });

  describe('Database Performance Tests', () => {
    test('Heavy database operations test', async () => {
      // Heavy test: Complex database queries and operations
      const operations = [];
      
      // Multiple concurrent database operations
      for (let i = 0; i < 25; i++) {
        operations.push(
          request(API_BASE_URL)
            .get('/api/customers')
            .set('Authorization', `Bearer ${authToken}`)
            .query({ page: 1, limit: 50, search: `test-${i}` })
        );
        
        operations.push(
          request(API_BASE_URL)
            .get('/api/invoices')
            .set('Authorization', `Bearer ${authToken}`)
            .query({ page: 1, limit: 50, status: 'draft' })
        );
      }

      const startTime = Date.now();
      const responses = await Promise.all(operations);
      const endTime = Date.now();
      
      console.log(`⏱️  Database operations completed in ${endTime - startTime}ms`);
      
      responses.forEach(response => {
        expect(response.status).toBe(200);
      });
    }, 300000);
  });
});
