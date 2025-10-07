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

# Fonction pour nettoyer l'écran
clear_screen() {
    clear
    echo -e "${CYAN}🚀 DevOps Project - Live Docker Monitoring${NC}"
    echo "=============================================="
    echo ""
}

# Fonction pour afficher les métriques en temps réel
show_live_metrics() {
    local timestamp=$(date '+%H:%M:%S')
    
    echo -e "${CYAN}📊 Live Docker Metrics - ${timestamp}${NC}"
    echo "=========================================="
    echo ""
    
    # Récupérer les métriques de chaque conteneur
    local containers=("idurar-portainer" "idurar-mongodb" "idurar-backend" "idurar-frontend")
    local colors=("$GREEN" "$YELLOW" "$BLUE" "$PURPLE")
    local labels=("Portainer" "MongoDB" "Backend" "Frontend")
    
    for i in "${!containers[@]}"; do
        local container="${containers[$i]}"
        local color="${colors[$i]}"
        local label="${labels[$i]}"
        
        # Vérifier si le conteneur existe et est en cours d'exécution
        if docker ps --filter "name=$container" --format "{{.Names}}" | grep -q "$container"; then
            # Récupérer les métriques en temps réel
            local stats=$(docker stats --no-stream --format "{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" $container 2>/dev/null)
            
            if [ -n "$stats" ]; then
                local cpu=$(echo $stats | awk '{print $1}')
                local mem=$(echo $stats | awk '{print $2}')
                local net=$(echo $stats | awk '{print $3}')
                local block=$(echo $stats | awk '{print $4}')
                local status=$(docker ps --filter "name=$container" --format "{{.Status}}" 2>/dev/null)
                
                echo -e "${color}📦 ${label} (${container})${NC}"
                echo -e "   CPU: ${WHITE}${cpu}${NC}"
                echo -e "   Memory: ${WHITE}${mem}${NC}"
                echo -e "   Network: ${WHITE}${net}${NC}"
                echo -e "   Block I/O: ${WHITE}${block}${NC}"
                echo -e "   Status: ${WHITE}${status}${NC}"
                echo ""
            else
                echo -e "${RED}❌ ${label}: Impossible de récupérer les métriques${NC}"
                echo ""
            fi
        else
            echo -e "${RED}❌ ${label}: Conteneur non trouvé ou arrêté${NC}"
            echo ""
        fi
    done
    
    # Afficher le résumé
    echo -e "${CYAN}📊 Résumé des métriques en temps réel${NC}"
    echo "======================================"
    for i in "${!containers[@]}"; do
        local container="${containers[$i]}"
        local color="${colors[$i]}"
        local label="${labels[$i]}"
        
        if docker ps --filter "name=$container" --format "{{.Names}}" | grep -q "$container"; then
            local cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" $container 2>/dev/null)
            echo -e "${color}${label} CPU: ${WHITE}${cpu}${NC}"
        fi
    done
    
    echo ""
    echo -e "${CYAN}🔄 Rafraîchissement automatique toutes les 2 secondes${NC}"
    echo -e "${CYAN}💡 Appuyez sur Ctrl+C pour arrêter${NC}"
    echo ""
}

# Fonction pour surveiller en continu
monitor_continuous() {
    while true; do
        clear_screen
        show_live_metrics
        sleep 2
    done
}

# Fonction pour afficher une seule fois
monitor_once() {
    clear_screen
    show_live_metrics
}

# Vérifier les arguments
if [ "$1" = "--continuous" ] || [ "$1" = "-c" ]; then
    monitor_continuous
else
    monitor_once
fi
