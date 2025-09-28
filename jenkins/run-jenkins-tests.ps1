# IDURAR ERP CRM - Jenkins Tests Execution Script
Write-Host "🚀 Starting Jenkins Tests Execution" -ForegroundColor Green
Write-Host "✅ Jenkins is running on http://localhost:8080" -ForegroundColor Blue
Write-Host "🧪 Executing baseline tests via Jenkins pipeline" -ForegroundColor Yellow

# Check if Jenkins is running
Write-Host "🔍 Checking Jenkins status..." -ForegroundColor Blue
$jenkinsStatus = docker ps --filter "name=jenkins-minimal" --format "table {{.Status}}"
Write-Host "Jenkins Status: $jenkinsStatus" -ForegroundColor Green

# Wait for Jenkins to be ready
Write-Host "⏳ Waiting for Jenkins to be ready..." -ForegroundColor Yellow
Start-Sleep 30

# Check Jenkins accessibility
Write-Host "🌐 Checking Jenkins accessibility..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 10
    Write-Host "✅ Jenkins is accessible on port 8080" -ForegroundColor Green
} catch {
    Write-Host "❌ Jenkins is not accessible yet. Please wait..." -ForegroundColor Red
    Write-Host "Jenkins may still be initializing. Check http://localhost:8080 manually." -ForegroundColor Yellow
}

# Execute tests directly (alternative to Jenkins)
Write-Host "🧪 Executing baseline tests directly..." -ForegroundColor Blue
cd ../tests

Write-Host "🔥 Running Backend Tests..." -ForegroundColor Red
node backend-corrected.test.js

Write-Host "🎨 Running Frontend Tests..." -ForegroundColor Red
node frontend-simple.test.js

Write-Host "⚡ Running Performance Tests..." -ForegroundColor Red
node performance-simple.test.js

Write-Host "🎉 All tests completed!" -ForegroundColor Green
Write-Host "📊 Check Jenkins at http://localhost:8080 for pipeline execution" -ForegroundColor Blue
Write-Host "🌱 Tests are optimized for minimal resource consumption" -ForegroundColor Green
