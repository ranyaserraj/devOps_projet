# 📊 Configuration Grafana pour DevOps Project

## 🎯 Vue d'ensemble

Cette configuration Grafana permet de surveiller en temps réel les métriques des conteneurs de la version non-optimisée du projet DevOps.

## 🚀 Accès rapide

### URLs des services
- **Grafana Dashboard**: http://localhost:3000
- **Prometheus**: http://localhost:9090  
- **cAdvisor**: http://localhost:8080

### Identifiants
- **Username**: admin
- **Password**: admin123

## 📋 Conteneurs surveillés

- `idurar-frontend` (Port 3002)
- `idurar-backend` (Port 5001)
- `idurar-mongodb` (Port 27017)
- `idurar-portainer` (Port 9000)

## 🛠️ Scripts disponibles

### 1. Accès rapide à Grafana
```bash
./access-grafana.sh
```
Ouvre Grafana dans le navigateur et affiche les informations de connexion.

### 2. Import automatique du dashboard
```bash
./import-dashboard.sh
```
Importe automatiquement le dashboard DevOps dans Grafana.

### 3. Démonstration des métriques
```bash
./demo-metrics.sh
```
Affiche les métriques en temps réel dans le terminal.

## 📈 Dashboard DevOps

### Nom du dashboard
**"DevOps Project - Conteneurs Non-Optimisés (Live)"**

### Métriques surveillées

1. **CPU Usage** - Utilisation CPU des conteneurs DevOps
2. **Memory Usage** - Utilisation mémoire des conteneurs DevOps  
3. **Network I/O** - Trafic réseau des conteneurs DevOps
4. **Résumé DevOps Project** - Vue d'ensemble du projet
5. **État des conteneurs** - Statut en temps réel

### Configuration
- **Rafraîchissement**: 5 secondes
- **Période**: Dernière heure
- **Style**: Dark theme
- **Timezone**: Browser

## 🔧 Configuration technique

### Services de monitoring
- **Grafana**: Interface de visualisation
- **Prometheus**: Collecte des métriques
- **cAdvisor**: Métriques des conteneurs Docker
- **Node Exporter**: Métriques système

### Fichiers de configuration
- `monitoring/grafana/dashboards/devops-containers-live.json` - Dashboard principal
- `monitoring/prometheus/prometheus-non-optimized.yml` - Configuration Prometheus
- `monitoring/docker-compose-grafana-non-optimized.yml` - Services Docker

## 🎯 Utilisation

### 1. Démarrer les services
```bash
docker-compose -f monitoring/docker-compose-grafana-non-optimized.yml up -d
```

### 2. Importer le dashboard
```bash
./import-dashboard.sh
```

### 3. Accéder à Grafana
```bash
./access-grafana.sh
```

### 4. Naviguer vers le dashboard
1. Se connecter à http://localhost:3000
2. Aller dans "Dashboards" > "DevOps Project"
3. Sélectionner "DevOps Project - Conteneurs Non-Optimisés (Live)"

## 📊 Métriques disponibles

### CPU
- `rate(container_cpu_usage_seconds_total{name=~"idurar-.*"}[5m]) * 100`

### Mémoire
- `container_memory_usage_bytes{name=~"idurar-.*"} / 1024 / 1024`

### Réseau
- `rate(container_network_receive_bytes_total{name=~"idurar-.*"}[5m])`
- `rate(container_network_transmit_bytes_total{name=~"idurar-.*"}[5m])`

### État des conteneurs
- `container_last_seen{name=~"idurar-.*"}`

## 🔄 Maintenance

### Redémarrer les services
```bash
docker restart grafana-non-optimized prometheus-non-optimized cadvisor-non-optimized
```

### Vérifier l'état
```bash
docker ps --filter "name=non-optimized"
```

### Logs
```bash
docker logs grafana-non-optimized
docker logs prometheus-non-optimized
docker logs cadvisor-non-optimized
```

## 🎨 Personnalisation

### Modifier le dashboard
1. Ouvrir Grafana
2. Aller dans "Dashboards" > "DevOps Project"
3. Cliquer sur "DevOps Project - Conteneurs Non-Optimisés (Live)"
4. Cliquer sur "Settings" > "JSON Model"
5. Modifier le JSON selon vos besoins
6. Sauvegarder

### Ajouter de nouveaux conteneurs
1. Modifier `monitoring/prometheus/prometheus-non-optimized.yml`
2. Ajouter le nom du conteneur dans la section `params.container`
3. Redémarrer Prometheus

## 🚨 Dépannage

### Grafana ne démarre pas
```bash
docker logs grafana-non-optimized
```

### Prometheus ne collecte pas les métriques
```bash
curl http://localhost:9090/api/v1/targets
```

### cAdvisor ne fonctionne pas
```bash
curl http://localhost:8080/metrics
```

### Dashboard ne s'affiche pas
1. Vérifier que le dashboard est importé
2. Vérifier la source de données Prometheus
3. Redémarrer Grafana

## 📝 Notes importantes

- Les métriques sont collectées toutes les 5 secondes
- Le dashboard se met à jour automatiquement
- Les données sont conservées pendant 15 jours par défaut
- Pour une surveillance continue, laisser Grafana ouvert dans un onglet du navigateur
