# Script pour configurer Jenkins avec les tests optimisés
Write-Host "🚀 Configuration de Jenkins pour les tests optimisés" -ForegroundColor Green

# Navigate to the jenkins directory
Set-Location "jenkins"

# Ensure Jenkins is running with optimized configuration
Write-Host "Ensuring Jenkins is running with optimized configuration..."
docker-compose -f docker-compose-network.yml up -d

# Wait for Jenkins to be ready
Write-Host "Waiting for Jenkins to be fully up and running..."
$jenkinsUrl = "http://localhost:8080"
$timeout = New-TimeSpan -Minutes 5
$sw = [System.Diagnostics.Stopwatch]::StartNew()

while ($sw.Elapsed -lt $timeout) {
    try {
        $response = Invoke-WebRequest -Uri $jenkinsUrl -UseBasicParsing -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 403) {
            Write-Host "Jenkins is accessible."
            break
        }
    } catch {
        # Jenkins not ready yet
    }
    Start-Sleep -Seconds 5
}

if ($sw.Elapsed -ge $timeout) {
    Write-Host "Jenkins did not become accessible in time."
    exit 1
}

# Check Jenkins logs for "Jenkins is fully up and running"
$logTimeout = New-TimeSpan -Minutes 5
$logSw = [System.Diagnostics.Stopwatch]::StartNew()
$jenkinsReady = $false

while ($logSw.Elapsed -lt $logTimeout) {
    $logs = docker logs jenkins-network --tail 50 2>&1
    if ($logs -match "Jenkins is fully up and running") {
        Write-Host "Jenkins is fully up and running!"
        $jenkinsReady = $true
        break
    }
    Start-Sleep -Seconds 10
}

if (-not $jenkinsReady) {
    Write-Host "Jenkins did not report 'fully up and running' in time."
    exit 1
}

# Get initial admin password (if needed)
Write-Host "Attempting to retrieve initial admin password..."
$password = docker exec jenkins-network cat /var/jenkins_home/secrets/initialAdminPassword 2>$null

if ($password) {
    Write-Host "Jenkins initial admin password: $password"
    Write-Host "Please use this password to unlock Jenkins at http://localhost:8080"
} else {
    Write-Host "Initial admin password not found (might be already configured or file not created yet)."
    Write-Host "Access Jenkins at http://localhost:8080 and follow the setup wizard."
}

Write-Host "🎯 Configuration Jenkins pour tests optimisés:"
Write-Host "1. Accédez à Jenkins: http://localhost:8080"
Write-Host "2. Créez un nouveau pipeline job"
Write-Host "3. Configurez le SCM pour utiliser la branche 'optimization_test'"
Write-Host "4. Utilisez le Jenkinsfile-optimized"
Write-Host "5. Activez les stages parallèles"

Write-Host "📋 Instructions détaillées:"
Write-Host "- Nom du job: IDURAR-ERP-CRM-Optimized"
Write-Host "- Type: Pipeline"
Write-Host "- SCM: Git"
Write-Host "- Repository: https://github.com/ranyaserraj/devOps_projet.git"
Write-Host "- Branch: optimization_test"
Write-Host "- Script Path: jenkins/Jenkinsfile-optimized"

Write-Host "🚀 Jenkins optimisé est maintenant opérationnel!"
Write-Host "Interface web: http://localhost:8080"

# Navigate back to the root directory
Set-Location ".."





