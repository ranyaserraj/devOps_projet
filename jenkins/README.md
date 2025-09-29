# 🔧 Jenkins CI/CD pour IDURAR ERP CRM

Configuration Jenkins complète pour l'intégration continue et le déploiement automatique de l'application IDURAR ERP CRM.

## 🎯 Vue d'ensemble

Ce répertoire contient :
- **Jenkinsfile** : Pipeline principal automatisé
- **Configuration Docker** : Jenkins avec Docker support
- **Tests automatisés** : Suite complète de tests
- **Monitoring** : Intégration avec Prometheus

## 🚀 Démarrage rapide

### 1. Lancer Jenkins
```bash
cd jenkins
docker-compose up -d
```

### 2. Accéder à Jenkins
- **URL** : http://localhost:8080
- **Mot de passe initial** : Voir les logs du conteneur

### 3. Récupérer le mot de passe
```bash
docker exec jenkins-simple cat /var/jenkins_home/secrets/initialAdminPassword
```

## 📋 Configuration

### Services Jenkins

| Service | Port | Description |
|---------|------|-------------|
| **Jenkins Master** | 8080 | Interface web Jenkins |
| **Jenkins Agent** | 50000 | Agent de build |
| **MongoDB Test** | 27018 | Base de données de test |

### Variables d'environnement
```env
JAVA_OPTS=-Djenkins.install.runSetupWizard=false
JENKINS_OPTS=--httpPort=8080
```

## 🔄 Pipeline Jenkins

### Étapes du pipeline
1. **Checkout** : Récupération du code depuis GitHub
2. **Setup Environment** : Installation de Node.js 18
3. **Install Dependencies** : Installation des dépendances npm
4. **Backend Tests** : Tests de l'API backend
5. **Frontend Tests** : Tests de l'interface utilisateur
6. **Performance Tests** : Tests de performance
7. **Full Test Suite** : Suite complète de tests

### Configuration du job
1. Créer un nouveau job "Pipeline"
2. Sélectionner "Pipeline script from SCM"
3. **SCM** : Git
4. **Repository URL** : `https://github.com/ranyaserraj/devOps_projet.git`
5. **Branch** : `master`
6. **Script Path** : `jenkins/Jenkinsfile`

## 🧪 Tests automatisés

### Types de tests
- **Tests Backend** : API REST, base de données
- **Tests Frontend** : Interface utilisateur, composants
- **Tests Performance** : Charge, temps de réponse
- **Tests d'intégration** : Workflows complets

### Exécution des tests
```bash
# Tests locaux
cd tests
node test-runner.js

# Tests spécifiques
node backend-simple.test.js
node frontend-simple.test.js
node performance-simple.test.js
```

## 📊 Monitoring Jenkins

### Métriques surveillées
- **Builds** : Temps d'exécution, taux de succès
- **Ressources** : CPU, mémoire, disque
- **Jobs** : Historique, statistiques
- **Agents** : Utilisation, performance

### Intégration Prometheus
- **Plugin** : Prometheus Metrics Plugin
- **Endpoint** : `/prometheus`
- **Fréquence** : 30s

## 🛠️ Commandes utiles

### Gestion des conteneurs
```bash
# Voir les logs
docker logs jenkins-simple

# Redémarrer Jenkins
docker-compose restart

# Arrêter Jenkins
docker-compose down
```

### Gestion des jobs
```bash
# Lancer un build
curl -X POST http://localhost:8080/job/IDURAR-ERP-Tests/build

# Voir le statut
curl http://localhost:8080/job/IDURAR-ERP-Tests/lastBuild/api/json
```

## 🔧 Configuration avancée

### Plugins recommandés
- **Pipeline** : Support des pipelines
- **Docker** : Intégration Docker
- **Prometheus** : Métriques
- **Git** : Intégration Git
- **NodeJS** : Support Node.js

### Variables globales
- `NODE_VERSION` : 18
- `DOCKER_HOST` : unix:///var/run/docker.sock
- `WORKSPACE` : /var/jenkins_home/workspace

## 📈 Optimisations

### Performance
- **Agents** : Utilisation d'agents Docker
- **Cache** : Cache des dépendances npm
- **Parallélisation** : Tests en parallèle
- **Ressources** : Limitation CPU/Mémoire

### Sécurité
- **Credentials** : Gestion sécurisée des secrets
- **Permissions** : Contrôle d'accès par utilisateur
- **Scan** : Analyse de sécurité des dépendances

## 🚨 Alertes

### Seuils configurés
- **Build failed** : Notification immédiate
- **Performance** : Temps de build > 10 minutes
- **Ressources** : CPU > 80%
- **Disponibilité** : Jenkins down

### Canaux de notification
- **Email** : Notifications par email
- **Slack** : Intégration Slack
- **Webhook** : Notifications webhook

## 📋 Maintenance

### Sauvegarde
```bash
# Sauvegarder la configuration
docker cp jenkins-simple:/var/jenkins_home ./backup/

# Sauvegarder les jobs
tar -czf jenkins-backup.tar.gz ./backup/
```

### Mise à jour
```bash
# Mettre à jour Jenkins
docker-compose pull
docker-compose up -d
```

## 🔍 Dépannage

### Problèmes courants

1. **Jenkins ne démarre pas**
   - Vérifier les logs : `docker logs jenkins-simple`
   - Vérifier les ports disponibles
   - Vérifier les permissions Docker

2. **Builds échouent**
   - Vérifier la connectivité réseau
   - Vérifier les dépendances
   - Vérifier la configuration du pipeline

3. **Agents non disponibles**
   - Vérifier la configuration Docker
   - Vérifier les ressources système
   - Vérifier la connectivité

### Logs utiles
```bash
# Logs Jenkins
docker logs jenkins-simple

# Logs des builds
docker logs jenkins-simple -f

# Logs système
docker system logs
```

## 📚 Documentation technique

### Jenkinsfile Structure
```groovy
pipeline {
    agent any
    options {
        timeout(time: 10, unit: 'MINUTES')
        timestamps()
    }
    environment {
        NODE_VERSION = '18'
    }
    stages {
        // Étapes du pipeline
    }
    post {
        // Actions post-build
    }
}
```

### Variables d'environnement
- `NODE_VERSION` : Version de Node.js
- `WORKSPACE` : Répertoire de travail
- `BUILD_NUMBER` : Numéro de build
- `GIT_COMMIT` : Commit Git

## 🎯 Bonnes pratiques

1. **Pipeline as Code** : Jenkinsfile versionné
2. **Tests** : Tests automatisés obligatoires
3. **Sécurité** : Credentials sécurisés
4. **Monitoring** : Métriques en temps réel
5. **Backup** : Sauvegarde régulière

---

**Jenkins configuré et optimisé pour IDURAR ERP CRM** 🔧
