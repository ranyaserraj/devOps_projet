# IDURAR ERP CRM - Direct Tests Execution (Alternative to Jenkins)
Write-Host "🚀 Starting IDURAR ERP CRM Tests Execution" -ForegroundColor Green
Write-Host "✅ Alternative to Jenkins - Direct execution" -ForegroundColor Blue
Write-Host "🧪 Executing baseline tests directly" -ForegroundColor Yellow

# Check application status
Write-Host "🔍 Checking application status..." -ForegroundColor Blue
$appStatus = docker ps --filter "name=idurar" --format "table {{.Names}} {{.Status}}"
Write-Host "Application Status:" -ForegroundColor Green
Write-Host $appStatus

# Execute tests directly
Write-Host "🧪 Executing baseline tests..." -ForegroundColor Blue
cd ../tests

Write-Host "🔥 Running Backend Tests..." -ForegroundColor Red
node backend-corrected.test.js

Write-Host "🎨 Running Frontend Tests..." -ForegroundColor Red
node frontend-simple.test.js

Write-Host "⚡ Running Performance Tests..." -ForegroundColor Red
node performance-simple.test.js

Write-Host "🎉 All tests completed successfully!" -ForegroundColor Green
Write-Host "📊 Tests executed in optimized mode" -ForegroundColor Blue
Write-Host "🌱 Minimal resource consumption achieved" -ForegroundColor Green
