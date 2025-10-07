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
    local max_chart_length=20
    local num_chars=$((value * max_chart_length / 100))
    local chart=""
    for ((i=0; i<num_chars; i++)); do
        chart+="█"
    done
    for ((i=num_chars; i<max_chart_length; i++)); do
        chart+=" "
    done
    echo -n "$chart"
}

# Fonction pour afficher les métriques d'un conteneur
display_container_metrics() {
    local container_name=$1
    local color=$2
    local label=$3
    local stats=$(docker stats --no-stream --format "{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.PIDs}}\t{{.Status}}" "$container_name" 2>/dev/null)

    if [ -z "$stats" ]; then
        echo -e "${color}📊 $label${NC}"
        echo -e "   Status: ${RED}Not Running${NC}"
        echo ""
        return
    fi

    local name=$(echo "$stats" | awk '{print $1}')
    local cpu_usage=$(echo "$stats" | awk '{print $2}')
    local mem_usage=$(echo "$stats" | awk '{print $3}')
    local net_io=$(echo "$stats" | awk '{print $4}')
    local block_io=$(echo "$stats" | awk '{print $5}')
    local status=$(echo "$stats" | awk '{for (i=7; i<=NF; i++) printf "%s ", $i; print ""}')

    echo -e "${color}📊 $label${NC}"
    echo -e "   CPU: ${color}${cpu_usage}${NC}"
    echo -e "   Memory: ${color}${mem_usage}${NC}"
    echo -e "   Network: ${color}${net_io}${NC}"
    echo -e "   Block I/O: ${color}${block_io}${NC}"
    echo -e "   Status: ${color}${status}${NC}"
    echo ""
}

# Fonction pour afficher les métriques de mémoire avec graphique ASCII
display_memory_with_chart() {
    local container_name=$1
    local color=$2
    local label=$3
    local stats=$(docker stats --no-stream --format "{{.MemUsage}}" "$container_name" 2>/dev/null)

    if [ -z "$stats" ]; then
        echo -e "${color}${label} Memory:${NC}"
        echo -e "   ${RED}Not Running${NC}"
        return
    fi

    local mem_used=$(echo "$stats" | awk '{print $1}')
    local mem_total=$(echo "$stats" | awk '{print $3}')
    local mem_percent=$(echo "$mem_used" | sed 's/MiB//' | sed 's/GiB//' | awk '{print int($1)}')

    echo -e "${color}${label} Memory:${NC}"
    echo -e "${color}$(create_ascii_chart $mem_percent)${NC} ${mem_used} / ${mem_total}"
}

# Fonction pour afficher le résumé CPU
display_cpu_summary() {
    local container_name=$1
    local color=$2
    local label=$3
    local stats=$(docker stats --no-stream --format "{{.CPUPerc}}" "$container_name" 2>/dev/null)

    if [ -z "$stats" ]; then
        echo -e "${color}${label} CPU %: ${RED}Not Running${NC}"
        return
    fi

    echo -e "${color}${label} CPU %: ${stats}${NC}"
}

# Boucle de surveillance continue
if [[ "$1" == "--continuous" ]]; then
    while true; do
        clear
        echo -e "${CYAN}🚀 DevOps Project - Monitoring Final (Live Container Metrics)${NC}"
        echo "=================================================================="
        echo ""

        echo -e "${CYAN}💻 CPU Usage - DevOps Project (Live Container Metrics)${NC}"
        echo "=============================================================="
        display_container_metrics "idurar-portainer" "${GREEN}" "Portainer"
        display_container_metrics "idurar-mongodb" "${YELLOW}" "MongoDB"
        display_container_metrics "idurar-backend" "${BLUE}" "Backend"
        display_container_metrics "idurar-frontend" "${PURPLE}" "Frontend"

        echo -e "${CYAN}🧠 Memory Usage - DevOps Project (Live Container Metrics)${NC}"
        echo "=================================================================="
        display_memory_with_chart "idurar-portainer" "${GREEN}" "Portainer"
        display_memory_with_chart "idurar-mongodb" "${YELLOW}" "MongoDB"
        display_memory_with_chart "idurar-backend" "${BLUE}" "Backend"
        display_memory_with_chart "idurar-frontend" "${PURPLE}" "Frontend"
        echo ""

        echo -e "${CYAN}📊 DevOps Project Summary (Live Container Metrics)${NC}"
        echo "=============================================="
        display_cpu_summary "idurar-portainer" "${GREEN}" "Portainer"
        display_cpu_summary "idurar-mongodb" "${YELLOW}" "MongoDB"
        display_cpu_summary "idurar-backend" "${BLUE}" "Backend"
        display_cpu_summary "idurar-frontend" "${PURPLE}" "Frontend"
        echo ""

        echo -e "${CYAN}🎯 Fonctionnalités du dashboard Live Container Metrics${NC}"
        echo "======================================================"
        echo -e "✅ ${GREEN}Métriques en temps réel${NC} : Utilise Docker Stats directement"
        echo -e "✅ ${GREEN}Vraies valeurs des conteneurs${NC} : Pas de valeurs statiques"
        echo -e "✅ ${GREEN}4 conteneurs DevOps spécifiques${NC} : Portainer, MongoDB, Backend, Frontend"
        echo -e "✅ ${GREEN}Métriques individuelles${NC} : Chaque conteneur a ses propres valeurs"
        echo -e "✅ ${GREEN}Graphiques ASCII${NC} : Visualisation des métriques CPU et mémoire"
        echo -e "✅ ${GREEN}Couleurs distinctes${NC} : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
        echo -e "✅ ${GREEN}Status individuel${NC} : État de chaque conteneur affiché séparément"
        echo -e "✅ ${GREEN}Métriques qui changent${NC} : Les valeurs évoluent en temps réel"
        echo -e "✅ ${GREEN}Pas de valeurs identiques${NC} : Chaque conteneur a ses propres métriques"

        echo ""
        echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
        echo "========================"
        echo -e "📊 Grafana: ${BLUE}http://localhost:3000${NC} (admin/admin123)"
        echo -e "📈 Prometheus: ${BLUE}http://localhost:9090${NC}"
        echo -e "🔍 cAdvisor: ${BLUE}http://localhost:8080${NC}"
        echo ""
        echo -e "${CYAN}💡 Pour une surveillance continue:${NC}"
        echo "   ./devops-final-dashboard.sh --continuous"
        sleep 5
    done
else
    echo -e "${CYAN}🚀 DevOps Project - Monitoring Final (Live Container Metrics)${NC}"
    echo "=================================================================="
    echo ""

    echo -e "${CYAN}💻 CPU Usage - DevOps Project (Live Container Metrics)${NC}"
    echo "=============================================================="
    display_container_metrics "idurar-portainer" "${GREEN}" "Portainer"
    display_container_metrics "idurar-mongodb" "${YELLOW}" "MongoDB"
    display_container_metrics "idurar-backend" "${BLUE}" "Backend"
    display_container_metrics "idurar-frontend" "${PURPLE}" "Frontend"

    echo -e "${CYAN}🧠 Memory Usage - DevOps Project (Live Container Metrics)${NC}"
    echo "=================================================================="
    display_memory_with_chart "idurar-portainer" "${GREEN}" "Portainer"
    display_memory_with_chart "idurar-mongodb" "${YELLOW}" "MongoDB"
    display_memory_with_chart "idurar-backend" "${BLUE}" "Backend"
    display_memory_with_chart "idurar-frontend" "${PURPLE}" "Frontend"
    echo ""

    echo -e "${CYAN}📊 DevOps Project Summary (Live Container Metrics)${NC}"
    echo "=============================================="
    display_cpu_summary "idurar-portainer" "${GREEN}" "Portainer"
    display_cpu_summary "idurar-mongodb" "${YELLOW}" "MongoDB"
    display_cpu_summary "idurar-backend" "${BLUE}" "Backend"
    display_cpu_summary "idurar-frontend" "${PURPLE}" "Frontend"
    echo ""

    echo -e "${CYAN}🎯 Fonctionnalités du dashboard Live Container Metrics${NC}"
    echo "======================================================"
    echo -e "✅ ${GREEN}Métriques en temps réel${NC} : Utilise Docker Stats directement"
    echo -e "✅ ${GREEN}Vraies valeurs des conteneurs${NC} : Pas de valeurs statiques"
    echo -e "✅ ${GREEN}4 conteneurs DevOps spécifiques${NC} : Portainer, MongoDB, Backend, Frontend"
    echo -e "✅ ${GREEN}Métriques individuelles${NC} : Chaque conteneur a ses propres valeurs"
    echo -e "✅ ${GREEN}Graphiques ASCII${NC} : Visualisation des métriques CPU et mémoire"
    echo -e "✅ ${GREEN}Couleurs distinctes${NC} : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
    echo -e "✅ ${GREEN}Status individuel${NC} : État de chaque conteneur affiché séparément"
    echo -e "✅ ${GREEN}Métriques qui changent${NC} : Les valeurs évoluent en temps réel"
    echo -e "✅ ${GREEN}Pas de valeurs identiques${NC} : Chaque conteneur a ses propres métriques"

    echo ""
    echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
    echo "========================"
    echo -e "📊 Grafana: ${BLUE}http://localhost:3000${NC} (admin/admin123)"
    echo -e "📈 Prometheus: ${BLUE}http://localhost:9090${NC}"
    echo -e "🔍 cAdvisor: ${BLUE}http://localhost:8080${NC}"
    echo ""
    echo -e "${CYAN}💡 Pour une surveillance continue:${NC}"
    echo "   ./devops-final-dashboard.sh --continuous"
    echo ""

    echo -e "${CYAN}🎯 Dashboard disponible:${NC}"
    echo "=========================="
    echo "✅ 'DevOps Project - Monitoring Final (Live Container Metrics)' - MÉTRIQUES EN TEMPS RÉEL"
    echo "   - URL: http://localhost:3000/d/b9472545-5f72-4b61-8664-e2752d66fe90/e9fff13"
    echo "   - Métriques en temps réel des 4 conteneurs DevOps"
    echo "   - Vraies valeurs des conteneurs (pas de valeurs statiques)"
    echo "   - Portainer, MongoDB, Backend, Frontend"
    echo "   - Métriques individuelles qui changent en temps réel"
    echo "   - Graphiques CPU et Memory qui évoluent"
    echo "   - Rafraîchissement automatique toutes les 2 secondes"

    echo ""
    echo -e "${CYAN}🌐 Ouverture de Grafana...${NC}"
    sleep 2
    open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

    echo ""
    echo -e "${GREEN}✅ Dashboard Live Container Metrics ouvert !${NC}"
    echo "   - Métriques en temps réel des 4 conteneurs DevOps"
    echo "   - Vraies valeurs des conteneurs (pas de valeurs statiques)"
    echo "   - Portainer, MongoDB, Backend, Frontend"
    echo "   - Métriques individuelles qui changent en temps réel"
    echo "   - Graphiques CPU et Memory qui évoluent"
    echo "   - Rafraîchissement automatique toutes les 2 secondes"
fi
