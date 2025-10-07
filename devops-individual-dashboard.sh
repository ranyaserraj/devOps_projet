#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Fonction pour créer un graphique ASCII
create_ascii_chart() {
    local value=$1
    local max=100
    local width=50
    local filled=$((value * width / max))
    local chart=""
    
    for i in $(seq 1 $width); do
        if [ $i -le $filled ]; then
            chart="${chart}█"
        else
            chart="${chart}░"
        fi
    done
    
    echo "$chart"
}

# Fonction pour afficher les métriques d'un conteneur
show_container_metrics() {
    local container_name=$1
    local display_name=$2
    local color=$3
    
    echo -e "${color}📊 $display_name${NC}"
    echo "============================="
    
    # Obtenir les métriques avec Docker Stats
    local stats=$(docker stats --no-stream --format "{{.CPUPerc}},{{.MemUsage}},{{.NetIO}},{{.BlockIO}}" $container_name 2>/dev/null)
    
    if [ -n "$stats" ]; then
        local cpu_perc=$(echo $stats | cut -d',' -f1 | sed 's/%//')
        local mem_usage=$(echo $stats | cut -d',' -f2)
        local net_io=$(echo $stats | cut -d',' -f3)
        local block_io=$(echo $stats | cut -d',' -f4)
        local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
        
        # CPU Usage
        echo -e "💻 CPU Usage: ${YELLOW}${cpu_perc}%${NC}"
        local cpu_chart=$(create_ascii_chart ${cpu_perc%.*})
        echo -e "   [${cpu_chart}]"
        echo ""
        
        # Memory Usage
        echo -e "🧠 Memory Usage: ${BLUE}${mem_usage}${NC}"
        echo ""
        
        # Network I/O
        echo -e "🌐 Network I/O: ${PURPLE}${net_io}${NC}"
        echo ""
        
        # Block I/O
        echo -e "💾 Block I/O: ${CYAN}${block_io}${NC}"
        echo ""
        
        # Status
        echo -e "📋 Status: ${GREEN}${status}${NC}"
        echo ""
        
        echo "----------------------------------------"
        echo ""
    else
        echo -e "   ❌ Conteneur non trouvé"
        echo ""
    fi
}

# Fonction principale
main() {
    clear
    echo -e "${WHITE}🚀 DevOps Project - Monitoring Final${NC}"
    echo -e "${WHITE}====================================${NC}"
    echo ""
    
    # Afficher chaque conteneur individuellement
    show_container_metrics "idurar-portainer" "Portainer" "${GREEN}"
    show_container_metrics "idurar-mongodb" "MongoDB" "${YELLOW}"
    show_container_metrics "idurar-backend" "Backend" "${BLUE}"
    show_container_metrics "idurar-frontend" "Frontend" "${PURPLE}"
    
    echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
    echo "========================"
    echo -e "${WHITE}📊 Grafana:${NC} http://localhost:3000 (admin/admin123)"
    echo -e "${WHITE}📈 Prometheus:${NC} http://localhost:9090"
    echo -e "${WHITE}🔍 cAdvisor:${NC} http://localhost:8080"
    echo ""
    echo -e "${GREEN}✅ Chaque conteneur affiché individuellement avec ses propres métriques${NC}"
}

# Boucle de surveillance continue
if [ "$1" = "--continuous" ]; then
    while true; do
        main
        echo -e "${YELLOW}⏳ Prochaine mise à jour dans 5 secondes...${NC}"
        echo -e "${WHITE}   (Appuyez sur Ctrl+C pour arrêter)${NC}"
        sleep 5
    done
else
    main
fi