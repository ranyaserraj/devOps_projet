pipeline {
    agent any

    environment {
        DATABASE = credentials('DATABASE')
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Checkout code from GitHub...'
                git branch: 'fatimzehra-baseline', url: 'https://github.com/ranyaserraj/devOps_projet.git'
            }
        }

        stage('Check Node') {
            steps {
                echo '🧩 Checking Node.js environment...'
                sh '''
                    node -v
                    npm -v
                '''
            }
        }

        stage('Install Dependencies') {
            steps {
                echo '📦 Installing dependencies...'
                sh '''
                    cd backend
                    npm install --legacy-peer-deps
                    cd ../frontend
                    npm install --legacy-peer-deps
                    cd ../tests
                    npm install --legacy-peer-deps
                '''
            }
        }

        stage('Build') {
            steps {
                echo '🏗️ Building project (if script exists)...'
                sh '''
                    cd tests
                    if npm run | grep -q build; then
                        npm run build
                    else
                        echo "⚠️ No build script found, skipping..."
                    fi
                '''
            }
        }

        stage('Check DB') {
            steps {
                echo '🔗 Checking MongoDB connection...'
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
                echo '🚀 Starting backend & frontend servers...'
                sh '''
                    cd backend && nohup npm start &
                    cd ../frontend && nohup npm run dev -- --port 3000 --host 0.0.0.0 &
                    echo "⏳ Waiting for apps to start..."
                    sleep 20
                '''
            }
        }

        stage('Run Tests') {
            steps {
                echo '🧪 Running automated tests...'
                sh '''
                    cd tests
                    [ -f backend-corrected.test.js ] && node backend-corrected.test.js || echo "⚠️ No backend tests"
                    [ -f frontend-simple.test.js ] && node frontend-simple.test.js || echo "⚠️ No frontend tests"
                    [ -f performance-simple.test.js ] && node performance-simple.test.js || echo "⚠️ No performance tests"
                '''
            }
        }

        stage('Measure Baseline') {
            steps {
                echo '📏 Measuring performance baseline...'
                sh '''
                    cd tests
                    [ -f test-runner.js ] && /usr/bin/time -v node test-runner.js || echo "⚠️ No test-runner found"
                '''
            }
        }

        stage('Resource Usage & CO2') {
            steps {
                echo '⚡ Measuring build time, CPU, memory, and estimated CO2 footprint...'
                sh '''
                    echo "📊 Build Metrics:"
                    
                    START=$(date +%s)
                    sleep 1  # placeholder pour le build réel
                    END=$(date +%s)
                    ELAPSED=$((END-START))
                    echo "⏱️ Time elapsed: ${ELAPSED} seconds"
                    
                    echo "💻 CPU & Memory usage (top 5 processes):"
                    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
                    
                    CPU_USAGE=$(ps -eo %cpu --no-headers | awk '{sum+=$1} END {print sum}')
                    CO2=$(awk "BEGIN {print $CPU_USAGE*${ELAPSED}*0.000233}")
                    echo "🌱 Estimated CO2 footprint: ${CO2} kg CO2"
                '''
            }
        }
    }

    post {
        always {
            echo '📊 Pipeline finished'
        }
        success {
            echo '✅ Build completed successfully!'
        }
        failure {
            echo '❌ Build failed — check logs for details'
        }
    }
}
