#!/bin/bash

echo "🚀 Métriques des Conteneurs DevOps Project"
echo "========================================="
echo ""

# Fonction pour afficher les métriques d'un conteneur
show_container_metrics() {
    local container_name=$1
    local container_id=$(docker ps --filter "name=$container_name" --format "{{.ID}}" | head -1)
    
    if [ -z "$container_id" ]; then
        echo "❌ Conteneur $container_name non trouvé"
        return
    fi
    
    echo "📊 Métriques pour $container_name:"
    
    # CPU Usage
    local cpu_usage=$(docker stats --no-stream --format "table {{.CPUPerc}}" $container_name | tail -1 | sed 's/%//')
    echo "   💻 CPU: ${cpu_usage}%"
    
    # Memory Usage
    local mem_usage=$(docker stats --no-stream --format "table {{.MemUsage}}" $container_name | tail -1)
    echo "   🧠 Memory: $mem_usage"
    
    # Network I/O
    local net_io=$(docker stats --no-stream --format "table {{.NetIO}}" $container_name | tail -1)
    echo "   🌐 Network: $net_io"
    
    # Block I/O
    local block_io=$(docker stats --no-stream --format "table {{.BlockIO}}" $container_name | tail -1)
    echo "   💾 Block I/O: $block_io"
    
    # Status
    local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}")
    echo "   📋 Status: $status"
    
    echo ""
}

# Afficher les métriques de tous les conteneurs DevOps
echo "📋 Conteneurs DevOps surveillés:"
echo "================================"

show_container_metrics "idurar-frontend"
show_container_metrics "idurar-backend"
show_container_metrics "idurar-mongodb"
show_container_metrics "idurar-portainer"

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""
echo "🎯 Dashboard recommandé: 'DevOps Project - Métriques Système'"
echo ""
echo "💡 Pour une surveillance continue:"
echo "   - Ouvrir Grafana dans votre navigateur"
echo "   - Aller dans 'Dashboards' > 'DevOps Project'"
echo "   - Sélectionner le dashboard 'DevOps Project - Métriques Système'"
echo "   - Les métriques se mettent à jour automatiquement toutes les 5 secondes"
echo ""
echo "🔄 Rafraîchissement automatique en cours..."
echo "   (Appuyez sur Ctrl+C pour arrêter)"
echo ""

# Boucle de surveillance continue
while true; do
    clear
    echo "🚀 Métriques DevOps Project - $(date)"
    echo "====================================="
    echo ""
    
    show_container_metrics "idurar-frontend"
    show_container_metrics "idurar-backend"
    show_container_metrics "idurar-mongodb"
    show_container_metrics "idurar-portainer"
    
    echo "⏰ Prochaine mise à jour dans 10 secondes..."
    echo "   (Appuyez sur Ctrl+C pour arrêter)"
    sleep 10
done
