const request = require('supertest');
const axios = require('axios');

// Optimized baseline tests for backend API - Less resource intensive
describe('IDURAR ERP CRM - Backend API Baseline Tests (Optimized)', () => {
  const API_BASE_URL = process.env.API_URL || 'http://localhost:5000';
  let authToken;
  let testUserId;

  beforeAll(async () => {
    console.log('🔧 Setting up optimized backend API tests...');
    // Wait for service to be ready
    await global.testUtils.waitForService(`${API_BASE_URL}/api`);
  });

  describe('Authentication Endpoints - Baseline', () => {
    test('POST /api/auth/login - Optimized login test', async () => {
      const loginScenarios = [
        { email: 'admin@admin.com', password: 'admin123' },
        { email: 'invalid@test.com', password: 'wrongpassword' }
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
    }, 30000);

    test('POST /api/auth/register - Optimized registration test', async () => {
      const testData = global.testUtils.generateTestData();
      
      const response = await request(API_BASE_URL)
        .post('/api/auth/register')
        .send(testData)
        .expect('Content-Type', /json/);

      expect(response.body.success).toBe(true);
      testUserId = response.body.user?.id;
    }, 30000);
  });

  describe('Customer Management - Baseline', () => {
    test('GET /api/customers - Optimized customer listing', async () => {
      const response = await request(API_BASE_URL)
        .get('/api/customers')
        .set('Authorization', `Bearer ${authToken}`)
        .expect('Content-Type', /json/);

      expect(response.status).toBe(200);
      expect(response.body.success).toBe(true);
    }, 30000);

    test('POST /api/customers - Optimized customer creation', async () => {
      const customerData = {
        name: `Test Customer ${Date.now()}`,
        email: `customer-${Date.now()}@example.com`,
        phone: `+1234567890`,
        address: {
          street: 'Test Street',
          city: 'Test City',
          country: 'Test Country',
          zipCode: '12345'
        },
        company: 'Test Company',
        notes: 'Baseline test customer'
      };

      const response = await request(API_BASE_URL)
        .post('/api/customers')
        .set('Authorization', `Bearer ${authToken}`)
        .send(customerData)
        .expect('Content-Type', /json/);

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
    }, 30000);
  });

  describe('Invoice Management - Baseline', () => {
    test('POST /api/invoices - Optimized invoice creation', async () => {
      const invoiceData = {
        customer: testUserId || '507f1f77bcf86cd799439011',
        invoiceNumber: `INV-${Date.now()}`,
        date: new Date().toISOString(),
        dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
        items: [
          {
            description: 'Test Item 1',
            quantity: 2,
            price: 100,
            tax: 20
          },
          {
            description: 'Test Item 2',
            quantity: 1,
            price: 50,
            tax: 10
          }
        ],
        subtotal: 250,
        tax: 50,
        total: 300,
        status: 'draft',
        notes: 'Baseline test invoice'
      };

      const response = await request(API_BASE_URL)
        .post('/api/invoices')
        .set('Authorization', `Bearer ${authToken}`)
        .send(invoiceData)
        .expect('Content-Type', /json/);

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
    }, 30000);
  });

  describe('Database Performance - Baseline', () => {
    test('Optimized database operations test', async () => {
      const operations = [
        request(API_BASE_URL)
          .get('/api/customers')
          .set('Authorization', `Bearer ${authToken}`)
          .query({ page: 1, limit: 10 }),
        request(API_BASE_URL)
          .get('/api/invoices')
          .set('Authorization', `Bearer ${authToken}`)
          .query({ page: 1, limit: 10 })
      ];

      const startTime = Date.now();
      const responses = await Promise.all(operations);
      const endTime = Date.now();
      
      console.log(`⏱️  Database operations completed in ${endTime - startTime}ms`);
      
      responses.forEach(response => {
        expect(response.status).toBe(200);
      });
    }, 60000);
  });
});
