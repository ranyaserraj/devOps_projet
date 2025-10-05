# IDURAR ERP CRM - Heavy Baseline Testing

## 🚨 Important Notice

**These are HEAVY baseline tests that consume significant resources and CO₂ emissions.**

- ⚠️ **High Resource Consumption**: Tests are designed to stress-test the system
- 🔥 **Intensive Testing**: Multiple concurrent requests, large data sets, extended durations
- 🌱 **CO₂ Optimization**: Will be implemented in future iterations
- 📊 **Comprehensive Coverage**: Backend API, Frontend UI, Performance, Load Testing

## 🏗️ Test Architecture

### Test Categories

1. **Backend API Tests** (`tests/backend/`)
   - Heavy authentication testing
   - Concurrent database operations
   - Complex invoice creation
   - Resource-intensive queries

2. **Frontend UI Tests** (`tests/frontend/`)
   - Heavy UI interaction testing
   - Multiple page navigation
   - Form submission stress tests
   - Performance monitoring

3. **Performance Tests** (`tests/performance/`)
   - Load testing with Artillery
   - Memory consumption tests
   - CPU intensive operations
   - Network I/O stress tests

4. **Jenkins CI/CD** (`jenkins/`)
   - Automated test execution
   - Resource monitoring
   - Test reporting
   - Pipeline orchestration

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 20+
- Jenkins (optional, for CI/CD)

### Running Tests

#### Option 1: Manual Execution
```bash
# Start application
docker-compose up -d

# Install test dependencies
cd tests
npm install

# Run all tests
npm run test:all

# Run specific test categories
npm run test:integration  # Backend API tests
npm run test:performance # Performance tests
npm run test:load        # Load tests
```

#### Option 2: Jenkins CI/CD
```bash
# Start Jenkins
cd jenkins
docker-compose up -d

# Access Jenkins at http://localhost:8080
# Username: admin
# Password: admin123

# Run pipeline: "Heavy Baseline Tests"
```

#### Option 3: Automated Script
```bash
# Run all tests with monitoring
./run-tests.sh
```

## 📊 Test Configuration

### Environment Variables
```bash
HEAVY_TEST_MODE=true          # Enable heavy testing mode
CONCURRENT_REQUESTS=100       # Number of concurrent requests
TEST_DURATION=300000         # Test duration (5 minutes)
API_URL=http://localhost:5000 # Backend API URL
FRONTEND_URL=http://localhost:3000 # Frontend URL
```

### Resource Limits
- **Memory**: 2GB+ recommended
- **CPU**: 4+ cores recommended
- **Duration**: 5-30 minutes per test suite
- **Concurrent Users**: 100+ for load tests

## 🔥 Heavy Test Scenarios

### Backend API Heavy Tests
- **Authentication**: 50+ login attempts with various scenarios
- **Customer Management**: 20+ concurrent customer creation
- **Invoice Processing**: 15+ complex invoices with multiple line items
- **Database Operations**: 25+ concurrent queries and operations

### Frontend UI Heavy Tests
- **Page Navigation**: All major sections with multiple iterations
- **Form Interactions**: Complex customer and invoice forms
- **Search Operations**: Multiple search queries with large datasets
- **UI Stress Testing**: 50+ rapid UI interactions

### Performance Heavy Tests
- **Load Testing**: 100+ concurrent API requests
- **Memory Testing**: Large data structures (10MB+ arrays)
- **CPU Testing**: 1M+ mathematical calculations
- **Network I/O**: 40+ concurrent network requests

## 📈 Monitoring and Reporting

### Test Reports
- **Coverage Reports**: HTML reports in `coverage/` directory
- **Performance Metrics**: Response times, throughput, resource usage
- **Resource Monitoring**: CPU, memory, network usage
- **Jenkins Reports**: Comprehensive test results and trends

### Resource Monitoring
```bash
# Monitor Docker resources
docker stats

# Monitor system resources
top -bn1
free -h
df -h
```

## 🌱 CO₂ Optimization Roadmap

### Current State
- ⚠️ **High Resource Consumption**: Tests consume significant CPU, memory, and network resources
- 🔥 **Intensive Testing**: Designed for comprehensive system validation
- 📊 **Baseline Establishment**: Current tests serve as performance baselines

### Future Optimizations
- 🎯 **Test Optimization**: Reduce resource consumption while maintaining coverage
- ⚡ **Parallel Execution**: Optimize test parallelization
- 🔄 **Incremental Testing**: Implement smart test selection
- 📊 **Resource Monitoring**: Real-time CO₂ impact tracking
- 🌱 **Green Testing**: Environmentally conscious test strategies

## 🛠️ Troubleshooting

### Common Issues

#### High Memory Usage
```bash
# Monitor memory usage
docker stats --no-stream

# Clean up Docker resources
docker system prune -f
```

#### Test Timeouts
```bash
# Increase timeout values
export TEST_TIMEOUT=60000

# Check service availability
curl http://localhost:5000/api
curl http://localhost:3000
```

#### Jenkins Issues
```bash
# Check Jenkins logs
docker logs idurar-jenkins

# Restart Jenkins
docker-compose restart jenkins
```

## 📚 Test Documentation

### Test Structure
```
tests/
├── backend/           # Backend API tests
├── frontend/          # Frontend UI tests
├── performance/       # Performance and load tests
├── package.json       # Test dependencies
└── setup.js          # Test configuration
```

### Jenkins Configuration
```
jenkins/
├── Dockerfile         # Jenkins container
├── docker-compose.yml # Jenkins services
├── Jenkinsfile        # Pipeline definition
├── jobs/             # Job configurations
└── plugins.txt       # Required plugins
```

## 🎯 Best Practices

### Test Execution
1. **Resource Planning**: Ensure adequate system resources
2. **Monitoring**: Watch resource usage during test execution
3. **Cleanup**: Clean up Docker resources after tests
4. **Reporting**: Review test reports for insights

### Development Workflow
1. **Local Testing**: Run tests locally before committing
2. **CI/CD Integration**: Use Jenkins for automated testing
3. **Performance Tracking**: Monitor performance trends over time
4. **Optimization**: Continuously optimize test efficiency

## 📞 Support

For issues with heavy baseline tests:
- Check Docker resource usage
- Verify service availability
- Review test logs
- Monitor system performance

**Remember**: These tests are designed to be resource-intensive for comprehensive validation. CO₂ optimization will be implemented in future iterations.







