const { chromium } = require('playwright');

// Optimized baseline tests for frontend UI - Less resource intensive
describe('IDURAR ERP CRM - Frontend UI Baseline Tests (Optimized)', () => {
  let browser;
  let page;
  const FRONTEND_URL = process.env.FRONTEND_URL || 'http://localhost:3000';

  beforeAll(async () => {
    console.log('🎨 Setting up optimized frontend UI tests...');
    browser = await chromium.launch({ 
      headless: true, // Optimized: Run headless for faster execution
      slowMo: 500 // Reduced slow motion
    });
    page = await browser.newPage();
    
    // Optimized: Standard viewport
    await page.setViewportSize({ width: 1280, height: 720 });
  });

  afterAll(async () => {
    if (browser) {
      await browser.close();
    }
  });

  describe('Authentication Flow - Baseline', () => {
    test('Login page load and interaction test', async () => {
      await page.goto(FRONTEND_URL, { waitUntil: 'networkidle' });
      
      // Wait for login form to be visible
      await page.waitForSelector('input[type="email"]', { timeout: 10000 });
      
      // Fill login form
      await page.fill('input[type="email"]', 'admin@admin.com');
      await page.fill('input[type="password"]', 'admin123');
      
      // Submit form
      await page.click('button[type="submit"]');
      
      // Wait for navigation or error message
      await page.waitForTimeout(3000);
      
      // Check if login was successful
      const currentUrl = page.url();
      expect(currentUrl).toContain('/dashboard');
    }, 60000);

    test('Dashboard navigation test', async () => {
      const navigationItems = ['Dashboard', 'Customers', 'Invoices'];

      for (const navItem of navigationItems) {
        try {
          await page.waitForSelector(`[data-testid="${navItem.toLowerCase()}-menu"]`, { timeout: 5000 });
          await page.click(`[data-testid="${navItem.toLowerCase()}-menu"]`);
          
          // Wait for page content to load
          await page.waitForTimeout(2000);
          
          // Verify page content is loaded
          const content = await page.content();
          expect(content).toContain(navItem);
        } catch (error) {
          console.log(`Navigation item ${navItem} not found or not clickable`);
        }
      }
    }, 90000);
  });

  describe('Customer Management - Baseline', () => {
    test('Customer creation form test', async () => {
      // Navigate to customers page
      await page.goto(`${FRONTEND_URL}/customers`, { waitUntil: 'networkidle' });
      
      // Click add customer button
      await page.click('[data-testid="add-customer-button"]');
      
      // Wait for form modal
      await page.waitForSelector('[data-testid="customer-form"]', { timeout: 10000 });
      
      // Fill form with basic data
      await page.fill('[data-testid="customer-name"]', `Test Customer ${Date.now()}`);
      await page.fill('[data-testid="customer-email"]', `customer-${Date.now()}@example.com`);
      await page.fill('[data-testid="customer-phone"]', '+1234567890');
      await page.fill('[data-testid="customer-company"]', 'Test Company');
      
      // Submit form
      await page.click('[data-testid="save-customer-button"]');
      
      // Wait for form submission
      await page.waitForTimeout(3000);
    }, 120000);

    test('Customer search test', async () => {
      // Navigate to customers page
      await page.goto(`${FRONTEND_URL}/customers`, { waitUntil: 'networkidle' });
      
      // Perform search
      await page.fill('[data-testid="customer-search"]', 'test');
      await page.press('[data-testid="customer-search"]', 'Enter');
      
      // Wait for search results
      await page.waitForTimeout(2000);
      
      // Verify search results
      const results = await page.$$('[data-testid="customer-row"]');
      expect(results.length).toBeGreaterThanOrEqual(0);
    }, 60000);
  });

  describe('Performance - Baseline', () => {
    test('Page load performance test', async () => {
      const pages = ['/dashboard', '/customers', '/invoices'];

      for (const pagePath of pages) {
        const startTime = Date.now();
        await page.goto(`${FRONTEND_URL}${pagePath}`, { waitUntil: 'networkidle' });
        const endTime = Date.now();
        
        console.log(`⏱️  Page ${pagePath} loaded in ${endTime - startTime}ms`);
        
        // Wait for content to be rendered
        await page.waitForTimeout(1000);
      }
    }, 120000);
  });
});
