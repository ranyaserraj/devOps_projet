# IDURAR ERP CRM - Monitoring CI/CD Baseline
# Script PowerShell pour démarrer le monitoring

Write-Host "🚀 Démarrage du monitoring CI/CD baseline..." -ForegroundColor Green

# Vérifier Docker
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker n'est pas installé ou démarré" -ForegroundColor Red
    exit 1
}

# Vérifier Docker Compose
if (-not (Get-Command docker-compose -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Docker Compose n'est pas installé" -ForegroundColor Red
    exit 1
}

# Aller dans le répertoire monitoring
Set-Location -Path "monitoring"

Write-Host "📦 Installation des dépendances Node.js..." -ForegroundColor Yellow
Set-Location -Path "scripts"
npm install
Set-Location -Path ".."

Write-Host "🐳 Démarrage des conteneurs de monitoring..." -ForegroundColor Yellow
docker-compose up -d

Write-Host "⏳ Attente du démarrage des services..." -ForegroundColor Yellow
Start-Sleep -Seconds 30

Write-Host "🔍 Vérification des services..." -ForegroundColor Yellow

# Vérifier Prometheus
try {
    $prometheusResponse = Invoke-WebRequest -Uri "http://localhost:9090/api/v1/query?query=up" -TimeoutSec 10
    if ($prometheusResponse.StatusCode -eq 200) {
        Write-Host "✅ Prometheus est opérationnel" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Prometheus n'est pas encore prêt" -ForegroundColor Yellow
}

# Vérifier Grafana
try {
    $grafanaResponse = Invoke-WebRequest -Uri "http://localhost:3001/api/health" -TimeoutSec 10
    if ($grafanaResponse.StatusCode -eq 200) {
        Write-Host "✅ Grafana est opérationnel" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Grafana n'est pas encore prêt" -ForegroundColor Yellow
}

# Vérifier Jenkins
try {
    $jenkinsResponse = Invoke-WebRequest -Uri "http://localhost:8081" -TimeoutSec 10
    if ($jenkinsResponse.StatusCode -eq 200) {
        Write-Host "✅ Jenkins est opérationnel" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Jenkins n'est pas encore prêt" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🎉 Monitoring CI/CD baseline démarré avec succès !" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Services disponibles :" -ForegroundColor Cyan
Write-Host "  • Grafana:     http://localhost:3001 (admin/admin123)" -ForegroundColor White
Write-Host "  • Prometheus:  http://localhost:9090" -ForegroundColor White
Write-Host "  • Jenkins:     http://localhost:8081" -ForegroundColor White
Write-Host "  • Alertmanager: http://localhost:9093" -ForegroundColor White
Write-Host ""
Write-Host "📈 Dashboards disponibles :" -ForegroundColor Cyan
Write-Host "  • CI/CD Overview" -ForegroundColor White
Write-Host "  • Performance Baseline" -ForegroundColor White
Write-Host "  • Jenkins Detailed" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Pour arrêter le monitoring :" -ForegroundColor Yellow
Write-Host "  docker-compose down" -ForegroundColor White
Write-Host ""
Write-Host "📚 Documentation complète : monitoring/README.md" -ForegroundColor Cyan

# Démarrer l'exporteur de métriques Jenkins
Write-Host "🚀 Démarrage de l'exporteur de métriques Jenkins..." -ForegroundColor Yellow
Set-Location -Path "scripts"
Start-Process -FilePath "node" -ArgumentList "jenkins-metrics-exporter.js" -WindowStyle Hidden
Set-Location -Path ".."

Write-Host "✅ Exporteur de métriques Jenkins démarré" -ForegroundColor Green

