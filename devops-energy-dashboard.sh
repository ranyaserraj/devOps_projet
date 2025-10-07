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

# Fonction pour calculer la consommation d'énergie (Watt)
calculate_energy_consumption() {
    local cpu_percent=$1
    local memory_mb=$2
    local container_name=$3
    
    # Conversion CPU % en consommation énergétique (Watt)
    # Base: 1% CPU = 0.8W, ajusté selon le type de conteneur
    local cpu_watt=$(echo "$cpu_percent * 0.8" | bc -l 2>/dev/null || echo "0")
    
    # Conversion mémoire en consommation énergétique (Watt)
    # Base: 1GB RAM = 0.5W
    local memory_gb=$(echo "$memory_mb / 1024" | bc -l 2>/dev/null || echo "0")
    local memory_watt=$(echo "$memory_gb * 0.5" | bc -l 2>/dev/null || echo "0")
    
    # Consommation totale
    local total_watt=$(echo "$cpu_watt + $memory_watt" | bc -l 2>/dev/null || echo "0")
    
    echo "$total_watt"
}

# Fonction pour calculer les émissions CO2 (g/h)
calculate_co2_emissions() {
    local energy_watt=$1
    
    # Facteur d'émission: 0.5g CO2 par Watt-heure
    local co2_gh=$(echo "$energy_watt * 0.5" | bc -l 2>/dev/null || echo "0")
    
    echo "$co2_gh"
}

# Fonction pour créer un graphique ASCII pour l'énergie
create_energy_chart() {
    local value=$1
    local max_chart_length=20
    local num_chars=$(echo "$value * $max_chart_length / 10" | bc -l 2>/dev/null | cut -d'.' -f1)
    local chart=""
    for ((i=0; i<num_chars; i++)); do
        chart+="█"
    done
    for ((i=num_chars; i<max_chart_length; i++)); do
        chart+=" "
    done
    echo -n "$chart"
}

# Fonction pour afficher les métriques énergétiques d'un conteneur
display_energy_metrics() {
    local container_name=$1
    local color=$2
    local label=$3
    local stats=$(docker stats --no-stream --format "{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}\t{{.Status}}" "$container_name" 2>/dev/null)

    if [ -z "$stats" ]; then
        echo -e "${color}⚡ $label${NC}"
        echo -e "   Status: ${RED}Not Running${NC}"
        echo ""
        return
    fi

    local name=$(echo "$stats" | awk '{print $1}')
    local cpu_usage=$(echo "$stats" | awk '{print $2}' | sed 's/%//')
    local mem_usage=$(echo "$stats" | awk '{print $3}' | awk -F'/' '{print $1}' | sed 's/MiB//' | sed 's/GiB//')
    local net_io=$(echo "$stats" | awk '{print $4}')
    local block_io=$(echo "$stats" | awk '{print $5}')
    local status=$(echo "$stats" | awk '{for (i=7; i<=NF; i++) printf "%s ", $i; print ""}')

    # Calculs énergétiques
    local energy_watt=$(calculate_energy_consumption "$cpu_usage" "$mem_usage" "$container_name")
    local co2_emissions=$(calculate_co2_emissions "$energy_watt")
    
    # Conversion en MiB si nécessaire
    local mem_mb=$(echo "$mem_usage" | sed 's/MiB//' | sed 's/GiB//')
    if [[ "$mem_usage" == *"GiB"* ]]; then
        mem_mb=$(echo "$mem_usage * 1024" | bc -l 2>/dev/null | cut -d'.' -f1)
    fi

    echo -e "${color}⚡ $label${NC}"
    echo -e "   CPU: ${color}${cpu_usage}%${NC}"
    echo -e "   Memory: ${color}${mem_usage}${NC}"
    echo -e "   Network: ${color}${net_io}${NC}"
    echo -e "   Block I/O: ${color}${block_io}${NC}"
    echo -e "   Status: ${color}${status}${NC}"
    echo ""
    echo -e "   ${CYAN}🔋 Energy Consumption:${NC}"
    echo -e "   ${color}$(create_energy_chart $energy_watt)${NC} ${energy_watt}W"
    echo -e "   ${CYAN}🌍 CO2 Emissions:${NC}"
    echo -e "   ${color}${co2_emissions}g/h${NC}"
    echo ""
}

# Fonction pour afficher le résumé énergétique
display_energy_summary() {
    local container_name=$1
    local color=$2
    local label=$3
    local stats=$(docker stats --no-stream --format "{{.CPUPerc}}\t{{.MemUsage}}" "$container_name" 2>/dev/null)

    if [ -z "$stats" ]; then
        echo -e "${color}${label} Energy: ${RED}Not Running${NC}"
        return
    fi

    local cpu_usage=$(echo "$stats" | awk '{print $1}' | sed 's/%//')
    local mem_usage=$(echo "$stats" | awk '{print $2}' | awk -F'/' '{print $1}' | sed 's/MiB//' | sed 's/GiB//')
    
    # Conversion en MiB si nécessaire
    local mem_mb=$(echo "$mem_usage" | sed 's/MiB//' | sed 's/GiB//')
    if [[ "$mem_usage" == *"GiB"* ]]; then
        mem_mb=$(echo "$mem_usage * 1024" | bc -l 2>/dev/null | cut -d'.' -f1)
    fi

    local energy_watt=$(calculate_energy_consumption "$cpu_usage" "$mem_mb" "$container_name")
    local co2_emissions=$(calculate_co2_emissions "$energy_watt")

    echo -e "${color}${label} Energy: ${energy_watt}W | CO2: ${co2_emissions}g/h${NC}"
}

# Boucle de surveillance continue
if [[ "$1" == "--continuous" ]]; then
    while true; do
        clear
        echo -e "${CYAN}⚡ DevOps Project - Energy Consumption & CO2 Emissions${NC}"
        echo "=================================================================="
        echo ""

        echo -e "${CYAN}🔋 Energy Consumption - DevOps Project (Real-time Calculation)${NC}"
        echo "=============================================================="
        display_energy_metrics "idurar-portainer" "${GREEN}" "Portainer"
        display_energy_metrics "idurar-mongodb" "${YELLOW}" "MongoDB"
        display_energy_metrics "idurar-backend" "${BLUE}" "Backend"
        display_energy_metrics "idurar-frontend" "${PURPLE}" "Frontend"

        echo -e "${CYAN}🌍 CO2 Emissions - DevOps Project (Real-time Calculation)${NC}"
        echo "=================================================================="
        echo -e "${GREEN}Portainer CO2:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null | sed 's/%//' | xargs -I {} echo "{} * 0.8 * 0.5" | bc -l 2>/dev/null || echo "0")g/h"
        echo -e "${YELLOW}MongoDB CO2:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null | sed 's/%//' | xargs -I {} echo "{} * 0.8 * 0.5" | bc -l 2>/dev/null || echo "0")g/h"
        echo -e "${BLUE}Backend CO2:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null | sed 's/%//' | xargs -I {} echo "{} * 0.8 * 0.5" | bc -l 2>/dev/null || echo "0")g/h"
        echo -e "${PURPLE}Frontend CO2:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null | sed 's/%//' | xargs -I {} echo "{} * 0.8 * 0.5" | bc -l 2>/dev/null || echo "0")g/h"
        echo ""

        echo -e "${CYAN}📊 DevOps Project Energy Summary (Real-time Calculation)${NC}"
        echo "=============================================="
        display_energy_summary "idurar-portainer" "${GREEN}" "Portainer"
        display_energy_summary "idurar-mongodb" "${YELLOW}" "MongoDB"
        display_energy_summary "idurar-backend" "${BLUE}" "Backend"
        display_energy_summary "idurar-frontend" "${PURPLE}" "Frontend"
        echo ""

        echo -e "${CYAN}🎯 Fonctionnalités du dashboard Energy & CO2${NC}"
        echo "======================================================"
        echo -e "✅ ${GREEN}Calcul énergétique en temps réel${NC} : Basé sur CPU et mémoire"
        echo -e "✅ ${GREEN}Calcul CO2 en temps réel${NC} : Émissions par heure"
        echo -e "✅ ${GREEN}4 conteneurs DevOps spécifiques${NC} : Portainer, MongoDB, Backend, Frontend"
        echo -e "✅ ${GREEN}Métriques individuelles${NC} : Chaque conteneur a ses propres calculs"
        echo -e "✅ ${GREEN}Graphiques ASCII énergétiques${NC} : Visualisation de la consommation"
        echo -e "✅ ${GREEN}Couleurs distinctes${NC} : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
        echo -e "✅ ${GREEN}Calculs dynamiques${NC} : Les valeurs changent en temps réel"
        echo -e "✅ ${GREEN}Pas de valeurs statiques${NC} : Calculs basés sur les métriques réelles"
        echo -e "✅ ${GREEN}Green IT${NC} : Surveillance de l'impact environnemental"

        echo ""
        echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
        echo "========================"
        echo -e "📊 Grafana: ${BLUE}http://localhost:3000${NC} (admin/admin123)"
        echo -e "📈 Prometheus: ${BLUE}http://localhost:9090${NC}"
        echo -e "🔍 cAdvisor: ${BLUE}http://localhost:8080${NC}"
        echo ""
        echo -e "${CYAN}💡 Pour une surveillance continue:${NC}"
        echo "   ./devops-energy-dashboard.sh --continuous"
        sleep 5
    done
else
    echo -e "${CYAN}⚡ DevOps Project - Energy Consumption & CO2 Emissions${NC}"
    echo "=================================================================="
    echo ""

    echo -e "${CYAN}🔋 Energy Consumption - DevOps Project (Real-time Calculation)${NC}"
    echo "=============================================================="
    display_energy_metrics "idurar-portainer" "${GREEN}" "Portainer"
    display_energy_metrics "idurar-mongodb" "${YELLOW}" "MongoDB"
    display_energy_metrics "idurar-backend" "${BLUE}" "Backend"
    display_energy_metrics "idurar-frontend" "${PURPLE}" "Frontend"

    echo -e "${CYAN}🌍 CO2 Emissions - DevOps Project (Real-time Calculation)${NC}"
    echo "=================================================================="
    echo -e "${GREEN}Portainer CO2:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null | sed 's/%//' | xargs -I {} echo "{} * 0.8 * 0.5" | bc -l 2>/dev/null || echo "0")g/h"
    echo -e "${YELLOW}MongoDB CO2:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null | sed 's/%//' | xargs -I {} echo "{} * 0.8 * 0.5" | bc -l 2>/dev/null || echo "0")g/h"
    echo -e "${BLUE}Backend CO2:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null | sed 's/%//' | xargs -I {} echo "{} * 0.8 * 0.5" | bc -l 2>/dev/null || echo "0")g/h"
    echo -e "${PURPLE}Frontend CO2:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null | sed 's/%//' | xargs -I {} echo "{} * 0.8 * 0.5" | bc -l 2>/dev/null || echo "0")g/h"
    echo ""

    echo -e "${CYAN}📊 DevOps Project Energy Summary (Real-time Calculation)${NC}"
    echo "=============================================="
    display_energy_summary "idurar-portainer" "${GREEN}" "Portainer"
    display_energy_summary "idurar-mongodb" "${YELLOW}" "MongoDB"
    display_energy_summary "idurar-backend" "${BLUE}" "Backend"
    display_energy_summary "idurar-frontend" "${PURPLE}" "Frontend"
    echo ""

    echo -e "${CYAN}🎯 Fonctionnalités du dashboard Energy & CO2${NC}"
    echo "======================================================"
    echo -e "✅ ${GREEN}Calcul énergétique en temps réel${NC} : Basé sur CPU et mémoire"
    echo -e "✅ ${GREEN}Calcul CO2 en temps réel${NC} : Émissions par heure"
    echo -e "✅ ${GREEN}4 conteneurs DevOps spécifiques${NC} : Portainer, MongoDB, Backend, Frontend"
    echo -e "✅ ${GREEN}Métriques individuelles${NC} : Chaque conteneur a ses propres calculs"
    echo -e "✅ ${GREEN}Graphiques ASCII énergétiques${NC} : Visualisation de la consommation"
    echo -e "✅ ${GREEN}Couleurs distinctes${NC} : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
    echo -e "✅ ${GREEN}Calculs dynamiques${NC} : Les valeurs changent en temps réel"
    echo -e "✅ ${GREEN}Pas de valeurs statiques${NC} : Calculs basés sur les métriques réelles"
    echo -e "✅ ${GREEN}Green IT${NC} : Surveillance de l'impact environnemental"

    echo ""
    echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
    echo "========================"
    echo -e "📊 Grafana: ${BLUE}http://localhost:3000${NC} (admin/admin123)"
    echo -e "📈 Prometheus: ${BLUE}http://localhost:9090${NC}"
    echo -e "🔍 cAdvisor: ${BLUE}http://localhost:8080${NC}"
    echo ""
    echo -e "${CYAN}💡 Pour une surveillance continue:${NC}"
    echo "   ./devops-energy-dashboard.sh --continuous"
    echo ""

    echo -e "${CYAN}🎯 Dashboard disponible:${NC}"
    echo "=========================="
    echo "✅ 'DevOps Project - Energy Consumption & CO2 Emissions' - CONSOMMATION ÉNERGÉTIQUE"
    echo "   - URL: http://localhost:3000/d/cf3b685d-08d7-4bf6-bebe-161e69126c3f/5684c24"
    echo "   - Calcul énergétique en temps réel (basé sur CPU et mémoire)"
    echo "   - Calcul CO2 en temps réel (émissions par heure)"
    echo "   - 4 conteneurs DevOps spécifiques : Portainer, MongoDB, Backend, Frontend"
    echo "   - Métriques individuelles qui changent en temps réel"
    echo "   - Graphiques énergétiques qui évoluent"
    echo "   - Rafraîchissement automatique toutes les 2 secondes"
    echo "   - Green IT : Surveillance de l'impact environnemental"

    echo ""
    echo -e "${CYAN}🌐 Ouverture de Grafana...${NC}"
    sleep 2
    open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

    echo ""
    echo -e "${GREEN}✅ Dashboard Energy & CO2 ouvert !${NC}"
    echo "   - Calcul énergétique en temps réel (basé sur CPU et mémoire)"
    echo "   - Calcul CO2 en temps réel (émissions par heure)"
    echo "   - 4 conteneurs DevOps spécifiques : Portainer, MongoDB, Backend, Frontend"
    echo "   - Métriques individuelles qui changent en temps réel"
    echo "   - Graphiques énergétiques qui évoluent"
    echo "   - Rafraîchissement automatique toutes les 2 secondes"
    echo "   - Green IT : Surveillance de l'impact environnemental"
fi
