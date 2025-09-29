# 📊 IDURAR ERP CRM - Monitoring CI/CD Baseline

## 🎯 Objectifs

Ce module de monitoring permet de suivre en temps réel la consommation des ressources lors des jobs CI/CD et de générer des métriques détaillées sur :

- **CPU, RAM, durée d'exécution, disque**
- **Métriques des tests baseline**
- **Performance des builds Jenkins**
- **Consommation des conteneurs Docker**

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Jenkins       │    │   Prometheus    │    │    Grafana      │
│   (CI/CD)       │───▶│   (Metrics)     │───▶│  (Dashboards)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Node Exporter   │    │   cAdvisor      │    │  Alertmanager   │
│ (System)        │    │ (Containers)    │    │   (Alerts)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 🚀 Démarrage Rapide

### 1. Lancer le Stack de Monitoring

```bash
cd monitoring
docker-compose up -d
```

### 2. Accéder aux Services

| Service | URL | Credentials |
|---------|-----|-------------|
| **Grafana** | http://localhost:3001 | admin/admin123 |
| **Prometheus** | http://localhost:9090 | - |
| **Jenkins** | http://localhost:8081 | - |
| **Alertmanager** | http://localhost:9093 | - |

## 📈 Dashboards Disponibles

### 1. **CI/CD Overview** (`/dashboards/ci-cd-overview.json`)
- ✅ Statut des jobs CI/CD
- 📊 Utilisation CPU/Mémoire système
- 💾 Utilisation disque
- ⏱️ Durée des jobs
- 🐳 Ressources des conteneurs

### 2. **Performance Baseline** (`/dashboards/performance-baseline.json`)
- 🧪 Temps d'exécution des tests
- 📊 Taux de succès des tests
- 🌐 Temps de réponse API
- 📈 Couverture de code
- 🔥 Consommation pendant les tests

### 3. **Jenkins Detailed** (`/dashboards/jenkins-detailed.json`)
- 📋 Queue des builds
- 🏗️ Builds actifs
- ✅ Taux de succès
- 📊 Distribution des statuts
- 💻 Charge système Jenkins

## 🔧 Configuration

### Variables d'Environnement

```bash
# Jenkins
JENKINS_URL=http://jenkins:8080
JENKINS_USER=admin
JENKINS_TOKEN=your_token

# Monitoring
PROMETHEUS_RETENTION=200h
GRAFANA_ADMIN_PASSWORD=admin123
```

### Métriques Collectées

#### **Système**
- `node_cpu_seconds_total` - Utilisation CPU
- `node_memory_MemTotal_bytes` - Mémoire totale
- `node_filesystem_size_bytes` - Taille disque

#### **Conteneurs**
- `container_cpu_usage_seconds_total` - CPU conteneur
- `container_memory_usage_bytes` - Mémoire conteneur
- `container_network_receive_bytes_total` - Réception réseau

#### **Jenkins**
- `jenkins_job_duration_seconds` - Durée des jobs
- `jenkins_job_last_build_result` - Résultat des builds
- `jenkins_job_queue_size` - Taille de la queue

#### **Tests Baseline**
- `test_duration_seconds` - Durée des tests
- `test_total` - Nombre total de tests
- `test_coverage_percent` - Couverture de code
- `http_request_duration_seconds` - Temps de réponse API

## 🚨 Alertes Configurées

### Seuils d'Alerte

| Métrique | Seuil | Action |
|----------|-------|--------|
| **CPU Usage** | > 80% | ⚠️ Warning |
| **Memory Usage** | > 85% | ⚠️ Warning |
| **Disk Usage** | > 90% | 🚨 Critical |
| **Job Duration** | > 30min | ⚠️ Warning |
| **Failed Jobs** | > 0 | 🚨 Critical |

### Configuration des Alertes

```yaml
# prometheus/rules/ci-cd-alerts.yml
groups:
  - name: ci-cd-alerts
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
```

## 📊 Scripts de Collecte

### 1. **Metrics Collector** (`scripts/metrics-collector.js`)
```javascript
const { MetricsCollector } = require('./metrics-collector');

const collector = new MetricsCollector();

// Enregistrer une exécution de test
collector.recordTestExecution('api', 'backend', 45.2, 'success');

// Enregistrer la couverture
collector.recordTestCoverage('backend', 'line', 85.5);
```

### 2. **Jenkins Metrics Exporter** (`scripts/jenkins-metrics-exporter.js`)
```bash
# Démarrer l'exporteur
npm start

# Métriques disponibles
curl http://localhost:9091/metrics
```

## 🔍 Requêtes Prometheus Utiles

### Top 5 des Jobs les Plus Longs
```promql
topk(5, jenkins_job_duration_seconds)
```

### Utilisation CPU Moyenne
```promql
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### Taux de Succès des Tests
```promql
sum(rate(test_total{result="success"}[5m])) / sum(rate(test_total[5m])) * 100
```

### Consommation Mémoire des Conteneurs
```promql
container_memory_usage_bytes / container_spec_memory_limit_bytes * 100
```

## 🛠️ Maintenance

### Sauvegarde des Données
```bash
# Sauvegarder Grafana
docker exec idurar-grafana grafana-cli admin reset-admin-password newpassword

# Sauvegarder Prometheus
docker exec idurar-prometheus promtool tsdb create-blocks-from openmetrics /backup/metrics.txt /prometheus
```

### Nettoyage
```bash
# Nettoyer les anciennes métriques
docker exec idurar-prometheus promtool tsdb clean --retention.time=200h /prometheus
```

### Mise à Jour
```bash
# Mettre à jour les dashboards
docker-compose down
docker-compose pull
docker-compose up -d
```

## 📚 Ressources

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Jenkins Prometheus Plugin](https://plugins.jenkins.io/prometheus/)
- [cAdvisor Documentation](https://github.com/google/cadvisor)

## 🆘 Dépannage

### Problèmes Courants

1. **Grafana ne se connecte pas à Prometheus**
   ```bash
   # Vérifier la connectivité
   docker exec idurar-grafana curl http://prometheus:9090/api/v1/query?query=up
   ```

2. **Métriques Jenkins manquantes**
   ```bash
   # Vérifier l'exporteur
   curl http://localhost:9091/health
   ```

3. **Alertes non déclenchées**
   ```bash
   # Vérifier les règles
   docker exec idurar-prometheus promtool check rules /etc/prometheus/rules/ci-cd-alerts.yml
   ```

### Logs
```bash
# Voir les logs
docker-compose logs -f grafana
docker-compose logs -f prometheus
docker-compose logs -f jenkins
```

---

**🎉 Votre stack de monitoring CI/CD baseline est maintenant opérationnel !**

Accédez à Grafana sur http://localhost:3001 pour visualiser vos métriques en temps réel.

