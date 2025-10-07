#!/bin/bash

echo "📊 Import du dashboard DevOps dans Grafana..."
echo "============================================="

# Attendre que Grafana soit prêt
echo "⏳ Attente que Grafana soit prêt..."
until curl -s http://localhost:3000/api/health > /dev/null; do
    echo "   En attente de Grafana..."
    sleep 2
done
echo "✅ Grafana est prêt!"

# Créer le dossier DevOps Project s'il n'existe pas
echo "📁 Création du dossier DevOps Project..."
curl -X POST \
  -H "Content-Type: application/json" \
  -u admin:admin123 \
  -d '{"title": "DevOps Project"}' \
  http://localhost:3000/api/folders 2>/dev/null || echo "   Dossier déjà existant"

# Importer le dashboard
echo "📈 Import du dashboard DevOps Project - Conteneurs Non-Optimisés (Live)..."

# Lire le contenu du dashboard
DASHBOARD_JSON=$(cat monitoring/grafana/dashboards/devops-containers-live.json)

# Importer le dashboard
RESPONSE=$(curl -X POST \
  -H "Content-Type: application/json" \
  -u admin:admin123 \
  -d "$DASHBOARD_JSON" \
  http://localhost:3000/api/dashboards/db 2>/dev/null)

if echo "$RESPONSE" | grep -q '"status":"success"'; then
    echo "✅ Dashboard importé avec succès!"
    echo ""
    echo "🌐 Accès au dashboard:"
    echo "   URL: http://localhost:3000"
    echo "   Username: admin"
    echo "   Password: admin123"
    echo ""
    echo "📋 Dashboard disponible dans: Dashboards > DevOps Project"
    echo "   Nom: 'DevOps Project - Conteneurs Non-Optimisés (Live)'"
    echo ""
    echo "🎯 Métriques surveillées:"
    echo "   - CPU Usage des conteneurs DevOps"
    echo "   - Memory Usage des conteneurs DevOps"
    echo "   - Network I/O des conteneurs DevOps"
    echo "   - Résumé global du projet"
    echo "   - État des conteneurs en temps réel"
else
    echo "❌ Erreur lors de l'import du dashboard"
    echo "Réponse: $RESPONSE"
fi

echo ""
echo "🔄 Redémarrage de Grafana pour appliquer les changements..."
docker restart grafana-non-optimized
echo "✅ Configuration terminée!"
