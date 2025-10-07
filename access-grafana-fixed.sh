#!/bin/bash

echo "🚀 Accès à Grafana - DevOps Project (Corrigé)"
echo "============================================="
echo ""
echo "📊 Grafana Dashboard:"
echo "   URL: http://localhost:3000"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
echo "📈 Prometheus:"
echo "   URL: http://localhost:9090"
echo ""
echo "🔍 cAdvisor (métriques conteneurs):"
echo "   URL: http://localhost:8080"
echo ""
echo "📋 Conteneurs DevOps surveillés:"
echo "   - idurar-frontend (Port 3002)"
echo "   - idurar-backend (Port 5001)"
echo "   - idurar-mongodb (Port 27017)"
echo "   - idurar-portainer (Port 9000)"
echo ""
echo "🎯 Dashboards disponibles:"
echo "   1. 'DevOps Project - Métriques Système' (Recommandé)"
echo "   2. 'DevOps Project - Conteneurs Non-Optimisés (Live)'"
echo ""
echo "💡 Pour accéder aux métriques:"
echo "   1. Ouvrir Grafana: http://localhost:3000"
echo "   2. Se connecter avec admin/admin123"
echo "   3. Aller dans 'Dashboards' > 'DevOps Project'"
echo "   4. Sélectionner 'DevOps Project - Métriques Système'"
echo ""
echo "🔄 Vérification des services..."
echo ""

# Vérifier que les services sont en cours d'exécution
echo "📊 État des services de monitoring:"
docker ps --filter "name=non-optimized" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Vérifier que les conteneurs DevOps sont en cours d'exécution
echo "📋 État des conteneurs DevOps:"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher les métriques rapides
echo "📊 Métriques rapides des conteneurs DevOps:"
echo "=========================================="
echo ""

# Fonction pour afficher les métriques d'un conteneur
show_quick_metrics() {
    local container_name=$1
    local cpu_usage=$(docker stats --no-stream --format "table {{.CPUPerc}}" $container_name 2>/dev/null | tail -1 | sed 's/%//')
    local mem_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" $container_name 2>/dev/null | tail -1)
    local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
    
    if [ -n "$status" ]; then
        echo "📊 $container_name:"
        echo "   💻 CPU: ${cpu_usage}%"
        echo "   🧠 Memory: $mem_usage"
        echo "   📋 Status: $status"
        echo ""
    else
        echo "❌ $container_name: Conteneur non trouvé"
        echo ""
    fi
}

show_quick_metrics "idurar-frontend"
show_quick_metrics "idurar-backend"
show_quick_metrics "idurar-mongodb"
show_quick_metrics "idurar-portainer"

echo "🌐 Ouverture de Grafana dans le navigateur..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"
echo ""
echo "✅ Configuration terminée !"
echo "   - Grafana est accessible sur http://localhost:3000"
echo "   - Utilisez le dashboard 'DevOps Project - Métriques Système'"
echo "   - Les métriques se mettent à jour automatiquement"
