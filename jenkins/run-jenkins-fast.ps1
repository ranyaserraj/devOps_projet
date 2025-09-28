# IDURAR ERP CRM - Jenkins Fast Configuration
Write-Host "🚀 Jenkins Fast - Configuration optimisée" -ForegroundColor Green
Write-Host "⚡ Démarrage rapide: 30-60 secondes (vs 2-5 minutes)" -ForegroundColor Blue
Write-Host "🌱 Optimisé: 512MB RAM (vs 2GB+)" -ForegroundColor Green

# Arrêter les anciens conteneurs
Write-Host "🛑 Arrêt des anciens conteneurs..." -ForegroundColor Yellow
docker-compose -f docker-compose-minimal.yml down 2>$null
docker stop jenkins-fast 2>$null
docker rm jenkins-fast 2>$null

# Démarrer Jenkins Fast
Write-Host "🚀 Démarrage de Jenkins Fast..." -ForegroundColor Blue
$startTime = Get-Date
Write-Host "⏰ Début: $startTime" -ForegroundColor Yellow

docker-compose -f docker-compose-fast.yml up -d

# Attendre le démarrage
Write-Host "⏳ Attente du démarrage Jenkins (30-60 secondes)..." -ForegroundColor Blue
Start-Sleep 30

# Vérifier le statut
Write-Host "🔍 Vérification du statut..." -ForegroundColor Blue
docker ps --filter "name=jenkins-fast"

# Test de connectivité
Write-Host "🌐 Test de connectivité..." -ForegroundColor Blue
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 10
    Write-Host "✅ Jenkins accessible sur http://localhost:8080" -ForegroundColor Green
} catch {
    Write-Host "⏳ Jenkins en cours de démarrage..." -ForegroundColor Yellow
    Write-Host "🔄 Attente supplémentaire..." -ForegroundColor Blue
    Start-Sleep 30
    
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 10
        Write-Host "✅ Jenkins accessible sur http://localhost:8080" -ForegroundColor Green
    } catch {
        Write-Host "❌ Jenkins non accessible" -ForegroundColor Red
        Write-Host "📋 Vérifiez les logs: docker logs jenkins-fast" -ForegroundColor Yellow
    }
}

$endTime = Get-Date
$duration = $endTime - $startTime
Write-Host "⏱️  Durée totale: $($duration.TotalSeconds) secondes" -ForegroundColor Yellow

Write-Host "`n🎉 Jenkins Fast démarré!" -ForegroundColor Green
Write-Host "🌐 Accès: http://localhost:8080" -ForegroundColor Blue
Write-Host "👤 Utilisateur: admin" -ForegroundColor Blue
Write-Host "🔑 Mot de passe: admin123" -ForegroundColor Blue
Write-Host "⚡ Configuration optimisée pour démarrage rapide" -ForegroundColor Green
