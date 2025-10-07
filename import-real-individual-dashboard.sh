#!/bin/bash

echo "📊 Import du dashboard Grafana avec vraies valeurs individuelles"
echo "=============================================================="
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

# Importer le dashboard
echo "📥 Import du dashboard 'DevOps Project - Monitoring Final (Vraies Valeurs Individuelles)'..."

# Créer le dashboard via l'API Grafana
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic YWRtaW46YWRtaW4xMjM=" \
  -d @monitoring/grafana/dashboards/devops-containers-real-individual.json \
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
      -d @monitoring/grafana/dashboards/devops-containers-real-individual.json \
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
echo "   - Nom: 'DevOps Project - Monitoring Final (Vraies Valeurs Individuelles)'"
echo "   - URL: http://localhost:3000/d/devops-containers-real-individual"
echo "   - Fonctionnalités:"
echo "     • Vraies métriques individuelles de chaque conteneur"
echo "     • Pas de valeurs identiques (8.1684%)"
echo "     • Métriques qui changent en temps réel"
echo "     • Couleurs distinctes pour chaque conteneur"
echo "     • Graphiques CPU et Memory séparés"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard avec vraies valeurs individuelles importé et ouvert !"
echo "   - Chaque conteneur a ses propres métriques qui changent en temps réel"
echo "   - Plus de valeurs identiques (8.1684%) qui ne changent pas"
echo "   - Utilisation directe de Docker Stats pour des métriques réelles"
echo "   - Graphiques avec couleurs distinctes pour chaque conteneur"
