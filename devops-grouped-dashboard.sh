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

# Fonction pour afficher les métriques groupées
show_grouped_metrics() {
    echo -e "${WHITE}🚀 DevOps Project - Monitoring Final (Métriques Groupées)${NC}"
    echo -e "${WHITE}=======================================================${NC}"
    echo ""
    
    # Collecter les métriques de tous les conteneurs
    local portainer_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null | sed 's/%//')
    local portainer_mem=$(docker stats --no-stream --format "{{.MemUsage}}" idurar-portainer 2>/dev/null | cut -d'/' -f1 | sed 's/MiB//' | sed 's/ //' | cut -d'.' -f1)
    
    local mongodb_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null | sed 's/%//')
    local mongodb_mem=$(docker stats --no-stream --format "{{.MemUsage}}" idurar-mongodb 2>/dev/null | cut -d'/' -f1 | sed 's/MiB//' | sed 's/ //' | cut -d'.' -f1)
    
    local backend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null | sed 's/%//')
    local backend_mem=$(docker stats --no-stream --format "{{.MemUsage}}" idurar-backend 2>/dev/null | cut -d'/' -f1 | sed 's/MiB//' | sed 's/ //' | cut -d'.' -f1)
    
    local frontend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null | sed 's/%//')
    local frontend_mem=$(docker stats --no-stream --format "{{.MemUsage}}" idurar-frontend 2>/dev/null | cut -d'/' -f1 | sed 's/MiB//' | sed 's/ //' | cut -d'.' -f1)
    
    # Afficher le graphique CPU groupé
    echo -e "${CYAN}💻 CPU Usage - DevOps Project${NC}"
    echo "================================"
    echo -e "${GREEN}Portainer:${NC} ${portainer_cpu}%"
    local portainer_cpu_chart=$(create_ascii_chart ${portainer_cpu%.*})
    echo -e "   [${portainer_cpu_chart}]"
    echo ""
    
    echo -e "${YELLOW}MongoDB:${NC} ${mongodb_cpu}%"
    local mongodb_cpu_chart=$(create_ascii_chart ${mongodb_cpu%.*})
    echo -e "   [${mongodb_cpu_chart}]"
    echo ""
    
    echo -e "${BLUE}Backend:${NC} ${backend_cpu}%"
    local backend_cpu_chart=$(create_ascii_chart ${backend_cpu%.*})
    echo -e "   [${backend_cpu_chart}]"
    echo ""
    
    echo -e "${PURPLE}Frontend:${NC} ${frontend_cpu}%"
    local frontend_cpu_chart=$(create_ascii_chart ${frontend_cpu%.*})
    echo -e "   [${frontend_cpu_chart}]"
    echo ""
    
    echo "----------------------------------------"
    echo ""
    
    # Afficher le graphique Memory groupé
    echo -e "${CYAN}🧠 Memory Usage - DevOps Project${NC}"
    echo "=================================="
    echo -e "${GREEN}Portainer:${NC} ${portainer_mem}MiB"
    local portainer_mem_chart=$(create_ascii_chart $portainer_mem)
    echo -e "   [${portainer_mem_chart}]"
    echo ""
    
    echo -e "${YELLOW}MongoDB:${NC} ${mongodb_mem}MiB"
    local mongodb_mem_chart=$(create_ascii_chart $mongodb_mem)
    echo -e "   [${mongodb_mem_chart}]"
    echo ""
    
    echo -e "${BLUE}Backend:${NC} ${backend_mem}MiB"
    local backend_mem_chart=$(create_ascii_chart $backend_mem)
    echo -e "   [${backend_mem_chart}]"
    echo ""
    
    echo -e "${PURPLE}Frontend:${NC} ${frontend_mem}MiB"
    local frontend_mem_chart=$(create_ascii_chart $frontend_mem)
    echo -e "   [${frontend_mem_chart}]"
    echo ""
    
    echo "----------------------------------------"
    echo ""
    
    # Afficher la consommation CPU séparée pour chaque conteneur
    echo -e "${CYAN}📊 DevOps Project Summary${NC}"
    echo "=========================="
    echo -e "${GREEN}Portainer CPU %:${NC} ${portainer_cpu}%"
    echo -e "${YELLOW}MongoDB CPU %:${NC} ${mongodb_cpu}%"
    echo -e "${BLUE}Backend CPU %:${NC} ${backend_cpu}%"
    echo -e "${PURPLE}Frontend CPU %:${NC} ${frontend_cpu}%"
    echo ""
    
    echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
    echo "========================"
    echo -e "${WHITE}📊 Grafana:${NC} http://localhost:3000 (admin/admin123)"
    echo -e "${WHITE}📈 Prometheus:${NC} http://localhost:9090"
    echo -e "${WHITE}🔍 cAdvisor:${NC} http://localhost:8080"
    echo ""
    echo -e "${GREEN}✅ Métriques groupées avec couleurs distinctes affichées${NC}"
}

# Fonction principale
main() {
    clear
    show_grouped_metrics
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
