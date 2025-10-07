#!/bin/bash

echo "🚀 DevOps Project - Monitoring Final (Temps Réel)"
echo "================================================"
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo "📊 Vérification des conteneurs DevOps:"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher les métriques en temps réel de chaque conteneur
echo "📈 Métriques en temps réel des conteneurs:"
echo "=========================================="

# Fonction pour afficher les métriques d'un conteneur
show_realtime_metrics() {
    local container_name=$1
    local display_name=$2
    local cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" $container_name 2>/dev/null | sed 's/%//')
    local mem_usage=$(docker stats --no-stream --format "{{.MemUsage}}" $container_name 2>/dev/null)
    local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
    
    if [ -n "$status" ]; then
        echo "📊 $display_name:"
        echo "   💻 CPU: ${cpu_usage}%"
        echo "   🧠 Memory: $mem_usage"
        echo "   📋 Status: $status"
        echo ""
    else
        echo "❌ $display_name: Conteneur non trouvé"
        echo ""
    fi
}

show_realtime_metrics "idurar-portainer" "Portainer"
show_realtime_metrics "idurar-mongodb" "MongoDB"
show_realtime_metrics "idurar-backend" "Backend"
show_realtime_metrics "idurar-frontend" "Frontend"

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""

echo "🎯 Dashboards disponibles:"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final' (Temps Réel)"
echo "2. 'DevOps Project - Métriques Système'"
echo "3. 'DevOps Project - Conteneurs Non-Optimisés (Live)'"
echo ""

echo "💡 Pour une surveillance continue en temps réel:"
echo "   ./devops-real-time-dashboard.sh --continuous"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard temps réel ouvert !"
echo "   - Graphiques CPU et mémoire en temps réel"
echo "   - Métriques de chaque conteneur individuellement"
echo "   - Résumé avec valeurs actuelles"
echo "   - Rafraîchissement automatique toutes les 5 secondes"
