pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        NPM_CACHE = '/tmp/.npm'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Checking out code from GitHub...'
                git branch: 'master', url: 'https://github.com/ranyaserraj/devOps_projet.git'
            }
        }
        
        stage('Setup Environment') {
            steps {
                echo '🔧 Setting up environment...'
                script {
                    // Install Node.js if not available
                    bat '''
                        echo "Checking Node.js installation..."
                        node --version
                        npm --version
                    '''
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo '📦 Installing dependencies...'
                bat '''
                    cd tests
                    npm install
                '''
            }
        }
        
        stage('Backend Tests') {
            steps {
                echo '🧪 Running Backend API Tests...'
                bat '''
                    cd tests
                    node backend-corrected.test.js
                '''
            }
        }
        
        stage('Frontend Tests') {
            steps {
                echo '🎨 Running Frontend Tests...'
                bat '''
                    cd tests
                    node frontend-simple.test.js
                '''
            }
        }
        
        stage('Performance Tests') {
            steps {
                echo '⚡ Running Performance Tests...'
                bat '''
                    cd tests
                    node performance-simple.test.js
                '''
            }
        }
        
        stage('Full Test Suite') {
            steps {
                echo '🚀 Running Complete Test Suite...'
                bat '''
                    cd tests
                    node test-runner.js
                '''
            }
        }
    }
    
    post {
        always {
            echo '📊 Test execution completed!'
            // Clean up workspace
            cleanWs()
        }
        success {
            echo '✅ All tests passed successfully!'
        }
        failure {
            echo '❌ Some tests failed!'
        }
    }
}
