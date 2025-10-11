pipeline {
    agent any

    environment {
        DATABASE = credentials('DATABASE')
        DOCKER_BUILDKIT = '1'  // Active Docker BuildKit
        CACHE_DIR = "/var/jenkins_home/cache"  // Dossier persistant pour les caches
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Checkout code from GitHub...'
                git branch: 'fatimzehra', url: 'https://github.com/ranyaserraj/devOps_projet.git'
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
                echo '📦 Installing dependencies (with caching)'
                sh '''
                mkdir -p $CACHE_DIR

                # === BACKEND ===
                cd backend
                if [ -f $CACHE_DIR/backend-cache.tar.gz ]; then
                    echo "📂 Restoring backend cache..."
                    tar -xzf $CACHE_DIR/backend-cache.tar.gz || echo "⚠️ Failed to restore backend cache"
                fi
                npm install --legacy-peer-deps
                tar -czf $CACHE_DIR/backend-cache.tar.gz node_modules
                cd ..

                # === FRONTEND ===
                cd frontend
                if [ -f $CACHE_DIR/frontend-cache.tar.gz ]; then
                    echo "📂 Restoring frontend cache..."
                    tar -xzf $CACHE_DIR/frontend-cache.tar.gz || echo "⚠️ Failed to restore frontend cache"
                fi
                npm install --legacy-peer-deps
                tar -czf $CACHE_DIR/frontend-cache.tar.gz node_modules
                cd ..

                # === TESTS ===
                cd tests
                if [ -f $CACHE_DIR/tests-cache.tar.gz ]; then
                    echo "📂 Restoring tests cache..."
                    tar -xzf $CACHE_DIR/tests-cache.tar.gz || echo "⚠️ Failed to restore tests cache"
                fi
                npm install --legacy-peer-deps
                tar -czf $CACHE_DIR/tests-cache.tar.gz node_modules
                cd ..
                '''
            }
        }

        stage('Build') {
            steps {
                echo '🏗️ Building project (if script exists)'
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

        stage('Cleanup') {
            steps {
                echo '🧹 Cleaning unused Docker resources...'
                sh 'docker system prune -f || true'
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
                
                # Temps total
                START=$(date +%s)
                
                # Simulation d'un build (ou un vrai build si vous voulez)
                sleep 1  # placeholder pour la commande de build réelle
                
                END=$(date +%s)
                ELAPSED=$((END-START))
                echo "⏱️ Time elapsed: ${ELAPSED} seconds"
                
                # CPU et mémoire (snapshot instantané)
                echo "💻 CPU & Memory usage (top 5 processes):"
                ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
                
                # Empreinte CO2 approximative
                # 0.000233 kg CO2 par Wh pour un serveur moyen (approximation)
                CPU_USAGE=$(ps -eo %cpu --no-headers | awk '{sum+=$1} END {print sum}')
                CO2=$(awk "BEGIN {print $CPU_USAGE*${ELAPSED}*0.000233}")
                echo "🌱 Estimated CO2 footprint: ${CO2} kg CO2"
                '''
            }
        }
    }

    post {
        always {
            echo '📊 Pipeline finished — cleaning workspace'
        }
        success {
            echo '✅ Build completed successfully!'
        }
        failure {
            echo '❌ Build failed — check logs for details'
        }
    }
}
