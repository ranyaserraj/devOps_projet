#!/bin/bash

echo "📊 Import du dashboard Grafana Live Docker Metrics"
echo "================================================"
echo ""

# Vérifier que Grafana est accessible
echo "🔍 Vérification de l'accès à Grafana..."
if ! curl -s http://localhost:3000/api/health > /dev/null 2>&1; then
    echo "❌ Grafana n'est pas accessible sur http://localhost:3000"
    echo "   Veuillez démarrer Grafana avec: docker-compose -f monitoring/docker-compose-grafana-non-optimized.yml up -d"
    exit 1
fi

echo "✅ Grafana est accessible"
echo ""

# Vérifier que cAdvisor est accessible
echo "🔍 Vérification de cAdvisor..."
if ! curl -s http://localhost:8080/metrics > /dev/null 2>&1; then
    echo "❌ cAdvisor n'est pas accessible sur http://localhost:8080"
    echo "   Veuillez démarrer cAdvisor avec: docker-compose -f monitoring/docker-compose-grafana-non-optimized.yml up -d"
    exit 1
fi

echo "✅ cAdvisor est accessible"
echo ""

# Vérifier que Prometheus est accessible
echo "🔍 Vérification de Prometheus..."
if ! curl -s http://localhost:9090/api/v1/query?query=up > /dev/null 2>&1; then
    echo "❌ Prometheus n'est pas accessible sur http://localhost:9090"
    echo "   Veuillez démarrer Prometheus avec: docker-compose -f monitoring/docker-compose-grafana-non-optimized.yml up -d"
    exit 1
fi

echo "✅ Prometheus est accessible"
echo ""

# Importer le dashboard
echo "📥 Import du dashboard 'DevOps Project - Monitoring Final (Live Docker Metrics)'..."

# Créer le dashboard via l'API Grafana
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic YWRtaW46YWRtaW4xMjM=" \
  -d @monitoring/grafana/dashboards/devops-containers-live-docker.json \
  http://localhost:3000/api/dashboards/db \
  > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Dashboard importé avec succès !"
else
    echo "⚠️  Le dashboard existe peut-être déjà, tentative de mise à jour..."
    
    # Essayer de mettre à jour le dashboard existant
    curl -X PUT \
      -H "Content-Type: application/json" \
      -H "Authorization: Basic YWRtaW46YWRtaW4xMjM=" \
      -d @monitoring/grafana/dashboards/devops-containers-live-docker.json \
      http://localhost:3000/api/dashboards/db \
      > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "✅ Dashboard mis à jour avec succès !"
    else
        echo "❌ Erreur lors de l'import/mise à jour du dashboard"
        exit 1
    fi
fi

echo ""
echo "🎯 Dashboard disponible dans Grafana:"
echo "   - Nom: 'DevOps Project - Monitoring Final (Live Docker Metrics)'"
echo "   - URL: http://localhost:3000/d/devops-containers-live-docker"
echo "   - Fonctionnalités:"
echo "     • Connexion directe aux métriques Docker"
echo "     • Rafraîchissement automatique toutes les 2 secondes"
echo "     • Métriques en temps réel qui évoluent"
echo "     • Pas de valeurs statiques"
echo "     • Couleurs distinctes pour chaque conteneur"
echo "     • Graphiques CPU et Memory en temps réel"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard Live Docker Metrics importé et ouvert !"
echo "   - Connexion directe aux métriques Docker"
echo "   - Rafraîchissement automatique toutes les 2 secondes"
echo "   - Métriques qui évoluent en temps réel"
echo "   - Pas de valeurs statiques"
echo "   - Graphiques avec couleurs distinctes pour chaque conteneur"
