# IDURAR ERP CRM Service Startup Script (PowerShell)
# Enhanced version with better error handling and service management

Write-Host "🚀 Starting IDURAR ERP CRM Services..." -ForegroundColor Green
Write-Host "🔧 Enhanced service startup with error handling..." -ForegroundColor Yellow

# Configuration
$BACKEND_PORT = 5000
$FRONTEND_PORT = 3000
$BACKEND_LOG = "backend.log"
$FRONTEND_LOG = "frontend.log"
$BACKEND_PID = "backend.pid"
$FRONTEND_PID = "frontend.pid"

# Function to check if port is in use
function Test-Port {
    param([int]$Port)
    try {
        $connection = New-Object System.Net.Sockets.TcpClient
        $connection.Connect("localhost", $Port)
        $connection.Close()
        return $true
    }
    catch {
        return $false
    }
}

# Function to wait for service to be ready
function Wait-ForService {
    param(
        [string]$Url,
        [string]$ServiceName,
        [int]$MaxAttempts = 30
    )
    
    Write-Host "⏳ Waiting for $ServiceName to be ready..." -ForegroundColor Yellow
    
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
            $response = Invoke-WebRequest -Uri $Url -TimeoutSec 5 -ErrorAction Stop
            Write-Host "✅ $ServiceName is ready!" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "  Attempt $attempt/$MaxAttempts : $ServiceName not ready yet..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }
    
    Write-Host "❌ $ServiceName failed to start within timeout" -ForegroundColor Red
    return $false
}

# Function to start backend service
function Start-BackendService {
    Write-Host "🔧 Starting backend service..." -ForegroundColor Yellow
    
    # Check if backend is already running
    if (Test-Port $BACKEND_PORT) {
        Write-Host "⚠️ Backend service already running on port $BACKEND_PORT" -ForegroundColor Yellow
        return $true
    }
    
    # Navigate to backend directory
    if (Test-Path "backend") {
        Set-Location "backend"
        
        # Install dependencies if needed
        if (-not (Test-Path "node_modules")) {
            Write-Host "📦 Installing backend dependencies..." -ForegroundColor Yellow
            npm install --production
        }
        
        # Start backend service
        Write-Host "🚀 Starting backend on port $BACKEND_PORT..." -ForegroundColor Green
        $backendJob = Start-Job -ScriptBlock {
            Set-Location $using:PWD
            npm start
        }
        
        # Save job ID
        $backendJob.Id | Out-File -FilePath "../$BACKEND_PID" -Encoding ASCII
        
        # Wait for backend to be ready
        if (Wait-ForService "http://localhost:$BACKEND_PORT" "Backend") {
            Write-Host "✅ Backend service started successfully (Job ID: $($backendJob.Id))" -ForegroundColor Green
            Set-Location ".."
            return $true
        }
        else {
            Write-Host "❌ Backend service failed to start" -ForegroundColor Red
            Stop-Job $backendJob
            Remove-Job $backendJob
            Remove-Item "../$BACKEND_PID" -ErrorAction SilentlyContinue
            Set-Location ".."
            return $false
        }
    }
    else {
        Write-Host "❌ Backend directory not found" -ForegroundColor Red
        return $false
    }
}

# Function to start frontend service
function Start-FrontendService {
    Write-Host "🔧 Starting frontend service..." -ForegroundColor Yellow
    
    # Check if frontend is already running
    if (Test-Port $FRONTEND_PORT) {
        Write-Host "⚠️ Frontend service already running on port $FRONTEND_PORT" -ForegroundColor Yellow
        return $true
    }
    
    # Navigate to frontend directory
    if (Test-Path "frontend") {
        Set-Location "frontend"
        
        # Install dependencies if needed
        if (-not (Test-Path "node_modules")) {
            Write-Host "📦 Installing frontend dependencies..." -ForegroundColor Yellow
            npm install --production
        }
        
        # Start frontend service
        Write-Host "🚀 Starting frontend on port $FRONTEND_PORT..." -ForegroundColor Green
        $frontendJob = Start-Job -ScriptBlock {
            Set-Location $using:PWD
            npm start
        }
        
        # Save job ID
        $frontendJob.Id | Out-File -FilePath "../$FRONTEND_PID" -Encoding ASCII
        
        # Wait for frontend to be ready
        if (Wait-ForService "http://localhost:$FRONTEND_PORT" "Frontend") {
            Write-Host "✅ Frontend service started successfully (Job ID: $($frontendJob.Id))" -ForegroundColor Green
            Set-Location ".."
            return $true
        }
        else {
            Write-Host "❌ Frontend service failed to start" -ForegroundColor Red
            Stop-Job $frontendJob
            Remove-Job $frontendJob
            Remove-Item "../$FRONTEND_PID" -ErrorAction SilentlyContinue
            Set-Location ".."
            return $false
        }
    }
    else {
        Write-Host "❌ Frontend directory not found" -ForegroundColor Red
        return $false
    }
}

# Function to show service status
function Show-ServiceStatus {
    Write-Host "📊 Service Status:" -ForegroundColor Cyan
    
    Write-Host "  Backend:" -ForegroundColor Yellow
    if (Test-Path $BACKEND_PID) {
        $backendJobId = Get-Content $BACKEND_PID
        $backendJob = Get-Job -Id $backendJobId -ErrorAction SilentlyContinue
        if ($backendJob) {
            Write-Host "    ✅ Running (Job ID: $backendJobId)" -ForegroundColor Green
        }
        else {
            Write-Host "    ❌ Not running (stale PID file)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "    ❌ Not running" -ForegroundColor Red
    }
    
    Write-Host "  Frontend:" -ForegroundColor Yellow
    if (Test-Path $FRONTEND_PID) {
        $frontendJobId = Get-Content $FRONTEND_PID
        $frontendJob = Get-Job -Id $frontendJobId -ErrorAction SilentlyContinue
        if ($frontendJob) {
            Write-Host "    ✅ Running (Job ID: $frontendJobId)" -ForegroundColor Green
        }
        else {
            Write-Host "    ❌ Not running (stale PID file)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "    ❌ Not running" -ForegroundColor Red
    }
}

# Main execution
function Main {
    Write-Host "🌐 Starting IDURAR ERP CRM Services..." -ForegroundColor Green
    Write-Host "🔧 Enhanced service startup with error handling..." -ForegroundColor Yellow
    
    # Start backend
    if (Start-BackendService) {
        Write-Host "✅ Backend service started successfully" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Failed to start backend service" -ForegroundColor Red
        exit 1
    }
    
    # Start frontend
    if (Start-FrontendService) {
        Write-Host "✅ Frontend service started successfully" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Failed to start frontend service" -ForegroundColor Red
        exit 1
    }
    
    # Show final status
    Show-ServiceStatus
    
    Write-Host "🎉 All services started successfully!" -ForegroundColor Green
    Write-Host "📊 Service URLs:" -ForegroundColor Cyan
    Write-Host "  Backend: http://localhost:$BACKEND_PORT" -ForegroundColor White
    Write-Host "  Frontend: http://localhost:$FRONTEND_PORT" -ForegroundColor White
    Write-Host "📝 Logs:" -ForegroundColor Cyan
    Write-Host "  Backend: $BACKEND_LOG" -ForegroundColor White
    Write-Host "  Frontend: $FRONTEND_LOG" -ForegroundColor White
}

# Run main function
Main





