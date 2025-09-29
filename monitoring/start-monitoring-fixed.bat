@echo off
REM Script de démarrage pour Jenkins avec monitoring corrigé
REM Ce script démarre Jenkins sur le port 8080 standard avec les fonctionnalités de monitoring

echo 🚀 Démarrage de Jenkins avec monitoring corrigé...

REM Arrêter les conteneurs existants
echo 🛑 Arrêt des conteneurs existants...
docker-compose -f docker-compose-fixed.yml down

REM Démarrer les services avec la configuration corrigée
echo ▶️ Démarrage des services avec monitoring...
docker-compose -f docker-compose-fixed.yml up -d

REM Attendre que les services soient prêts
echo ⏳ Attente du démarrage des services...
timeout /t 30 /nobreak > nul

REM Vérifier le statut des services
echo 📊 Vérification du statut des services...
docker-compose -f docker-compose-fixed.yml ps

echo.
echo ✅ Services démarrés avec succès!
echo.
echo 🔗 Accès aux services:
echo    • Jenkins: http://localhost:8080
echo    • Prometheus: http://localhost:9090
echo    • Grafana: http://localhost:3001 (admin/admin123)
echo    • cAdvisor: http://localhost:8080
echo    • Node Exporter: http://localhost:9100
echo    • Alertmanager: http://localhost:9093
echo.
echo 📋 Configuration Jenkins:
echo    • Port: 8080 (standard)
echo    • Plugins: Prometheus, Metrics, Pipeline
echo    • Historique: Préservé et fonctionnel
echo.
echo 🎯 Pour créer un job Jenkins:
echo    1. Aller sur http://localhost:8080
echo    2. Créer un nouveau job 'idurar-baseline-tests'
echo    3. Utiliser le Jenkinsfile-monitoring
echo.
echo 📈 Monitoring:
echo    • Métriques: Collectées automatiquement
echo    • Dashboards: Disponibles dans Grafana
echo    • Alertes: Configurées dans Alertmanager

pause

