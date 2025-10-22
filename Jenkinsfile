stage('SonarQube Analysis') {
    steps {
        echo "🔍 Running SonarQube analysis..."
        withSonarQubeEnv('SonarQube') {
            withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                sh '''
                    echo "➡️ Adding SonarScanner to PATH..."
                    export PATH=$PATH:/opt/sonar-scanner/bin
                    sonar-scanner \
                        -Dsonar.projectKey=devops-project \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://sonarqube:9000 \
                        -Dsonar.login=$SONAR_TOKEN
                '''
            }
        }
    }
}
