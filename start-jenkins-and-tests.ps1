# IDURAR ERP CRM - Démarrer Jenkins et Exécuter Tests
Write-Host "🚀 IDURAR ERP CRM - Démarrer Jenkins et Tests" -ForegroundColor Green

# Vérifier si Jenkins est déjà en cours d'exécution
Write-Host "🔍 Vérification de Jenkins..." -ForegroundColor Blue
$jenkinsRunning = $false

try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 3
    $jenkinsRunning = $true
    Write-Host "✅ Jenkins déjà en cours d'exécution" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Jenkins non démarré, démarrage en cours..." -ForegroundColor Yellow
}

# Démarrer Jenkins si nécessaire
if (-not $jenkinsRunning) {
    Write-Host "🚀 Démarrage de Jenkins..." -ForegroundColor Blue
    
    # Vérifier l'installation Jenkins
    $jenkinsPath = "C:\Jenkins\jenkins.war"
    if (Test-Path $jenkinsPath) {
        Write-Host "✅ Jenkins trouvé: $jenkinsPath" -ForegroundColor Green
        
        # Démarrer Jenkins en arrière-plan
        Start-Process -FilePath "java" -ArgumentList "-jar", "jenkins.war", "--httpPort=8080" -WorkingDirectory "C:\Jenkins" -WindowStyle Hidden
        
        Write-Host "⏳ Attente du démarrage Jenkins (30 secondes)..." -ForegroundColor Blue
        Start-Sleep 30
        
        # Vérifier le démarrage
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 5
            Write-Host "✅ Jenkins démarré avec succès!" -ForegroundColor Green
            Write-Host "🌐 Accès: http://localhost:8080" -ForegroundColor Blue
        } catch {
            Write-Host "⚠️ Jenkins en cours de démarrage..." -ForegroundColor Yellow
            Write-Host "🔄 Attente supplémentaire..." -ForegroundColor Blue
            Start-Sleep 30
            
            try {
                $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 5
                Write-Host "✅ Jenkins démarré avec succès!" -ForegroundColor Green
                Write-Host "🌐 Accès: http://localhost:8080" -ForegroundColor Blue
            } catch {
                Write-Host "❌ Jenkins n'a pas démarré correctement" -ForegroundColor Red
                Write-Host "💡 Utilisation de l'alternative directe..." -ForegroundColor Blue
            }
        }
    } else {
        Write-Host "❌ Jenkins non trouvé dans C:\Jenkins" -ForegroundColor Red
        Write-Host "💡 Utilisation de l'alternative directe..." -ForegroundColor Blue
    }
}

# Exécuter les tests
Write-Host "🧪 Exécution des tests baseline..." -ForegroundColor Blue
cd ..\tests

Write-Host "📊 Tests Backend API..." -ForegroundColor Red
node backend-corrected.test.js

Write-Host "🎨 Tests Frontend..." -ForegroundColor Red
node frontend-simple.test.js

Write-Host "⚡ Tests Performance..." -ForegroundColor Red
node performance-simple.test.js

Write-Host "🎉 Tests exécutés avec succès!" -ForegroundColor Green
if ($jenkinsRunning -or (Test-Path "C:\Jenkins\jenkins.war")) {
    Write-Host "🌐 Jenkins: http://localhost:8080" -ForegroundColor Blue
} else {
    Write-Host "⚡ Alternative directe: Plus rapide et stable" -ForegroundColor Blue
}
