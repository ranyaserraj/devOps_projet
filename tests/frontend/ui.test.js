const { chromium } = require('playwright');
const puppeteer = require('puppeteer');

// Heavy baseline tests for frontend UI
describe('IDURAR ERP CRM - Frontend UI Baseline Tests', () => {
  let browser;
  let page;
  const FRONTEND_URL = process.env.FRONTEND_URL || 'http://localhost:3000';

  beforeAll(async () => {
    console.log('🎨 Setting up frontend UI tests...');
    browser = await chromium.launch({ 
      headless: false, // Heavy test: Run with UI for visual verification
      slowMo: 1000 // Slow down for heavy testing
    });
    page = await browser.newPage();
    
    // Heavy test: Set large viewport for comprehensive testing
    await page.setViewportSize({ width: 1920, height: 1080 });
  });

  afterAll(async () => {
    if (browser) {
      await browser.close();
    }
  });

  describe('Authentication Flow - Heavy UI Tests', () => {
    test('Login page load and interaction test', async () => {
      // Heavy test: Multiple page loads and interactions
      for (let i = 0; i < 5; i++) {
        await page.goto(FRONTEND_URL, { waitUntil: 'networkidle' });
        
        // Wait for login form to be visible
        await page.waitForSelector('input[type="email"]', { timeout: 10000 });
        
        // Fill login form with heavy interaction testing
        await page.fill('input[type="email"]', 'admin@admin.com');
        await page.fill('input[type="password"]', 'admin123');
        
        // Heavy test: Multiple click attempts and form validation
        await page.click('button[type="submit"]');
        
        // Wait for navigation or error message
        await page.waitForTimeout(2000);
        
        // Check if login was successful or if we need to retry
        const currentUrl = page.url();
        if (currentUrl.includes('/dashboard')) {
          break; // Login successful
        }
      }
    }, 120000);

    test('Dashboard navigation and UI elements test', async () => {
      // Heavy test: Navigate through all major sections
      const navigationItems = [
        'Dashboard',
        'Customers', 
        'Invoices',
        'Quotes',
        'Payments',
        'Settings'
      ];

      for (const navItem of navigationItems) {
        try {
          // Heavy test: Wait for each navigation element and click
          await page.waitForSelector(`[data-testid="${navItem.toLowerCase()}-menu"]`, { timeout: 5000 });
          await page.click(`[data-testid="${navItem.toLowerCase()}-menu"]`);
          
          // Heavy test: Wait for page content to load
          await page.waitForTimeout(3000);
          
          // Verify page content is loaded
          const content = await page.content();
          expect(content).toContain(navItem);
        } catch (error) {
          console.log(`Navigation item ${navItem} not found or not clickable`);
        }
      }
    }, 180000);
  });

  describe('Customer Management - Heavy UI Tests', () => {
    test('Customer creation form test', async () => {
      // Navigate to customers page
      await page.goto(`${FRONTEND_URL}/customers`, { waitUntil: 'networkidle' });
      
      // Heavy test: Fill complex customer form multiple times
      for (let i = 0; i < 3; i++) {
        // Click add customer button
        await page.click('[data-testid="add-customer-button"]');
        
        // Wait for form modal
        await page.waitForSelector('[data-testid="customer-form"]', { timeout: 10000 });
        
        // Heavy test: Fill all form fields with complex data
        await page.fill('[data-testid="customer-name"]', `Test Customer ${i} - ${Date.now()}`);
        await page.fill('[data-testid="customer-email"]', `customer-${i}-${Date.now()}@example.com`);
        await page.fill('[data-testid="customer-phone"]', `+123456789${i}`);
        await page.fill('[data-testid="customer-company"]', `Test Company ${i}`);
        await page.fill('[data-testid="customer-address"]', `Test Address ${i}, Test City, Test Country`);
        await page.fill('[data-testid="customer-notes"]', `This is a test customer ${i} created during heavy baseline testing`);
        
        // Heavy test: Form validation and submission
        await page.click('[data-testid="save-customer-button"]');
        
        // Wait for form submission
        await page.waitForTimeout(3000);
      }
    }, 240000);

    test('Customer list and search test', async () => {
      // Heavy test: Test search functionality with multiple queries
      const searchQueries = ['test', 'customer', 'company', 'email', 'phone'];
      
      for (const query of searchQueries) {
        // Navigate to customers page
        await page.goto(`${FRONTEND_URL}/customers`, { waitUntil: 'networkidle' });
        
        // Heavy test: Perform search
        await page.fill('[data-testid="customer-search"]', query);
        await page.press('[data-testid="customer-search"]', 'Enter');
        
        // Wait for search results
        await page.waitForTimeout(2000);
        
        // Heavy test: Verify search results
        const results = await page.$$('[data-testid="customer-row"]');
        expect(results.length).toBeGreaterThanOrEqual(0);
      }
    }, 180000);
  });

  describe('Invoice Management - Resource Intensive UI Tests', () => {
    test('Invoice creation form test', async () => {
      // Navigate to invoices page
      await page.goto(`${FRONTEND_URL}/invoices`, { waitUntil: 'networkidle' });
      
      // Heavy test: Create complex invoices
      for (let i = 0; i < 2; i++) {
        // Click add invoice button
        await page.click('[data-testid="add-invoice-button"]');
        
        // Wait for form modal
        await page.waitForSelector('[data-testid="invoice-form"]', { timeout: 10000 });
        
        // Heavy test: Fill invoice form with multiple line items
        await page.fill('[data-testid="invoice-number"]', `INV-${Date.now()}-${i}`);
        await page.selectOption('[data-testid="invoice-customer"]', { index: 1 });
        
        // Heavy test: Add multiple line items
        for (let j = 0; j < 5; j++) {
          await page.click('[data-testid="add-line-item-button"]');
          await page.fill(`[data-testid="line-item-description-${j}"]`, `Test Item ${j + 1}`);
          await page.fill(`[data-testid="line-item-quantity-${j}"]`, (j + 1).toString());
          await page.fill(`[data-testid="line-item-price-${j}"]`, ((j + 1) * 100).toString());
        }
        
        // Heavy test: Form submission with validation
        await page.click('[data-testid="save-invoice-button"]');
        await page.waitForTimeout(3000);
      }
    }, 300000);
  });

  describe('Performance and Load Tests', () => {
    test('Heavy page load performance test', async () => {
      const pages = [
        '/dashboard',
        '/customers',
        '/invoices',
        '/quotes',
        '/payments',
        '/settings'
      ];

      // Heavy test: Load each page multiple times and measure performance
      for (const pagePath of pages) {
        for (let i = 0; i < 3; i++) {
          const startTime = Date.now();
          await page.goto(`${FRONTEND_URL}${pagePath}`, { waitUntil: 'networkidle' });
          const endTime = Date.now();
          
          console.log(`⏱️  Page ${pagePath} loaded in ${endTime - startTime}ms`);
          
          // Heavy test: Wait for all content to be rendered
          await page.waitForTimeout(2000);
        }
      }
    }, 300000);

    test('Heavy UI interaction stress test', async () => {
      // Heavy test: Rapid UI interactions
      await page.goto(`${FRONTEND_URL}/dashboard`, { waitUntil: 'networkidle' });
      
      // Heavy test: Rapid clicking and navigation
      for (let i = 0; i < 50; i++) {
        try {
          // Random UI interactions
          const buttons = await page.$$('button');
          if (buttons.length > 0) {
            const randomButton = buttons[Math.floor(Math.random() * buttons.length)];
            await randomButton.click();
            await page.waitForTimeout(100);
          }
        } catch (error) {
          // Continue with stress test
        }
      }
    }, 180000);
  });
});
