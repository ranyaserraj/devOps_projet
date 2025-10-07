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

# Fonction pour afficher les métriques d'un conteneur séparément
show_container_separate() {
    local container_name=$1
    local display_name=$2
    local color=$3
    
    echo -e "${color}📊 $display_name - Métriques Séparées${NC}"
    echo "================================="
    
    # Obtenir les métriques
    local stats=$(docker stats --no-stream --format "table {{.CPUPerc}},{{.MemUsage}},{{.NetIO}},{{.BlockIO}}" $container_name 2>/dev/null | tail -1)
    local cpu_perc=$(echo $stats | cut -d',' -f1 | sed 's/%//')
    local mem_usage=$(echo $stats | cut -d',' -f2)
    local net_io=$(echo $stats | cut -d',' -f3)
    local block_io=$(echo $stats | cut -d',' -f4)
    local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
    
    if [ -n "$status" ]; then
        echo -e "   💻 CPU: ${YELLOW}${cpu_perc}%${NC}"
        echo -e "   🧠 Memory: ${BLUE}${mem_usage}${NC}"
        echo -e "   🌐 Network: ${PURPLE}${net_io}${NC}"
        echo -e "   💾 Block I/O: ${CYAN}${block_io}${NC}"
        echo -e "   📋 Status: ${GREEN}${status}${NC}"
        
        # Créer un graphique ASCII pour ce conteneur
        local cpu_value=$(echo $cpu_perc | cut -d'.' -f1)
        local chart=""
        local bars=$((cpu_value / 2))
        
        for i in $(seq 1 50); do
            if [ $i -le $bars ]; then
                chart="${chart}█"
            else
                chart="${chart}░"
            fi
        done
        
        echo -e "   📈 CPU Chart: [${chart}]"
        echo ""
    else
        echo -e "   ❌ Conteneur non trouvé"
        echo ""
    fi
}

# Fonction principale
main() {
    clear
    echo -e "${WHITE}🚀 DevOps Project - Monitoring Final (Séparé)${NC}"
    echo -e "${WHITE}============================================${NC}"
    echo ""
    
    # Afficher chaque conteneur séparément
    show_container_separate "idurar-portainer" "Portainer" "${GREEN}"
    show_container_separate "idurar-mongodb" "MongoDB" "${YELLOW}"
    show_container_separate "idurar-backend" "Backend" "${BLUE}"
    show_container_separate "idurar-frontend" "Frontend" "${PURPLE}"
    
    echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
    echo "========================"
    echo -e "${WHITE}📊 Grafana:${NC} http://localhost:3000 (admin/admin123)"
    echo -e "${WHITE}📈 Prometheus:${NC} http://localhost:9090"
    echo -e "${WHITE}🔍 cAdvisor:${NC} http://localhost:8080"
    echo ""
    echo -e "${YELLOW}💡 Pour une surveillance continue séparée, utilisez:${NC}"
    echo -e "${WHITE}   ./devops-separate-dashboard.sh --continuous${NC}"
    echo ""
    echo -e "${GREEN}✅ Monitoring séparé actif - Chaque conteneur affiché individuellement${NC}"
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
