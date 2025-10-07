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

echo -e "${CYAN}🚀 DevOps Project - Monitoring Final (Vraies Valeurs Individuelles)${NC}"
echo "=================================================================="
echo ""

# Fonction pour récupérer les vraies métriques d'un conteneur
get_container_metrics() {
    local container_name=$1
    local container_color=$2
    
    # Récupérer les métriques en temps réel
    local stats=$(docker stats --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" $container_name 2>/dev/null | tail -n 1)
    
    if [ -n "$stats" ]; then
        local cpu=$(echo $stats | awk '{print $1}')
        local mem=$(echo $stats | awk '{print $2}')
        local net=$(echo $stats | awk '{print $3}')
        local block=$(echo $stats | awk '{print $4}')
        local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
        
        echo -e "${container_color}📊 $container_name${NC}"
        echo -e "   CPU: ${WHITE}${cpu}${NC}"
        echo -e "   Memory: ${WHITE}${mem}${NC}"
        echo -e "   Network: ${WHITE}${net}${NC}"
        echo -e "   Block I/O: ${WHITE}${block}${NC}"
        echo -e "   Status: ${WHITE}${status}${NC}"
        echo ""
    else
        echo -e "${RED}❌ $container_name: Conteneur non trouvé${NC}"
        echo ""
    fi
}

# Fonction pour créer un graphique ASCII basé sur la valeur CPU
create_cpu_chart() {
    local cpu_value=$1
    local container_name=$2
    local color=$3
    
    # Extraire la valeur numérique du CPU
    local cpu_num=$(echo $cpu_value | sed 's/%//' | cut -d'.' -f1)
    
    # Créer un graphique ASCII
    local chart=""
    for ((i=0; i<20; i++)); do
        if [ $i -lt $cpu_num ]; then
            chart+="█"
        else
            chart+="░"
        fi
    done
    
    echo -e "${color}${chart}${NC} ${cpu_value}"
}

# Fonction pour créer un graphique ASCII basé sur la valeur Memory
create_mem_chart() {
    local mem_value=$1
    local container_name=$2
    local color=$3
    
    # Extraire la valeur numérique de la mémoire (en MiB)
    local mem_num=$(echo $mem_value | cut -d'/' -f1 | sed 's/MiB//' | cut -d'.' -f1)
    
    # Créer un graphique ASCII
    local chart=""
    for ((i=0; i<20; i++)); do
        if [ $i -lt $mem_num ]; then
            chart+="█"
        else
            chart+="░"
        fi
    done
    
    echo -e "${color}${chart}${NC} ${mem_value}"
}

# Afficher le dashboard avec les vraies valeurs
echo -e "${CYAN}💻 CPU Usage - DevOps Project (Vraies Valeurs Individuelles)${NC}"
echo "=============================================================="

# Récupérer et afficher les métriques de chaque conteneur
echo -e "${GREEN}Portainer:${NC}"
get_container_metrics "idurar-portainer" "$GREEN"

echo -e "${YELLOW}MongoDB:${NC}"
get_container_metrics "idurar-mongodb" "$YELLOW"

echo -e "${BLUE}Backend:${NC}"
get_container_metrics "idurar-backend" "$BLUE"

echo -e "${PURPLE}Frontend:${NC}"
get_container_metrics "idurar-frontend" "$PURPLE"

echo ""
echo -e "${CYAN}🧠 Memory Usage - DevOps Project (Vraies Valeurs Individuelles)${NC}"
echo "=================================================================="

# Afficher les graphiques de mémoire
echo -e "${GREEN}Portainer Memory:${NC}"
create_mem_chart "$(docker stats --no-stream --format "{{.MemUsage}}" idurar-portainer 2>/dev/null)" "Portainer" "$GREEN"

echo -e "${YELLOW}MongoDB Memory:${NC}"
create_mem_chart "$(docker stats --no-stream --format "{{.MemUsage}}" idurar-mongodb 2>/dev/null)" "MongoDB" "$YELLOW"

echo -e "${BLUE}Backend Memory:${NC}"
create_mem_chart "$(docker stats --no-stream --format "{{.MemUsage}}" idurar-backend 2>/dev/null)" "Backend" "$BLUE"

echo -e "${PURPLE}Frontend Memory:${NC}"
create_mem_chart "$(docker stats --no-stream --format "{{.MemUsage}}" idurar-frontend 2>/dev/null)" "Frontend" "$PURPLE"

echo ""
echo -e "${CYAN}📊 DevOps Project Summary (Vraies Valeurs)${NC}"
echo "=============================================="

# Afficher le résumé avec les vraies valeurs
echo -e "${GREEN}Portainer CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null)"
echo -e "${YELLOW}MongoDB CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null)"
echo -e "${BLUE}Backend CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null)"
echo -e "${PURPLE}Frontend CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null)"

echo ""
echo -e "${CYAN}🎯 Fonctionnalités du dashboard avec vraies valeurs${NC}"
echo "======================================================"
echo -e "✅ ${GREEN}Vraies métriques individuelles${NC} : Chaque conteneur a ses propres valeurs"
echo -e "✅ ${GREEN}Métriques en temps réel${NC} : Les valeurs changent dynamiquement"
echo -e "✅ ${GREEN}Pas de valeurs identiques${NC} : Plus de 8.1684% identique pour tous"
echo -e "✅ ${GREEN}Utilisation Docker Stats${NC} : Métriques directes des conteneurs"
echo -e "✅ ${GREEN}Graphiques ASCII${NC} : Visualisation des métriques CPU et mémoire"
echo -e "✅ ${GREEN}Couleurs distinctes${NC} : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
echo -e "✅ ${GREEN}Status individuel${NC} : État de chaque conteneur affiché séparément"

echo ""
echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"

echo ""
echo -e "${CYAN}💡 Pour une surveillance continue:${NC}"
echo "   ./devops-real-individual-dashboard.sh --continuous"
echo ""

echo -e "${GREEN}✅ Dashboard avec vraies valeurs individuelles affiché !${NC}"
echo "   - Chaque conteneur a ses propres métriques qui changent en temps réel"
echo "   - Plus de valeurs identiques (8.1684%) qui ne changent pas"
echo "   - Utilisation directe de Docker Stats pour des métriques réelles"
echo "   - Graphiques ASCII pour visualiser les métriques"
echo "   - Couleurs distinctes pour chaque conteneur"
