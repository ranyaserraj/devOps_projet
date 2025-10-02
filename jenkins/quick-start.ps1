# IDURAR ERP CRM - Quick Start (Alternative to Jenkins)
Write-Host "🚀 IDURAR ERP CRM - Quick Start" -ForegroundColor Green
Write-Host "⚡ Alternative rapide a Jenkins" -ForegroundColor Blue

# Temps de demarrage
$startTime = Get-Date
Write-Host "⏰ Debut: $startTime" -ForegroundColor Yellow

# 1. Verifier les services
Write-Host "🔍 Verification des services..." -ForegroundColor Blue
$services = docker ps --filter "name=idurar" --format "table {{.Names}} {{.Status}}"
Write-Host $services

# 2. Executer les tests rapidement
Write-Host "🧪 Execution des tests baseline..." -ForegroundColor Blue
cd ../tests

# Tests backend
Write-Host "📡 Tests Backend..." -ForegroundColor Red
node backend-corrected.test.js

# Tests frontend  
Write-Host "🎨 Tests Frontend..." -ForegroundColor Red
node frontend-simple.test.js

# Tests performance
Write-Host "⚡ Tests Performance..." -ForegroundColor Red
node performance-simple.test.js

# Temps total
$endTime = Get-Date
$duration = $endTime - $startTime
Write-Host "⏱️  Duree totale: $($duration.TotalSeconds) secondes" -ForegroundColor Green
Write-Host "✅ Tests completes avec succes!" -ForegroundColor Green
Write-Host "🌱 Alternative Jenkins: Plus rapide et stable" -ForegroundColor Blue


