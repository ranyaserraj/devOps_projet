@echo off
REM IDURAR ERP CRM - Monitoring CI/CD Baseline
REM Script Batch pour démarrer le monitoring

echo 🚀 Démarrage du monitoring CI/CD baseline...

REM Vérifier Docker
docker --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker n'est pas installé ou démarré
    exit /b 1
)

REM Vérifier Docker Compose
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker Compose n'est pas installé
    exit /b 1
)

REM Aller dans le répertoire monitoring
cd monitoring

echo 📦 Installation des dépendances Node.js...
cd scripts
call npm install
cd ..

echo 🐳 Démarrage des conteneurs de monitoring...
docker-compose up -d

echo ⏳ Attente du démarrage des services...
timeout /t 30 /nobreak >nul

echo 🔍 Vérification des services...

REM Vérifier Prometheus
curl -s http://localhost:9090/api/v1/query?query=up >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Prometheus n'est pas encore prêt
) else (
    echo ✅ Prometheus est opérationnel
)

REM Vérifier Grafana
curl -s http://localhost:3001/api/health >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Grafana n'est pas encore prêt
) else (
    echo ✅ Grafana est opérationnel
)

REM Vérifier Jenkins
curl -s http://localhost:8081 >nul 2>&1
if errorlevel 1 (
    echo ⚠️ Jenkins n'est pas encore prêt
) else (
    echo ✅ Jenkins est opérationnel
)

echo.
echo 🎉 Monitoring CI/CD baseline démarré avec succès !
echo.
echo 📊 Services disponibles :
echo   • Grafana:     http://localhost:3001 (admin/admin123)
echo   • Prometheus:  http://localhost:9090
echo   • Jenkins:     http://localhost:8081
echo   • Alertmanager: http://localhost:9093
echo.
echo 📈 Dashboards disponibles :
echo   • CI/CD Overview
echo   • Performance Baseline
echo   • Jenkins Detailed
echo.
echo 🔧 Pour arrêter le monitoring :
echo   docker-compose down
echo.
echo 📚 Documentation complète : monitoring/README.md

REM Démarrer l'exporteur de métriques Jenkins
echo 🚀 Démarrage de l'exporteur de métriques Jenkins...
cd scripts
start /b node jenkins-metrics-exporter.js
cd ..

echo ✅ Exporteur de métriques Jenkins démarré



