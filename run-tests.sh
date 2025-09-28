#!/bin/bash

# IDURAR ERP CRM - Heavy Baseline Tests Runner
echo "🔥 Starting IDURAR ERP CRM Heavy Baseline Tests"
echo "⚠️  WARNING: These tests consume significant resources and CO₂"
echo "🌱 CO₂ optimization will be implemented later"

# Set environment variables
export HEAVY_TEST_MODE=true
export CONCURRENT_REQUESTS=100
export TEST_DURATION=300000
export API_URL=http://localhost:5000
export FRONTEND_URL=http://localhost:3000

# Start application services
echo "🚀 Starting application services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check if services are running
echo "🔍 Checking service status..."
docker ps

# Run tests
echo "🧪 Running heavy baseline tests..."

# Backend API tests
echo "🔥 Running heavy backend API tests..."
cd tests
npm install
npm run test:integration -- --testPathPattern=backend

# Frontend UI tests
echo "🎨 Running heavy frontend UI tests..."
npm run test -- --testPathPattern=frontend

# Performance tests
echo "⚡ Running heavy performance tests..."
npm run test:performance

# Load tests
echo "🔥 Running heavy load tests..."
npm run test:load

echo "✅ Heavy baseline tests completed!"
echo "📊 Check test reports in the coverage directory"
echo "🌱 CO₂ optimization will be implemented in future iterations"
