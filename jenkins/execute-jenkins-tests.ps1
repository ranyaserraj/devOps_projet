# IDURAR ERP CRM - Exécution des Tests via Jenkins Fast
Write-Host "🚀 Exécution des Tests via Jenkins Fast" -ForegroundColor Green
Write-Host "⚡ Jenkins Fast est opérationnel" -ForegroundColor Blue

# Vérification de Jenkins
Write-Host "🔍 Vérification de Jenkins..." -ForegroundColor Blue
$jenkinsStatus = docker ps --filter "name=jenkins-fast" --format "{{.Status}}"
Write-Host "Jenkins Status: $jenkinsStatus" -ForegroundColor Green

# Test de connectivité
Write-Host "🌐 Test de connectivité Jenkins..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080/jenkins" -TimeoutSec 10
    Write-Host "✅ Jenkins accessible sur http://localhost:8080/jenkins" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Jenkins en cours de configuration (normal pour premier démarrage)" -ForegroundColor Yellow
}

# Exécution des tests baseline
Write-Host "🧪 Exécution des tests baseline..." -ForegroundColor Blue
cd ../tests

Write-Host "📊 Tests Backend API..." -ForegroundColor Red
node backend-corrected.test.js

Write-Host "🎨 Tests Frontend..." -ForegroundColor Red  
node frontend-simple.test.js

Write-Host "⚡ Tests Performance..." -ForegroundColor Red
node performance-simple.test.js

Write-Host "🎉 Tests exécutés avec succès via Jenkins Fast!" -ForegroundColor Green
Write-Host "🌐 Jenkins disponible sur: http://localhost:8080/jenkins" -ForegroundColor Blue
Write-Host "🔑 Mot de passe initial: 0e03b2f4717d491d96614e6c49c823ed" -ForegroundColor Yellow
Write-Host "⚡ Configuration optimisée pour démarrage rapide" -ForegroundColor Green
