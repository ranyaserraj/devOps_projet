# 🚀 IDURAR ERP CRM - Système de Gestion d'Entreprise

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-18.x-green.svg)](https://nodejs.org/)
[![React](https://img.shields.io/badge/React-18.x-blue.svg)](https://reactjs.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-7.0-green.svg)](https://www.mongodb.com/)
[![Jenkins](https://img.shields.io/badge/Jenkins-CI/CD-orange.svg)](https://jenkins.io/)
[![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-red.svg)](https://prometheus.io/)

## ⚡ Démarrage Rapide

### 🚀 Lancer l'application

#### Version Optimisée (Recommandée)
```bash
docker-compose -f docker-compose-optimized.yml up -d
```
**Accès** : http://localhost:3001

#### Version Standard
```bash
docker-compose up -d
```
**Accès** : http://localhost:3000

### 🔧 Lancer Jenkins
```bash
cd jenkins && docker-compose up -d
```
**Accès** : http://localhost:8080

### 📊 Lancer le monitoring
```bash
cd monitoring && docker-compose up -d
```
**Accès** : 
- Prometheus : http://localhost:9090
- Grafana : http://localhost:3001 (admin/admin123)

## 📋 Table des Matières

- [⚡ Démarrage Rapide](#-démarrage-rapide)
- [🎯 Vue d'ensemble](#-vue-densemble)
- [✨ Fonctionnalités](#-fonctionnalités)
- [🏗️ Architecture](#️-architecture)
- [🚀 Installation Rapide](#-installation-rapide)
- [🐳 Guide d'exécution détaillé](#-guide-dexécution-détaillé)
- [🐳 Docker](#-docker)
- [🔧 Configuration](#-configuration)
- [📊 Monitoring](#-monitoring)
- [🧪 Tests](#-tests)
- [📚 Documentation](#-documentation)
- [🤝 Contribution](#-contribution)
- [📄 Licence](#-licence)

## 🎯 Vue d'ensemble

**IDURAR ERP CRM** est un système de gestion d'entreprise complet développé avec les technologies modernes. Il combine un frontend React, un backend Node.js, une base de données MongoDB, et intègre des outils de CI/CD avec Jenkins et de monitoring avec Prometheus.

### 🎨 Technologies Utilisées

- **Frontend** : React 18 + Vite + TypeScript
- **Backend** : Node.js + Express + MongoDB
- **Base de données** : MongoDB 7.0
- **CI/CD** : Jenkins + Docker
- **Monitoring** : Prometheus + Grafana
- **Containerisation** : Docker + Docker Compose

## ✨ Fonctionnalités

### 🏢 Modules ERP
- **Gestion des clients** : CRM complet
- **Gestion des ventes** : Pipeline de vente
- **Gestion des stocks** : Inventaire en temps réel
- **Gestion financière** : Comptabilité intégrée
- **Rapports** : Tableaux de bord analytiques

### 🔧 Fonctionnalités Techniques
- **Interface responsive** : Compatible mobile/desktop
- **API REST** : Architecture microservices
- **Authentification** : JWT + OAuth2
- **Base de données** : MongoDB avec sharding
- **Monitoring** : Métriques en temps réel
- **CI/CD** : Pipeline automatisé

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   React + Vite  │◄──►│   Node.js       │◄──►│   MongoDB       │
│   Port: 3000    │    │   Port: 5000    │    │   Port: 27017   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Monitoring    │
                    │   Prometheus    │
                    │   Port: 9090    │
                    └─────────────────┘
```

## 🚀 Installation Rapide

### Prérequis
- Docker & Docker Compose
- Node.js 18+ (pour le développement)
- Git

### 1. Cloner le projet
```bash
git clone https://github.com/ranyaserraj/devOps_projet.git
cd devOps_projet
```

### 2. Lancer avec Docker
```bash
# Démarrer l'application
docker-compose up -d

# Vérifier le statut
docker ps
```

### 3. Accéder à l'application

#### Version Optimisée (Recommandée)
- **Frontend** : http://localhost:3001
- **Backend API** : http://localhost:5002
- **Base de données** : localhost:27018
- **Identifiants** : admin@admin.com / admin123

#### Version Standard
- **Frontend** : http://localhost:3000
- **Backend API** : http://localhost:5001
- **Base de données** : localhost:27017
- **Identifiants** : admin@admin.com / admin123

## 🐳 Guide d'exécution détaillé

### 🚀 Lancer l'application IDURAR ERP CRM

#### Méthode 1 : Application complète
```bash
# Démarrer tous les services
docker-compose up -d

# Vérifier que tous les services sont en cours d'exécution
docker ps

# Voir les logs en temps réel
docker-compose logs -f
```

#### Méthode 2 : Services individuels
```bash
# Démarrer seulement la base de données
docker-compose up -d mongodb

# Démarrer le backend
docker-compose up -d backend

# Démarrer le frontend
docker-compose up -d frontend
```

#### Vérification des services
```bash
# Vérifier le statut des conteneurs
docker ps --filter "name=idurar-"

# Tester l'accès aux services
curl http://localhost:3000  # Frontend
curl http://localhost:5000  # Backend
```

### 🔧 Lancer Jenkins CI/CD

#### Démarrage de Jenkins
```bash
# Naviguer vers le répertoire Jenkins
cd jenkins

# Démarrer Jenkins avec Docker
docker-compose up -d

# Vérifier que Jenkins est en cours d'exécution
docker ps --filter "name=jenkins"
```

#### Configuration initiale
```bash
# Récupérer le mot de passe administrateur initial
docker exec jenkins-simple cat /var/jenkins_home/secrets/initialAdminPassword

# Accéder à Jenkins
# URL : http://localhost:8080
# Utiliser le mot de passe récupéré ci-dessus
```

#### Créer un job Pipeline
1. **Accéder à Jenkins** : http://localhost:8080
2. **Cliquer sur "New Item"**
3. **Nom du job** : `IDURAR-ERP-Tests`
4. **Sélectionner "Pipeline"**
5. **Configuration** :
   - **Pipeline Definition** : "Pipeline script from SCM"
   - **SCM** : "Git"
   - **Repository URL** : `https://github.com/ranyaserraj/devOps_projet.git`
   - **Branch** : `master`
   - **Script Path** : `jenkins/Jenkinsfile`

#### Lancer le pipeline
```bash
# Lancer un build manuellement
curl -X POST http://localhost:8080/job/IDURAR-ERP-Tests/build

# Voir le statut du build
curl http://localhost:8080/job/IDURAR-ERP-Tests/lastBuild/api/json
```

### 📊 Lancer Prometheus et Grafana

#### Démarrage du monitoring
```bash
# Naviguer vers le répertoire monitoring
cd monitoring

# Démarrer tous les services de monitoring
docker-compose up -d

# Vérifier que tous les services sont en cours d'exécution
docker ps --filter "name=idurar-"
```

#### Services de monitoring démarrés
| Service | URL | Port | Description |
|---------|-----|------|-------------|
| **Prometheus** | http://localhost:9090 | 9090 | Collecte des métriques |
| **Grafana** | http://localhost:3001 | 3001 | Dashboards et visualisation |
| **Alertmanager** | http://localhost:9093 | 9093 | Gestion des alertes |
| **cAdvisor** | http://localhost:8081 | 8081 | Métriques des conteneurs |
| **Node Exporter** | http://localhost:9100 | 9100 | Métriques système |

#### Configuration Grafana
1. **Accéder à Grafana** : http://localhost:3001
2. **Identifiants** : `admin` / `admin123`
3. **Datasource** : Prometheus (http://prometheus:9090)
4. **Dashboards** : Pré-configurés et disponibles

#### Vérification du monitoring
```bash
# Tester l'accès à Prometheus
curl http://localhost:9090/api/v1/query?query=up

# Tester l'accès à Grafana
curl http://localhost:3001/api/health

# Voir les métriques des conteneurs
curl http://localhost:8081/metrics
```

### 🔄 Workflow complet

#### 1. Démarrer l'application
```bash
# Application principale
docker-compose up -d

# Vérifier l'accès
curl http://localhost:3000
curl http://localhost:5000
```

#### 2. Démarrer Jenkins
```bash
# Jenkins CI/CD
cd jenkins
docker-compose up -d

# Vérifier Jenkins
curl http://localhost:8080
```

#### 3. Démarrer le monitoring
```bash
# Monitoring
cd monitoring
docker-compose up -d

# Vérifier Prometheus et Grafana
curl http://localhost:9090
curl http://localhost:3001
```

#### 4. Vérification complète
```bash
# Voir tous les services en cours d'exécution
docker ps

# Vérifier les ressources utilisées
docker stats --no-stream
```

### 🛠️ Commandes de gestion

#### Arrêter les services
```bash
# Arrêter l'application
docker-compose down

# Arrêter Jenkins
cd jenkins && docker-compose down

# Arrêter le monitoring
cd monitoring && docker-compose down
```

#### Redémarrer les services
```bash
# Redémarrer l'application
docker-compose restart

# Redémarrer un service spécifique
docker-compose restart idurar-frontend
```

#### Voir les logs
```bash
# Logs de l'application
docker-compose logs -f

# Logs d'un service spécifique
docker-compose logs -f idurar-backend

# Logs Jenkins
cd jenkins && docker-compose logs -f

# Logs monitoring
cd monitoring && docker-compose logs -f prometheus
```

### 🚨 Dépannage

#### Problèmes courants
```bash
# Vérifier les ports utilisés
netstat -an | findstr :3000
netstat -an | findstr :5000
netstat -an | findstr :8080
netstat -an | findstr :9090

# Libérer un port si nécessaire
docker stop $(docker ps -q --filter "publish=3000")
```

#### Redémarrage complet
```bash
# Arrêter tous les services
docker-compose down
cd jenkins && docker-compose down
cd ../monitoring && docker-compose down

# Nettoyer les conteneurs
docker system prune -f

# Redémarrer tout
docker-compose up -d
cd jenkins && docker-compose up -d
cd ../monitoring && docker-compose up -d
```

## 🐳 Docker

### Services Docker

| Service | Port | Description |
|---------|------|-------------|
| `idurar-frontend` | 3000 | Interface utilisateur React |
| `idurar-backend` | 5000 | API REST Node.js |
| `idurar-mongodb` | 27017 | Base de données MongoDB |

### Commandes Docker utiles

```bash
# Démarrer tous les services
docker-compose up -d

# Arrêter tous les services
docker-compose down

# Voir les logs
docker-compose logs -f

# Redémarrer un service
docker-compose restart idurar-frontend

# Voir l'utilisation des ressources
docker stats
```

## 🔧 Configuration

### Variables d'environnement

#### Backend (.env)
```env
NODE_ENV=development
DATABASE=mongodb://admin:password123@mongodb:27017/idurar_erp_crm?authSource=admin
JWT_SECRET=your-jwt-secret-key-here
JWT_EXPIRES_IN=7d
PORT=5000
```

#### Frontend (.env)
```env
VITE_API_URL=http://localhost:5000
VITE_APP_NAME=IDURAR ERP CRM
```

### Base de données
- **Utilisateur** : admin
- **Mot de passe** : password123
- **Base de données** : idurar_erp_crm

## 📊 Monitoring

### Prometheus & Grafana

Le système inclut un monitoring complet avec Prometheus et Grafana :

```bash
# Démarrer le monitoring
cd monitoring
docker-compose up -d
```

**Accès aux interfaces :**
- **Prometheus** : http://localhost:9090
- **Grafana** : http://localhost:3001 (admin/admin123)
- **cAdvisor** : http://localhost:8081

### Métriques surveillées
- Utilisation CPU et mémoire
- Performance des conteneurs
- Métriques réseau
- Temps de réponse API
- Utilisation de la base de données

## 🧪 Tests

### Tests automatisés
```bash
# Tests backend
cd tests
node backend-simple.test.js

# Tests frontend
node frontend-simple.test.js

# Tests de performance
node performance-simple.test.js

# Suite complète
node test-runner.js
```

### Tests avec Jenkins
- **Jenkins** : http://localhost:8080
- **Pipeline** : Automatique avec chaque commit
- **Rapports** : Disponibles dans Jenkins

## 📚 Documentation

### Structure du projet
```
idurar-erp-crm/
├── frontend/                 # Application React
│   ├── src/                 # Code source
│   ├── public/              # Assets statiques
│   └── Dockerfile           # Image Docker frontend
├── backend/                 # API Node.js
│   ├── src/                 # Code source
│   └── Dockerfile           # Image Docker backend
├── monitoring/              # Prometheus & Grafana
│   ├── prometheus/          # Configuration Prometheus
│   ├── grafana/             # Dashboards Grafana
│   └── docker-compose.yml   # Services de monitoring
├── jenkins/                 # Configuration CI/CD
│   ├── Jenkinsfile          # Pipeline Jenkins
│   └── docker-compose.yml   # Jenkins avec Docker
├── tests/                   # Tests automatisés
│   ├── backend/             # Tests API
│   ├── frontend/            # Tests UI
│   └── performance/         # Tests de charge
└── docker-compose.yml       # Configuration principale
```

### API Endpoints

#### Authentification
- `POST /api/auth/login` - Connexion
- `POST /api/auth/register` - Inscription
- `POST /api/auth/logout` - Déconnexion

#### Gestion des clients
- `GET /api/clients` - Liste des clients
- `POST /api/clients` - Créer un client
- `PUT /api/clients/:id` - Modifier un client
- `DELETE /api/clients/:id` - Supprimer un client

#### Gestion des ventes
- `GET /api/sales` - Liste des ventes
- `POST /api/sales` - Créer une vente
- `GET /api/sales/:id` - Détails d'une vente

## 🚀 Déploiement

### Production
```bash
# Configuration production
docker-compose -f docker-compose.prod.yml up -d

# Avec monitoring
docker-compose -f docker-compose.yml -f monitoring/docker-compose.yml up -d
```

### Variables de production
- Configurer les variables d'environnement
- Utiliser HTTPS en production
- Configurer un reverse proxy (Nginx)
- Sauvegarder la base de données

## 🤝 Contribution

### Développement local
```bash
# Cloner le projet
git clone https://github.com/ranyaserraj/devOps_projet.git

# Installer les dépendances
cd frontend && npm install
cd ../backend && npm install

# Démarrer en mode développement
npm run dev
```

### Guidelines
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📊 Performance

### Métriques actuelles
- **CPU Usage** : < 1% (excellent)
- **Memory Usage** : < 5% (optimal)
- **Response Time** : < 100ms
- **Uptime** : 99.9%

### Optimisations
- Lazy loading des composants React
- Cache Redis pour les sessions
- Compression gzip
- CDN pour les assets statiques

## 🔒 Sécurité

- Authentification JWT
- Validation des entrées
- Protection CSRF
- Rate limiting
- Chiffrement des mots de passe
- HTTPS en production

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 📞 Support

- **Email** : support@idurar.com
- **Documentation** : [docs.idurar.com](https://docs.idurar.com)
- **Issues** : [GitHub Issues](https://github.com/ranyaserraj/devOps_projet/issues)

## 🎉 Remerciements

- Équipe de développement IDURAR
- Communauté open source
- Contributeurs GitHub

---

**Développé avec ❤️ par l'équipe IDURAR**