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

# Fonction pour afficher les métriques d'un conteneur
get_container_metrics() {
    local container_name=$1
    local container_id=$(docker ps --filter "name=$container_name" --format "{{.ID}}" | head -1)
    
    if [ -z "$container_id" ]; then
        echo "❌ $container_name: Non trouvé"
        return
    fi
    
    # Obtenir les métriques
    local stats=$(docker stats --no-stream --format "table {{.CPUPerc}},{{.MemUsage}},{{.NetIO}},{{.BlockIO}}" $container_name | tail -1)
    local cpu_perc=$(echo $stats | cut -d',' -f1 | sed 's/%//')
    local mem_usage=$(echo $stats | cut -d',' -f2)
    local net_io=$(echo $stats | cut -d',' -f3)
    local block_io=$(echo $stats | cut -d',' -f4)
    
    # Afficher les métriques avec des couleurs
    echo -e "${GREEN}📊 $container_name:${NC}"
    echo -e "   💻 CPU: ${YELLOW}${cpu_perc}%${NC}"
    echo -e "   🧠 Memory: ${BLUE}${mem_usage}${NC}"
    echo -e "   🌐 Network: ${PURPLE}${net_io}${NC}"
    echo -e "   💾 Block I/O: ${CYAN}${block_io}${NC}"
    echo ""
}

# Fonction pour créer un graphique ASCII simple
create_ascii_chart() {
    local cpu_value=$1
    local container_name=$2
    
    # Convertir le pourcentage en barres
    local bars=$((cpu_value / 2))
    local chart=""
    
    for i in $(seq 1 50); do
        if [ $i -le $bars ]; then
            chart="${chart}█"
        else
            chart="${chart}░"
        fi
    done
    
    echo -e "${GREEN}$container_name CPU:${NC} ${YELLOW}${cpu_value}%${NC} [${chart}]"
}

# Fonction principale
main() {
    clear
    echo -e "${WHITE}🚀 DevOps Project - Monitoring Final${NC}"
    echo -e "${WHITE}=====================================${NC}"
    echo ""
    
    # Vérifier que les conteneurs sont en cours d'exécution
    echo -e "${CYAN}📋 Conteneurs DevOps surveillés:${NC}"
    echo "================================"
    
    # Afficher les métriques de chaque conteneur
    get_container_metrics "idurar-frontend"
    get_container_metrics "idurar-backend"
    get_container_metrics "idurar-mongodb"
    get_container_metrics "idurar-portainer"
    
    # Créer des graphiques ASCII
    echo -e "${CYAN}📊 Graphiques CPU en temps réel:${NC}"
    echo "================================"
    
    # Obtenir les valeurs CPU pour les graphiques
    local frontend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null | sed 's/%//' | cut -d'.' -f1)
    local backend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null | sed 's/%//' | cut -d'.' -f1)
    local mongodb_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null | sed 's/%//' | cut -d'.' -f1)
    local portainer_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null | sed 's/%//' | cut -d'.' -f1)
    
    # Afficher les graphiques
    create_ascii_chart "${frontend_cpu:-0}" "Frontend"
    create_ascii_chart "${backend_cpu:-0}" "Backend"
    create_ascii_chart "${mongodb_cpu:-0}" "MongoDB"
    create_ascii_chart "${portainer_cpu:-0}" "Portainer"
    
    echo ""
    echo -e "${CYAN}📈 Résumé DevOps Project:${NC}"
    echo "========================"
    echo -e "${GREEN}Frontend CPU:${NC} ${YELLOW}${frontend_cpu:-0}%${NC}"
    echo -e "${GREEN}Backend CPU:${NC} ${YELLOW}${backend_cpu:-0}%${NC}"
    echo -e "${GREEN}MongoDB CPU:${NC} ${YELLOW}${mongodb_cpu:-0}%${NC}"
    echo -e "${GREEN}Portainer CPU:${NC} ${YELLOW}${portainer_cpu:-0}%${NC}"
    
    echo ""
    echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
    echo "========================"
    echo -e "${WHITE}📊 Grafana:${NC} http://localhost:3000 (admin/admin123)"
    echo -e "${WHITE}📈 Prometheus:${NC} http://localhost:9090"
    echo -e "${WHITE}🔍 cAdvisor:${NC} http://localhost:8080"
    echo ""
    echo -e "${YELLOW}💡 Pour une surveillance continue, utilisez:${NC}"
    echo -e "${WHITE}   ./devops-dashboard-live.sh${NC}"
    echo ""
    echo -e "${GREEN}✅ Monitoring actif - Rafraîchissement automatique${NC}"
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
