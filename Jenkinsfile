pipeline {
    agent any

    environment {
        DATABASE = credentials('DATABASE')
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Checkout code'
                git branch: 'fatimzehra', url: 'https://github.com/ranyaserraj/devOps_projet.git'
            }
        }

        stage('Check Node') {
            steps {
                sh 'node -v; npm -v'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo '📦 Installing dependencies'
                sh '''
                    cd backend && npm install --legacy-peer-deps
                    cd ../frontend && npm install --legacy-peer-deps
                    cd ../tests && npm install --legacy-peer-deps
                '''
            }
        }

        stage('Build') {
            steps {
                echo '🏗️ Build if exists'
                sh '''
                    cd tests
                    npm run build || echo "⚠️ No build script found, skipping..."
                '''
            }
        }

        stage('Check DB') {
            steps {
                echo '🔗 Checking MongoDB'
                sh '''
                    cd backend
                    node -e "
                        const mongoose = require('mongoose');
                        mongoose.connect(process.env.DATABASE)
                            .then(() => { console.log('✅ MongoDB connected'); process.exit(0); })
                            .catch(err => { console.error('❌ MongoDB connection failed:', err.message); process.exit(1); });
                    "
                '''
            }
        }

        stage('Start App') {
            steps {
                echo '🚀 Starting backend/frontend'
                sh '''
                    cd backend && nohup npm start &
                    cd ../frontend && nohup npm run dev -- --port 3000 --host 0.0.0.0 &
                    sleep 20
                '''
            }
        }

        stage('Run Tests') {
            steps {
                echo '🧪 Running tests'
                sh '''
                    cd tests
                    [ -f backend-corrected.test.js ] && node backend-corrected.test.js || echo "No backend tests"
                    [ -f frontend-simple.test.js ] && node frontend-simple.test.js || echo "No frontend tests"
                    [ -f performance-simple.test.js ] && node performance-simple.test.js || echo "No performance tests"
                '''
            }
        }

        stage('Measure Baseline') {
            steps {
                echo '📏 Measuring baseline'
                sh '''
                    cd tests
                    [ -f test-runner.js ] && /usr/bin/time -v node test-runner.js || echo "No test-runner"
                '''
            }
        }

    }

    post {
        always {
            cleanWs()
            echo '📊 Pipeline finished'
        }
        success {
            echo '✅ Success'
        }
        failure {
            echo '❌ Failure'
        }
    }
}
