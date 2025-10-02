# IDURAR ERP CRM Service Cleanup Script (PowerShell)
# Enhanced version with proper service cleanup

Write-Host "🧹 Cleaning up IDURAR ERP CRM Services..." -ForegroundColor Yellow
Write-Host "🔧 Enhanced service cleanup with error handling..." -ForegroundColor Yellow

# Configuration
$BACKEND_PID = "backend.pid"
$FRONTEND_PID = "frontend.pid"
$BACKEND_LOG = "backend.log"
$FRONTEND_LOG = "frontend.log"

# Function to stop service by PID file
function Stop-ServiceByPid {
    param(
        [string]$PidFile,
        [string]$ServiceName
    )
    
    if (Test-Path $PidFile) {
        try {
            $jobId = Get-Content $PidFile
            $job = Get-Job -Id $jobId -ErrorAction SilentlyContinue
            
            if ($job) {
                Write-Host "🛑 Stopping $ServiceName (Job ID: $jobId)..." -ForegroundColor Yellow
                Stop-Job $job
                Remove-Job $job
                Write-Host "✅ $ServiceName stopped successfully" -ForegroundColor Green
            }
            else {
                Write-Host "⚠️ $ServiceName job not found (stale PID file)" -ForegroundColor Yellow
            }
            
            # Remove PID file
            Remove-Item $PidFile -ErrorAction SilentlyContinue
        }
        catch {
            Write-Host "❌ Error stopping $ServiceName : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    else {
        Write-Host "ℹ️ No PID file found for $ServiceName" -ForegroundColor Blue
    }
}

# Function to clean up log files
function Clear-LogFiles {
    Write-Host "🧹 Cleaning up log files..." -ForegroundColor Yellow
    
    $logFiles = @($BACKEND_LOG, $FRONTEND_LOG)
    
    foreach ($logFile in $logFiles) {
        if (Test-Path $logFile) {
            try {
                Remove-Item $logFile -ErrorAction Stop
                Write-Host "✅ Removed $logFile" -ForegroundColor Green
            }
            catch {
                Write-Host "⚠️ Could not remove $logFile : $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "ℹ️ $logFile not found" -ForegroundColor Blue
        }
    }
}

# Function to kill processes by port
function Stop-ProcessByPort {
    param(
        [int]$Port,
        [string]$ServiceName
    )
    
    try {
        $processes = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
        
        if ($processes) {
            foreach ($process in $processes) {
                $pid = $process.OwningProcess
                $proc = Get-Process -Id $pid -ErrorAction SilentlyContinue
                
                if ($proc) {
                    Write-Host "🛑 Killing $ServiceName process (PID: $pid) on port $Port..." -ForegroundColor Yellow
                    Stop-Process -Id $pid -Force -ErrorAction Stop
                    Write-Host "✅ $ServiceName process killed" -ForegroundColor Green
                }
            }
        }
        else {
            Write-Host "ℹ️ No processes found on port $Port for $ServiceName" -ForegroundColor Blue
        }
    }
    catch {
        Write-Host "⚠️ Error killing processes on port $Port : $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# Function to show cleanup status
function Show-CleanupStatus {
    Write-Host "📊 Cleanup Status:" -ForegroundColor Cyan
    
    # Check if services are still running
    $backendRunning = Test-Path $BACKEND_PID
    $frontendRunning = Test-Path $FRONTEND_PID
    
    Write-Host "  Backend:" -ForegroundColor Yellow
    if ($backendRunning) {
        Write-Host "    ⚠️ Still running (PID file exists)" -ForegroundColor Yellow
    }
    else {
        Write-Host "    ✅ Stopped" -ForegroundColor Green
    }
    
    Write-Host "  Frontend:" -ForegroundColor Yellow
    if ($frontendRunning) {
        Write-Host "    ⚠️ Still running (PID file exists)" -ForegroundColor Yellow
    }
    else {
        Write-Host "    ✅ Stopped" -ForegroundColor Green
    }
    
    # Check log files
    Write-Host "  Log Files:" -ForegroundColor Yellow
    $logFiles = @($BACKEND_LOG, $FRONTEND_LOG)
    foreach ($logFile in $logFiles) {
        if (Test-Path $logFile) {
            Write-Host "    ⚠️ $logFile still exists" -ForegroundColor Yellow
        }
        else {
            Write-Host "    ✅ $logFile removed" -ForegroundColor Green
        }
    }
}

# Main cleanup function
function Main {
    Write-Host "🌐 Cleaning up IDURAR ERP CRM Services..." -ForegroundColor Yellow
    Write-Host "🔧 Enhanced service cleanup with error handling..." -ForegroundColor Yellow
    
    # Stop services by PID files
    Stop-ServiceByPid $BACKEND_PID "Backend"
    Stop-ServiceByPid $FRONTEND_PID "Frontend"
    
    # Kill any remaining processes on ports
    Stop-ProcessByPort 5000 "Backend"
    Stop-ProcessByPort 3000 "Frontend"
    
    # Clean up log files
    Clear-LogFiles
    
    # Show final status
    Show-CleanupStatus
    
    Write-Host "🎉 Service cleanup completed!" -ForegroundColor Green
    Write-Host "📊 Cleanup Summary:" -ForegroundColor Cyan
    Write-Host "  - Services stopped" -ForegroundColor White
    Write-Host "  - Log files cleaned" -ForegroundColor White
    Write-Host "  - Ports freed" -ForegroundColor White
}

# Run main function
Main
