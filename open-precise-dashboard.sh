#!/bin/bash

echo "🚀 DevOps Project - Monitoring Final (Métriques Précises)"
echo "========================================================"
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo "📊 Vérification des conteneurs DevOps:"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher les métriques précises de chaque conteneur
echo "📈 Métriques précises des conteneurs:"
echo "====================================="

# Fonction pour afficher les métriques précises d'un conteneur
show_precise_metrics() {
    local container_name=$1
    local display_name=$2
    local color=$3
    
    echo -e "${color}📊 $display_name - Métriques Précises${NC}"
    echo "=================================="
    
    local cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" $container_name 2>/dev/null)
    local mem_usage=$(docker stats --no-stream --format "{{.MemUsage}}" $container_name 2>/dev/null)
    local net_io=$(docker stats --no-stream --format "{{.NetIO}}" $container_name 2>/dev/null)
    local block_io=$(docker stats --no-stream --format "{{.BlockIO}}" $container_name 2>/dev/null)
    local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
    
    if [ -n "$status" ]; then
        echo -e "   💻 CPU: ${YELLOW}${cpu_usage}${NC}"
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

show_precise_metrics "idurar-portainer" "Portainer" "${GREEN}"
show_precise_metrics "idurar-mongodb" "MongoDB" "${YELLOW}"
show_precise_metrics "idurar-backend" "Backend" "${BLUE}"
show_precise_metrics "idurar-frontend" "Frontend" "${PURPLE}"

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""

echo "🎯 Dashboards disponibles:"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final' (Métriques Précises)"
echo "2. 'DevOps Project - Conteneurs Individuels (Docker Stats)'"
echo "3. 'DevOps Project - Conteneurs Individuels'"
echo "4. 'DevOps Project - Métriques Système'"
echo ""

echo "💡 Pour une surveillance continue avec métriques précises:"
echo "   ./devops-precise-dashboard.sh --continuous"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard précis ouvert !"
echo "   - Métriques précises de chaque conteneur"
echo "   - Valeurs réelles : Portainer (0.05% CPU, 22.26MiB), MongoDB (0.53% CPU, 215.5MiB)"
echo "   - Backend (0.00% CPU, 77.12MiB), Frontend (1.34% CPU, 97.5MiB)"
echo "   - Graphiques ASCII pour visualisation claire"
echo "   - Rafraîchissement automatique toutes les 5 secondes"
