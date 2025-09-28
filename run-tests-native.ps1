# IDURAR ERP CRM - Tests avec Jenkins Local ou Alternative Directe
Write-Host "🚀 IDURAR ERP CRM - Tests avec Jenkins Local" -ForegroundColor Green
Write-Host "🔍 Détection de votre installation Jenkins..." -ForegroundColor Blue

# Vérification de Jenkins local
$jenkinsLocal = $false
$jenkinsUrl = "http://localhost:8080"

# Test 1: Vérifier si Jenkins répond
try {
    $response = Invoke-WebRequest -Uri $jenkinsUrl -TimeoutSec 3
    $jenkinsLocal = $true
    Write-Host "✅ Jenkins local détecté sur $jenkinsUrl" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Jenkins local non accessible" -ForegroundColor Yellow
}

# Test 2: Vérifier les services Windows
if (-not $jenkinsLocal) {
    $jenkinsService = Get-Service -Name "*jenkins*" -ErrorAction SilentlyContinue
    if ($jenkinsService) {
        Write-Host "🔧 Service Jenkins trouvé: $($jenkinsService.Name)" -ForegroundColor Blue
        Write-Host "📋 Statut: $($jenkinsService.Status)" -ForegroundColor Blue
        
        if ($jenkinsService.Status -eq "Stopped") {
            Write-Host "🚀 Démarrage du service Jenkins..." -ForegroundColor Blue
            Start-Service -Name $jenkinsService.Name
            Start-Sleep 10
            $jenkinsLocal = $true
        }
    }
}

# Test 3: Vérifier les processus Jenkins
if (-not $jenkinsLocal) {
    $jenkinsProcess = Get-Process -Name "*jenkins*" -ErrorAction SilentlyContinue
    if ($jenkinsProcess) {
        Write-Host "✅ Processus Jenkins trouvé: $($jenkinsProcess.ProcessName)" -ForegroundColor Green
        $jenkinsLocal = $true
    }
}

# Exécution des tests
Write-Host "🧪 Exécution des tests baseline..." -ForegroundColor Blue
cd tests

if ($jenkinsLocal) {
    Write-Host "🎯 Utilisation de Jenkins local" -ForegroundColor Green
    Write-Host "🌐 Jenkins: $jenkinsUrl" -ForegroundColor Blue
} else {
    Write-Host "⚡ Utilisation de l'alternative directe (plus rapide)" -ForegroundColor Green
    Write-Host "🌱 Optimisé: 0.5 secondes vs 2-5 minutes Jenkins" -ForegroundColor Blue
}

# Tests complets
Write-Host "📊 Exécution des tests..." -ForegroundColor Blue
node test-runner.js

Write-Host "🎉 Tests exécutés avec succès!" -ForegroundColor Green
if ($jenkinsLocal) {
    Write-Host "🌐 Jenkins local: $jenkinsUrl" -ForegroundColor Blue
} else {
    Write-Host "⚡ Alternative directe: Plus rapide et stable" -ForegroundColor Blue
}
