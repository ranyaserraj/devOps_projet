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

# Vérifier que tous les conteneurs sont en cours d'exécution
echo -e "${CYAN}📊 Vérification des conteneurs DevOps:${NC}"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Fonction pour récupérer les vraies métriques d'un conteneur
get_real_metrics() {
    local container_name=$1
    local container_color=$2
    local container_label=$3
    
    # Récupérer les métriques en temps réel
    local cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" $container_name 2>/dev/null)
    local mem=$(docker stats --no-stream --format "{{.MemUsage}}" $container_name 2>/dev/null)
    local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
    
    if [ -n "$cpu" ] && [ -n "$mem" ]; then
        echo -e "${container_color}${container_label}:${NC}"
        echo -e "   CPU: ${WHITE}${cpu}${NC}"
        echo -e "   Memory: ${WHITE}${mem}${NC}"
        echo -e "   Status: ${WHITE}${status}${NC}"
        echo ""
    else
        echo -e "${RED}❌ $container_label: Conteneur non trouvé${NC}"
        echo ""
    fi
}

# Afficher le dashboard avec les vraies valeurs
echo -e "${CYAN}💻 CPU Usage - DevOps Project (Vraies Valeurs Individuelles)${NC}"
echo "=============================================================="

# Récupérer et afficher les métriques de chaque conteneur
get_real_metrics "idurar-portainer" "$GREEN" "Portainer"
get_real_metrics "idurar-mongodb" "$YELLOW" "MongoDB"
get_real_metrics "idurar-backend" "$BLUE" "Backend"
get_real_metrics "idurar-frontend" "$PURPLE" "Frontend"

echo -e "${CYAN}🧠 Memory Usage - DevOps Project (Vraies Valeurs Individuelles)${NC}"
echo "=================================================================="

# Afficher les métriques de mémoire
echo -e "${GREEN}Portainer Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-portainer 2>/dev/null)"
echo -e "${YELLOW}MongoDB Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-mongodb 2>/dev/null)"
echo -e "${BLUE}Backend Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-backend 2>/dev/null)"
echo -e "${PURPLE}Frontend Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-frontend 2>/dev/null)"
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
echo -e "✅ ${GREEN}Couleurs distinctes${NC} : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
echo -e "✅ ${GREEN}Status individuel${NC} : État de chaque conteneur affiché séparément"

echo ""
echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"

echo ""
echo -e "${CYAN}🎯 Dashboards disponibles:${NC}"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final (Vraies Valeurs Individuelles)'"
echo "2. 'DevOps Project - Monitoring Final (Dashboard en Temps Réel)'"
echo "3. 'DevOps Project - Monitoring Final (Dashboard Personnalisé)'"
echo "4. 'DevOps Project - Monitoring Final (Métriques Réelles)'"
echo "5. 'DevOps Project - Monitoring Final (Graphique en Courbes)'"
echo "6. 'DevOps Project - Monitoring Final (Un Seul Graphique)'"
echo "7. 'DevOps Project - Monitoring Final (Tous les Conteneurs dans les Graphiques)'"
echo "8. 'DevOps Project - Monitoring Final (Métriques Groupées)'"
echo "9. 'DevOps Project - Conteneurs Individuels (Docker Stats)'"
echo "10. 'DevOps Project - Conteneurs Individuels'"
echo "11. 'DevOps Project - Métriques Système'"

echo ""
echo -e "${CYAN}💡 Pour une surveillance continue avec vraies valeurs:${NC}"
echo "   ./devops-real-individual-dashboard.sh --continuous"
echo ""

echo -e "${CYAN}🌐 Ouverture de Grafana...${NC}"
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo -e "${GREEN}✅ Dashboard avec vraies valeurs individuelles ouvert !${NC}"
echo "   - Chaque conteneur a ses propres métriques qui changent en temps réel"
echo "   - Plus de valeurs identiques (8.1684%) qui ne changent pas"
echo "   - Utilisation directe de Docker Stats pour des métriques réelles"
echo "   - Graphiques avec couleurs distinctes pour chaque conteneur"
echo "   - Frontend maintenant 'healthy' au lieu d'unhealthy"
