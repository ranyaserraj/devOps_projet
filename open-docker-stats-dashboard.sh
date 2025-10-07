#!/bin/bash

echo "🚀 DevOps Project - Monitoring Final (Docker Stats)"
echo "================================================="
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo "📊 Vérification des conteneurs DevOps:"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher les métriques Docker Stats de chaque conteneur
echo "📈 Métriques Docker Stats des conteneurs:"
echo "========================================="

# Fonction pour afficher les métriques d'un conteneur avec Docker Stats
show_docker_stats_metrics() {
    local container_name=$1
    local display_name=$2
    local color=$3
    
    echo -e "${color}📊 $display_name - Docker Stats${NC}"
    echo "============================="
    
    local cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" $container_name 2>/dev/null | sed 's/%//')
    local mem_usage=$(docker stats --no-stream --format "{{.MemUsage}}" $container_name 2>/dev/null)
    local net_io=$(docker stats --no-stream --format "{{.NetIO}}" $container_name 2>/dev/null)
    local block_io=$(docker stats --no-stream --format "{{.BlockIO}}" $container_name 2>/dev/null)
    local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
    
    if [ -n "$status" ]; then
        echo -e "   💻 CPU: ${YELLOW}${cpu_usage}%${NC}"
        echo -e "   🧠 Memory: ${BLUE}${mem_usage}${NC}"
        echo -e "   🌐 Network: ${PURPLE}${net_io}${NC}"
        echo -e "   💾 Block I/O: ${CYAN}${block_io}${NC}"
        echo -e "   📋 Status: ${GREEN}${status}${NC}"
        echo ""
    else
        echo -e "   ❌ Conteneur non trouvé"
        echo ""
    fi
}

show_docker_stats_metrics "idurar-portainer" "Portainer" "${GREEN}"
show_docker_stats_metrics "idurar-mongodb" "MongoDB" "${YELLOW}"
show_docker_stats_metrics "idurar-backend" "Backend" "${BLUE}"
show_docker_stats_metrics "idurar-frontend" "Frontend" "${PURPLE}"

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""

echo "🎯 Dashboards disponibles:"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final' (Docker Stats)"
echo "2. 'DevOps Project - Métriques Système'"
echo "3. 'DevOps Project - Conteneurs Non-Optimisés (Live)'"
echo ""

echo "💡 Pour une surveillance continue avec Docker Stats:"
echo "   ./devops-docker-stats-dashboard.sh --continuous"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard Docker Stats ouvert !"
echo "   - Chaque conteneur affiché individuellement"
echo "   - Métriques séparées pour Frontend, Backend, MongoDB, Portainer"
echo "   - Graphiques individuels pour CPU et mémoire"
echo "   - Rafraîchissement automatique toutes les 5 secondes"
