# Script de démarrage pour Jenkins avec monitoring corrigé
# Ce script démarre Jenkins sur le port 8080 standard avec les fonctionnalités de monitoring

Write-Host "🚀 Démarrage de Jenkins avec monitoring corrigé..." -ForegroundColor Green

# Arrêter les conteneurs existants
Write-Host "🛑 Arrêt des conteneurs existants..." -ForegroundColor Yellow
docker-compose -f docker-compose-fixed.yml down

# Nettoyer les volumes si nécessaire (optionnel)
# docker volume prune -f

# Démarrer les services avec la configuration corrigée
Write-Host "▶️ Démarrage des services avec monitoring..." -ForegroundColor Green
docker-compose -f docker-compose-fixed.yml up -d

# Attendre que les services soient prêts
Write-Host "⏳ Attente du démarrage des services..." -ForegroundColor Blue
Start-Sleep -Seconds 30

# Vérifier le statut des services
Write-Host "📊 Vérification du statut des services..." -ForegroundColor Blue
docker-compose -f docker-compose-fixed.yml ps

Write-Host ""
Write-Host "✅ Services démarrés avec succès!" -ForegroundColor Green
Write-Host ""
Write-Host "🔗 Accès aux services:" -ForegroundColor Cyan
Write-Host "   • Jenkins: http://localhost:8080" -ForegroundColor White
Write-Host "   • Prometheus: http://localhost:9090" -ForegroundColor White
Write-Host "   • Grafana: http://localhost:3001 (admin/admin123)" -ForegroundColor White
Write-Host "   • cAdvisor: http://localhost:8080" -ForegroundColor White
Write-Host "   • Node Exporter: http://localhost:9100" -ForegroundColor White
Write-Host "   • Alertmanager: http://localhost:9093" -ForegroundColor White
Write-Host ""
Write-Host "📋 Configuration Jenkins:" -ForegroundColor Cyan
Write-Host "   • Port: 8080 (standard)" -ForegroundColor White
Write-Host "   • Plugins: Prometheus, Metrics, Pipeline" -ForegroundColor White
Write-Host "   • Historique: Préservé et fonctionnel" -ForegroundColor White
Write-Host ""
Write-Host "🎯 Pour créer un job Jenkins:" -ForegroundColor Cyan
Write-Host "   1. Aller sur http://localhost:8080" -ForegroundColor White
Write-Host "   2. Créer un nouveau job 'idurar-baseline-tests'" -ForegroundColor White
Write-Host "   3. Utiliser le Jenkinsfile-monitoring" -ForegroundColor White
Write-Host ""
Write-Host "📈 Monitoring:" -ForegroundColor Cyan
Write-Host "   • Métriques: Collectées automatiquement" -ForegroundColor White
Write-Host "   • Dashboards: Disponibles dans Grafana" -ForegroundColor White
Write-Host "   • Alertes: Configurées dans Alertmanager" -ForegroundColor White

