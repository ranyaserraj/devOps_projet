#!/bin/bash

# IDURAR ERP CRM Service Startup Script for Jenkins
# Enhanced version with better error handling and service management

echo "🚀 Starting IDURAR ERP CRM Services for Jenkins..."
echo "🔧 Enhanced service startup with error handling..."

# Configuration
BACKEND_PORT=5000
FRONTEND_PORT=3000
BACKEND_LOG="backend.log"
FRONTEND_LOG="frontend.log"
BACKEND_PID="backend.pid"
FRONTEND_PID="frontend.pid"
MAX_WAIT_TIME=60 # 60 seconds

# Function to check if port is in use
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0  # Port is in use
    else
        return 1  # Port is free
    fi
}

# Function to wait for service to be ready
wait_for_service() {
    local url=$1
    local service_name=$2
    local max_attempts=$((MAX_WAIT_TIME / 2))
    local attempt=1
    
    echo "⏳ Waiting for $service_name to be ready..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s "$url" >/dev/null 2>&1; then
            echo "✅ $service_name is ready!"
            return 0
        fi
        
        echo "  Attempt $attempt/$max_attempts: $service_name not ready yet..."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "❌ $service_name failed to start within timeout"
    return 1
}

# Function to start backend service
start_backend() {
    echo "🔧 Starting backend service..."
    
    # Check if backend is already running
    if check_port $BACKEND_PORT; then
        echo "⚠️ Backend service already running on port $BACKEND_PORT"
        return 0
    fi
    
    # Navigate to backend directory
    if [ -d "backend" ]; then
        cd backend
        
        # Install dependencies if needed
        if [ ! -d "node_modules" ]; then
            echo "📦 Installing backend dependencies..."
            npm install --production
        fi
        
        # Start backend service
        echo "🚀 Starting backend on port $BACKEND_PORT..."
        nohup npm start > ../$BACKEND_LOG 2>&1 &
        BACKEND_PID=$!
        echo $BACKEND_PID > ../$BACKEND_PID
        
        # Wait for backend to be ready
        if wait_for_service "http://host.docker.internal:$BACKEND_PORT" "Backend"; then
            echo "✅ Backend service started successfully (PID: $BACKEND_PID)"
            cd ..
            return 0
        else
            echo "❌ Backend service failed to start"
            kill $BACKEND_PID 2>/dev/null
            rm -f ../$BACKEND_PID
            cd ..
            return 1
        fi
    else
        echo "❌ Backend directory not found"
        return 1
    fi
}

# Function to start frontend service
start_frontend() {
    echo "🔧 Starting frontend service..."
    
    # Check if frontend is already running
    if check_port $FRONTEND_PORT; then
        echo "⚠️ Frontend service already running on port $FRONTEND_PORT"
        return 0
    fi
    
    # Navigate to frontend directory
    if [ -d "frontend" ]; then
        cd frontend
        
        # Install dependencies if needed
        if [ ! -d "node_modules" ]; then
            echo "📦 Installing frontend dependencies..."
            npm install --production
        fi
        
        # Start frontend service
        echo "🚀 Starting frontend on port $FRONTEND_PORT..."
        nohup npm start > ../$FRONTEND_LOG 2>&1 &
        FRONTEND_PID=$!
        echo $FRONTEND_PID > ../$FRONTEND_PID
        
        # Wait for frontend to be ready
        if wait_for_service "http://host.docker.internal:$FRONTEND_PORT" "Frontend"; then
            echo "✅ Frontend service started successfully (PID: $FRONTEND_PID)"
            cd ..
            return 0
        else
            echo "❌ Frontend service failed to start"
            kill $FRONTEND_PID 2>/dev/null
            rm -f ../$FRONTEND_PID
            cd ..
            return 1
        fi
    else
        echo "❌ Frontend directory not found"
        return 1
    fi
}

# Function to show service status
show_status() {
    echo "📊 Service Status:"
    echo "  Backend:"
    if [ -f "$BACKEND_PID" ]; then
        local backend_pid=$(cat $BACKEND_PID)
        if ps -p $backend_pid > /dev/null 2>&1; then
            echo "    ✅ Running (PID: $backend_pid)"
        else
            echo "    ❌ Not running (stale PID file)"
        fi
    else
        echo "    ❌ Not running"
    fi
    
    echo "  Frontend:"
    if [ -f "$FRONTEND_PID" ]; then
        local frontend_pid=$(cat $FRONTEND_PID)
        if ps -p $frontend_pid > /dev/null 2>&1; then
            echo "    ✅ Running (PID: $frontend_pid)"
        else
            echo "    ❌ Not running (stale PID file)"
        fi
    else
        echo "    ❌ Not running"
    fi
}

# Main execution
main() {
    echo "🌐 Starting IDURAR ERP CRM Services for Jenkins..."
    echo "🔧 Enhanced service startup with error handling..."
    
    # Start backend
    if start_backend; then
        echo "✅ Backend service started successfully"
    else
        echo "❌ Failed to start backend service"
        exit 1
    fi
    
    # Start frontend
    if start_frontend; then
        echo "✅ Frontend service started successfully"
    else
        echo "❌ Failed to start frontend service"
        exit 1
    fi
    
    # Show final status
    show_status
    
    echo "🎉 All services started successfully!"
    echo "📊 Service URLs:"
    echo "  Backend: http://host.docker.internal:$BACKEND_PORT"
    echo "  Frontend: http://host.docker.internal:$FRONTEND_PORT"
    echo "📝 Logs:"
    echo "  Backend: $BACKEND_LOG"
    echo "  Frontend: $FRONTEND_LOG"
}

# Run main function
main "$@"
