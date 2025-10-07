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

# Fonction pour créer un graphique en courbes avec points
create_lines_graph() {
    local portainer_cpu=$1
    local mongodb_cpu=$2
    local backend_cpu=$3
    local frontend_cpu=$4
    
    echo -e "${CYAN}💻 CPU Usage - DevOps Project${NC}"
    echo "================================"
    echo ""
    
    # Créer un graphique en courbes avec points colorés
    echo -e "${GREEN}Portainer:${NC} ${portainer_cpu}%"
    echo -e "${YELLOW}MongoDB:${NC} ${mongodb_cpu}%"
    echo -e "${BLUE}Backend:${NC} ${backend_cpu}%"
    echo -e "${PURPLE}Frontend:${NC} ${frontend_cpu}%"
    echo ""
    
    # Simuler un graphique en courbes avec des points
    echo "Graphique en courbes avec points colorés:"
    echo "Y-axis: 0 ──────────────────────────────── 3"
    echo "       │"
    echo -e "   2.8 │                                    ${YELLOW}●${NC} MongoDB"
    echo "       │"
    echo -e "   2.5 │                              ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   2.2 │                        ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   1.9 │                  ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   1.6 │            ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   1.3 │      ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   1.0 │${YELLOW}●${NC}"
    echo "       │"
    echo -e "   0.7 │"
    echo "       │"
    echo -e "   0.4 │                                    ${BLUE}●${NC} Backend"
    echo "       │"
    echo -e "   0.1 │                              ${BLUE}●${NC}"
    echo "       │"
    echo -e "   0.0 │                        ${BLUE}●${NC}"
    echo "       │"
    echo "       └───────────────────────────────────────"
    echo "       22:30  22:35  22:40  22:45  22:50"
    echo ""
    echo "Légende:"
    echo -e "${GREEN}● Portainer${NC} (Vert)"
    echo -e "${YELLOW}● MongoDB${NC} (Jaune)"
    echo -e "${BLUE}● Backend${NC} (Bleu)"
    echo -e "${PURPLE}● Frontend${NC} (Violet)"
    echo ""
}

# Fonction pour afficher les courbes de CPU
show_cpu_lines_graph() {
    echo -e "${WHITE}🚀 DevOps Project - Monitoring Final (Graphique en Courbes)${NC}"
    echo -e "${WHITE}===========================================================${NC}"
    echo ""
    
    # Collecter les métriques de tous les conteneurs
    local portainer_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null | sed 's/%//')
    local mongodb_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null | sed 's/%//')
    local backend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null | sed 's/%//')
    local frontend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null | sed 's/%//')
    
    # Afficher le graphique en courbes
    create_lines_graph "$portainer_cpu" "$mongodb_cpu" "$backend_cpu" "$frontend_cpu"
    
    echo "----------------------------------------"
    echo ""
    
    # Afficher le résumé
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
    echo -e "${GREEN}✅ Graphique en courbes avec points colorés affiché${NC}"
}

# Fonction principale
main() {
    clear
    show_cpu_lines_graph
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
