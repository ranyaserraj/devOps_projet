# IDURAR ERP CRM - Heavy Baseline Tests Runner (PowerShell)
Write-Host "🔥 Starting IDURAR ERP CRM Heavy Baseline Tests" -ForegroundColor Red
Write-Host "⚠️  WARNING: These tests consume significant resources and CO₂" -ForegroundColor Yellow
Write-Host "🌱 CO₂ optimization will be implemented later" -ForegroundColor Green

# Set environment variables
$env:HEAVY_TEST_MODE = "true"
$env:CONCURRENT_REQUESTS = "100"
$env:TEST_DURATION = "300000"
$env:API_URL = "http://localhost:5000"
$env:FRONTEND_URL = "http://localhost:3000"

# Start application services
Write-Host "🚀 Starting application services..." -ForegroundColor Blue
cd ..
docker-compose up -d

# Wait for services to be ready
Write-Host "⏳ Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep 30

# Check if services are running
Write-Host "🔍 Checking service status..." -ForegroundColor Blue
docker ps

# Install test dependencies
Write-Host "📦 Installing test dependencies..." -ForegroundColor Blue
cd tests
npm install

# Run tests
Write-Host "🧪 Running heavy baseline tests..." -ForegroundColor Red

# Backend API tests
Write-Host "🔥 Running heavy backend API tests..." -ForegroundColor Red
npm run test:integration -- --testPathPattern=backend

# Frontend UI tests
Write-Host "🎨 Running heavy frontend UI tests..." -ForegroundColor Red
npm run test -- --testPathPattern=frontend

# Performance tests
Write-Host "⚡ Running heavy performance tests..." -ForegroundColor Red
npm run test:performance

# Load tests
Write-Host "🔥 Running heavy load tests..." -ForegroundColor Red
npm run test:load

Write-Host "✅ Heavy baseline tests completed!" -ForegroundColor Green
Write-Host "📊 Check test reports in the coverage directory" -ForegroundColor Blue
Write-Host "🌱 CO₂ optimization will be implemented in future iterations" -ForegroundColor Green
