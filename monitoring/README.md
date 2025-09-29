# 📊 Monitoring IDURAR ERP CRM

Ce répertoire contient la configuration complète du monitoring pour l'application IDURAR ERP CRM avec Prometheus, Grafana et Alertmanager.

## 🎯 Vue d'ensemble

Le système de monitoring fournit :
- **Collecte de métriques** avec Prometheus
- **Visualisation** avec Grafana
- **Alertes** avec Alertmanager
- **Monitoring des conteneurs** avec cAdvisor
- **Métriques système** avec Node Exporter

## 🚀 Démarrage rapide

```bash
# Démarrer le monitoring
cd monitoring
docker-compose up -d

# Vérifier le statut
docker ps --filter "name=idurar-"
```

## 🌐 Accès aux interfaces

| Service | URL | Port | Description |
|---------|-----|------|-------------|
| **Prometheus** | http://localhost:9090 | 9090 | Collecte et requête des métriques |
| **Grafana** | http://localhost:3001 | 3001 | Dashboards et visualisation |
| **Alertmanager** | http://localhost:9093 | 9093 | Gestion des alertes |
| **cAdvisor** | http://localhost:8081 | 8081 | Métriques des conteneurs |
| **Node Exporter** | http://localhost:9100 | 9100 | Métriques système |

### 🔑 Identifiants par défaut
- **Grafana** : admin / admin123

## 📊 Dashboards disponibles

### 1. CI/CD Overview
- Métriques Jenkins
- Temps de build
- Taux de succès des pipelines

### 2. Jenkins Detailed
- Jobs Jenkins
- Utilisation des ressources
- Historique des builds

### 3. Performance Baseline
- Métriques de performance
- Temps de réponse
- Utilisation des ressources

## 🔧 Configuration

### Prometheus
- **Fichier** : `prometheus/prometheus.yml`
- **Règles** : `prometheus/rules/`
- **Intervalle de collecte** : 15s

### Grafana
- **Dashboards** : `grafana/dashboards/`
- **Datasources** : `grafana/provisioning/datasources/`
- **Plugins** : grafana-piechart-panel

### Alertmanager
- **Configuration** : `alertmanager/alertmanager.yml`
- **Règles d'alerte** : `prometheus/rules/ci-cd-alerts.yml`

## 📈 Métriques surveillées

### Application
- Temps de réponse API
- Taux d'erreur
- Utilisation CPU/Mémoire
- Requêtes base de données

### Infrastructure
- Utilisation CPU système
- Utilisation mémoire
- Espace disque
- Réseau I/O

### Conteneurs
- CPU par conteneur
- Mémoire par conteneur
- Réseau par conteneur
- Disque par conteneur

## 🚨 Alertes configurées

### Niveau Critique
- CPU > 80% pendant 5 minutes
- Mémoire > 90% pendant 3 minutes
- Disque > 95%
- Service down

### Niveau Warning
- CPU > 60% pendant 10 minutes
- Mémoire > 70% pendant 5 minutes
- Temps de réponse > 2s

## 🛠️ Commandes utiles

```bash
# Voir les logs
docker-compose logs -f prometheus
docker-compose logs -f grafana

# Redémarrer un service
docker-compose restart prometheus

# Voir les métriques
curl http://localhost:9090/api/v1/query?query=up

# Tester les alertes
curl http://localhost:9093/api/v1/alerts
```

## 📋 Maintenance

### Sauvegarde
```bash
# Sauvegarder les données Prometheus
docker cp idurar-prometheus:/prometheus ./backup/

# Sauvegarder les dashboards Grafana
docker cp idurar-grafana:/var/lib/grafana ./backup/
```

### Mise à jour
```bash
# Mettre à jour les images
docker-compose pull
docker-compose up -d
```

## 🔍 Dépannage

### Problèmes courants

1. **Prometheus ne démarre pas**
   - Vérifier la configuration YAML
   - Vérifier les permissions des fichiers

2. **Grafana ne se connecte pas à Prometheus**
   - Vérifier l'URL du datasource
   - Vérifier la connectivité réseau

3. **Métriques manquantes**
   - Vérifier que les services sont up
   - Vérifier la configuration des targets

### Logs utiles
   ```bash
# Logs Prometheus
docker logs idurar-prometheus

# Logs Grafana
docker logs idurar-grafana

# Logs Alertmanager
docker logs idurar-alertmanager
```

## 📚 Documentation technique

### Prometheus Queries
```promql
# CPU usage
100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# Container memory
container_memory_usage_bytes{name="idurar-frontend"}
```

### Grafana Variables
- `$datasource` : Prometheus
- `$interval` : 15s
- `$time_range` : 1h

## 🎯 Bonnes pratiques

1. **Rétention des données** : 200h par défaut
2. **Fréquence de collecte** : 15s pour les métriques critiques
3. **Alertes** : Seuils progressifs (warning → critical)
4. **Dashboards** : Organisés par fonctionnalité
5. **Backup** : Automatique des configurations

---

**Monitoring configuré et optimisé pour IDURAR ERP CRM** 📊