#!/usr/bin/env pwsh

Write-Host "🚀 Configuration automatique de Jenkins pour IDURAR ERP CRM" -ForegroundColor Cyan

# Attendre que Jenkins soit prêt
Write-Host "⏳ Attente que Jenkins soit prêt..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0

do {
    $attempt++
    Start-Sleep 10
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 5 -ErrorAction Stop
        if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 403) {
            Write-Host "✅ Jenkins est prêt !" -ForegroundColor Green
            break
        }
    } catch {
        Write-Host "⏳ Tentative $attempt/$maxAttempts - Jenkins en cours de démarrage..." -ForegroundColor Yellow
    }
} while ($attempt -lt $maxAttempts)

if ($attempt -eq $maxAttempts) {
    Write-Host "❌ Jenkins n'a pas pu démarrer dans les temps impartis" -ForegroundColor Red
    Write-Host "📋 Vérifiez les logs avec: docker logs jenkins-network" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🎉 Jenkins est maintenant opérationnel !" -ForegroundColor Green
Write-Host "🌐 Interface web: http://localhost:8080" -ForegroundColor Cyan
Write-Host "📋 Jenkinsfile amélioré disponible: ./Jenkinsfile-improved" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 Statut des conteneurs:" -ForegroundColor Yellow
docker ps --filter "name=jenkins" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

Write-Host ""
Write-Host "🔧 Configuration réseau:" -ForegroundColor Yellow
Write-Host "  - Jenkins peut maintenant accéder aux services via host.docker.internal" -ForegroundColor White
Write-Host "  - Backend: host.docker.internal:5000" -ForegroundColor White
Write-Host "  - Frontend: host.docker.internal:3000" -ForegroundColor White

Write-Host ""
Write-Host "🛠️  Prochaines étapes:" -ForegroundColor Yellow
Write-Host "  1. Ouvrez http://localhost:8080 dans votre navigateur" -ForegroundColor White
Write-Host "  2. Configurez Jenkins (première fois)" -ForegroundColor White
Write-Host "  3. Créez un nouveau job 'Pipeline'" -ForegroundColor White
Write-Host "  4. Utilisez le Jenkinsfile-improved pour de meilleures connexions réseau" -ForegroundColor White
Write-Host "  5. Exécutez le pipeline !" -ForegroundColor White

Write-Host ""
Write-Host "📋 Commandes utiles:" -ForegroundColor Yellow
Write-Host "  - Voir les logs: docker logs jenkins-network" -ForegroundColor White
Write-Host "  - Arrêter: docker-compose -f docker-compose-network.yml down" -ForegroundColor White
Write-Host "  - Redémarrer: docker-compose -f docker-compose-network.yml restart" -ForegroundColor White





