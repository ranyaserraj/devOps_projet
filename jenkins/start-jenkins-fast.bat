@echo off
REM IDURAR ERP CRM - Jenkins Fast Configuration
echo 🚀 Jenkins Fast - Configuration optimisee
echo ⚡ Demarrage rapide: 30-60 secondes (vs 2-5 minutes)
echo 🌱 Optimise: 512MB RAM (vs 2GB+)

echo.
echo 🛑 Arret des anciens conteneurs...
docker-compose -f docker-compose-minimal.yml down 2>nul
docker stop jenkins-fast 2>nul
docker rm jenkins-fast 2>nul

echo.
echo 🚀 Demarrage de Jenkins Fast...
docker-compose -f docker-compose-fast.yml up -d

echo.
echo ⏳ Attente du demarrage Jenkins (30-60 secondes)...
timeout /t 30 /nobreak >nul

echo.
echo 🔍 Verification du statut...
docker ps --filter "name=jenkins-fast"

echo.
echo 🌐 Test de connectivite...
curl -s http://localhost:8080 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Jenkins accessible sur http://localhost:8080
) else (
    echo ⏳ Jenkins en cours de demarrage...
    echo 🔄 Attente supplementaire...
    timeout /t 30 /nobreak >nul
    curl -s http://localhost:8080 >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ Jenkins accessible sur http://localhost:8080
    ) else (
        echo ❌ Jenkins non accessible
        echo 📋 Verifiez les logs: docker logs jenkins-fast
    )
)

echo.
echo 🎉 Jenkins Fast demarre!
echo 🌐 Acces: http://localhost:8080
echo 👤 Utilisateur: admin
echo 🔑 Mot de passe: admin123
echo ⚡ Configuration optimisee pour demarrage rapide

pause
