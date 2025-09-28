# IDURAR ERP CRM - Optimized Baseline Tests Runner (PowerShell)
Write-Host "🔥 Starting IDURAR ERP CRM Optimized Baseline Tests" -ForegroundColor Green
Write-Host "✅ Tests are baseline but optimized for better performance" -ForegroundColor Yellow
Write-Host "🌱 Reduced resource consumption while maintaining coverage" -ForegroundColor Green

# Set environment variables
$env:HEAVY_TEST_MODE = "false"
$env:BASELINE_TEST_MODE = "true"
$env:CONCURRENT_REQUESTS = "20"
$env:TEST_DURATION = "120000"
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

# Run optimized baseline tests
Write-Host "🧪 Running optimized baseline tests..." -ForegroundColor Green

# Backend API baseline tests
Write-Host "🔥 Running backend API baseline tests..." -ForegroundColor Green
npm run test:baseline:backend

# Frontend UI baseline tests
Write-Host "🎨 Running frontend UI baseline tests..." -ForegroundColor Green
npm run test:baseline:frontend

# Performance baseline tests
Write-Host "⚡ Running performance baseline tests..." -ForegroundColor Green
npm run test:baseline:performance

Write-Host "✅ Optimized baseline tests completed!" -ForegroundColor Green
Write-Host "📊 Check test reports in the coverage directory" -ForegroundColor Blue
Write-Host "🌱 Tests are baseline with optimized resource consumption" -ForegroundColor Green
