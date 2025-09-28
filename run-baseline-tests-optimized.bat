@echo off
REM IDURAR ERP CRM - Optimized Baseline Tests Runner (Batch)
echo 🔥 Starting IDURAR ERP CRM Optimized Baseline Tests
echo ✅ Tests are baseline but optimized for better performance
echo 🌱 Reduced resource consumption while maintaining coverage

REM Set environment variables
set HEAVY_TEST_MODE=false
set BASELINE_TEST_MODE=true
set CONCURRENT_REQUESTS=20
set TEST_DURATION=120000
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

REM Run optimized baseline tests
echo 🧪 Running optimized baseline tests...

REM Backend API baseline tests
echo 🔥 Running backend API baseline tests...
npm run test:baseline:backend

REM Frontend UI baseline tests
echo 🎨 Running frontend UI baseline tests...
npm run test:baseline:frontend

REM Performance baseline tests
echo ⚡ Running performance baseline tests...
npm run test:baseline:performance

echo ✅ Optimized baseline tests completed!
echo 📊 Check test reports in the coverage directory
echo 🌱 Tests are baseline with optimized resource consumption
pause
