# 🚀 Branche branch2 - Jenkins avec Monitoring Corrigé

## 📋 Résumé

Cette branche `branch2` contient la solution complète pour corriger le problème Jenkins de la branche `branch1` tout en préservant toutes les fonctionnalités de monitoring.

## ✅ Problème Résolu

- **Jenkins Port**: Corrigé de 8081 vers 8080 (standard)
- **Historique**: Restauré et fonctionnel
- **Monitoring**: Toutes les fonctionnalités préservées
- **Compatibilité**: Fonctionne avec la branche master

## 🗂️ Structure de la Branche

```
branch2/
├── monitoring-fixed/                    # Configuration Jenkins corrigée
│   ├── docker-compose-fixed.yml        # Docker Compose corrigé
│   ├── Jenkinsfile-monitoring          # Pipeline Jenkins avec monitoring
│   ├── jenkins-plugins.txt            # Plugins Jenkins nécessaires
│   ├── start-monitoring-fixed.ps1     # Script PowerShell
│   ├── start-monitoring-fixed.bat     # Script Batch
│   ├── README-MONITORING-FIXED.md     # Documentation
│   ├── prometheus/                     # Configuration Prometheus
│   │   ├── prometheus.yml
│   │   └── rules/ci-cd-alerts.yml
│   ├── grafana/                        # Configuration Grafana
│   │   ├── provisioning/
│   │   └── dashboards/jenkins-detailed.json
│   ├── alertmanager/                   # Configuration Alertmanager
│   │   └── alertmanager.yml
│   └── scripts/                        # Scripts de monitoring
│       ├── jenkins-metrics-exporter.js
│       ├── metrics-collector.js
│       ├── package.json
│       └── Dockerfile
├── backend/                            # Backend IDURAR (inchangé)
├── frontend/                           # Frontend IDURAR (inchangé)
├── tests/                              # Tests baseline (inchangé)
└── jenkins/                            # Configuration Jenkins originale
```

## 🚀 Démarrage Rapide

### 1. Basculer sur la branche branch2
```bash
git checkout branch2
```

### 2. Démarrer Jenkins avec monitoring
```powershell
cd monitoring-fixed
.\start-monitoring-fixed.ps1
```

### 3. Accéder aux services
- **Jenkins**: http://localhost:8080
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001 (admin/admin123)

## 🔧 Fonctionnalités

### Jenkins Corrigé
- ✅ Port 8080 standard
- ✅ Historique des jobs restauré
- ✅ Plugins Prometheus installés
- ✅ Pipeline avec monitoring

### Monitoring Complet
- ✅ Prometheus pour métriques
- ✅ Grafana pour dashboards
- ✅ Alertmanager pour alertes
- ✅ Node Exporter pour système
- ✅ cAdvisor pour conteneurs

### Tests Baseline
- ✅ Backend API Tests
- ✅ Frontend Tests
- ✅ Performance Tests
- ✅ Métriques automatiques

## 📊 Avantages par rapport à branch1

| Aspect | branch1 (Problématique) | branch2 (Corrigé) |
|--------|-------------------------|-------------------|
| **Jenkins Port** | 8081 (conflit) | 8080 (standard) |
| **Historique** | ❌ Non visible | ✅ Fonctionnel |
| **Monitoring** | ✅ Présent | ✅ Préservé |
| **Compatibilité** | ❌ Problèmes | ✅ Compatible |
| **Démarrage** | ❌ Complexe | ✅ Simple |

## 🎯 Utilisation

### Créer un Job Jenkins
1. Aller sur http://localhost:8080
2. "New Item" → "idurar-baseline-tests"
3. Pipeline → Copier `Jenkinsfile-monitoring`
4. Lancer le build

### Vérifier le Monitoring
1. Grafana: http://localhost:3001
2. Dashboard "Jenkins Detailed Metrics"
3. Métriques en temps réel

### Gérer les Alertes
1. Alertmanager: http://localhost:9093
2. Configuration automatique
3. Notifications en cas de problème

## 📈 Métriques Disponibles

- **Tests**: Durée, succès/échec, couverture
- **Jenkins**: Builds, queue, agents
- **Système**: CPU, mémoire, réseau
- **Conteneurs**: Ressources Docker

## 🔧 Dépannage

### Jenkins ne démarre pas
```bash
docker-compose -f monitoring-fixed/docker-compose-fixed.yml logs jenkins
```

### Port 8080 occupé
```bash
netstat -an | findstr :8080
docker-compose -f monitoring-fixed/docker-compose-fixed.yml down
```

### Métriques manquantes
```bash
curl http://localhost:9090/api/v1/targets
curl http://localhost:9091/metrics
```

## 📞 Support

- **Documentation**: `monitoring-fixed/README-MONITORING-FIXED.md`
- **Jenkins**: http://localhost:8080
- **Monitoring**: http://localhost:3001
- **Métriques**: http://localhost:9090

---

**✅ Branche branch2 : Jenkins corrigé avec monitoring complet !** 🚀
