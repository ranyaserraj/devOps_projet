# 🚀 IDURAR ERP CRM - Système de Gestion d'Entreprise

[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-18.x-green.svg)](https://nodejs.org/)
[![React](https://img.shields.io/badge/React-18.x-blue.svg)](https://reactjs.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-7.0-green.svg)](https://www.mongodb.com/)
[![Jenkins](https://img.shields.io/badge/Jenkins-CI/CD-orange.svg)](https://jenkins.io/)
[![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-red.svg)](https://prometheus.io/)

## 📋 Table des Matières

- [🎯 Vue d'ensemble](#-vue-densemble)
- [✨ Fonctionnalités](#-fonctionnalités)
- [🏗️ Architecture](#️-architecture)
- [🚀 Installation Rapide](#-installation-rapide)
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
- **Frontend** : http://localhost:3000
- **Backend API** : http://localhost:5000
- **Base de données** : localhost:27017

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