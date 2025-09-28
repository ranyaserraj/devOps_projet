@echo off
REM IDURAR ERP CRM - Heavy Baseline Tests Runner (Batch)
echo 🔥 Starting IDURAR ERP CRM Heavy Baseline Tests
echo ⚠️  WARNING: These tests consume significant resources and CO₂
echo 🌱 CO₂ optimization will be implemented later

REM Set environment variables
set HEAVY_TEST_MODE=true
set CONCURRENT_REQUESTS=100
set TEST_DURATION=300000
set API_URL=http://localhost:5000
set FRONTEND_URL=http://localhost:3000

REM Start application services
echo 🚀 Starting application services...
docker-compose up -d

REM Wait for services to be ready
echo ⏳ Waiting for services to be ready...
timeout /t 30 /nobreak

REM Check if services are running
echo 🔍 Checking service status...
docker ps

REM Install test dependencies
echo 📦 Installing test dependencies...
cd tests
npm install

REM Run tests
echo 🧪 Running heavy baseline tests...

REM Backend API tests
echo 🔥 Running heavy backend API tests...
npm run test:integration -- --testPathPattern=backend

REM Frontend UI tests
echo 🎨 Running heavy frontend UI tests...
npm run test -- --testPathPattern=frontend

REM Performance tests
echo ⚡ Running heavy performance tests...
npm run test:performance

REM Load tests
echo 🔥 Running heavy load tests...
npm run test:load

echo ✅ Heavy baseline tests completed!
echo 📊 Check test reports in the coverage directory
echo 🌱 CO₂ optimization will be implemented in future iterations
pause
