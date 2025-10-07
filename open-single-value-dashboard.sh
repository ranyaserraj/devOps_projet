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

echo -e "${CYAN}🚀 DevOps Project - Monitoring Final (Single Values)${NC}"
echo "=============================================================="
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo -e "${CYAN}📊 Vérification des conteneurs DevOps:${NC}"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher les métriques en temps réel
echo -e "${CYAN}💻 CPU Usage - DevOps Project (Single Values)${NC}"
echo "======================================================"

# Récupérer et afficher les métriques de chaque conteneur
echo -e "${GREEN}Portainer:${NC}"
docker stats --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" idurar-portainer 2>/dev/null | tail -n 1

echo -e "${YELLOW}MongoDB:${NC}"
docker stats --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" idurar-mongodb 2>/dev/null | tail -n 1

echo -e "${BLUE}Backend:${NC}"
docker stats --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" idurar-backend 2>/dev/null | tail -n 1

echo -e "${PURPLE}Frontend:${NC}"
docker stats --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" idurar-frontend 2>/dev/null | tail -n 1

echo ""
echo -e "${CYAN}🧠 Memory Usage - DevOps Project (Single Values)${NC}"
echo "======================================================"

# Afficher les métriques de mémoire
echo -e "${GREEN}Portainer Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-portainer 2>/dev/null)"
echo -e "${YELLOW}MongoDB Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-mongodb 2>/dev/null)"
echo -e "${BLUE}Backend Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-backend 2>/dev/null)"
echo -e "${PURPLE}Frontend Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-frontend 2>/dev/null)"

echo ""
echo -e "${CYAN}📊 DevOps Project Summary (Single Values)${NC}"
echo "=============================================="

# Afficher le résumé avec les vraies valeurs
echo -e "${GREEN}Portainer CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null)"
echo -e "${YELLOW}MongoDB CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null)"
echo -e "${BLUE}Backend CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null)"
echo -e "${PURPLE}Frontend CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null)"

echo ""
echo -e "${CYAN}🎯 Fonctionnalités du dashboard Single Values${NC}"
echo "=============================================="
echo -e "✅ ${GREEN}Une seule valeur par métrique${NC} : Plus de valeurs dupliquées"
echo -e "✅ ${GREEN}Panels Gauge${NC} : Utilise des jauges au lieu de stat panels"
echo -e "✅ ${GREEN}Métriques en temps réel${NC} : Utilise Docker Stats directement"
echo -e "✅ ${GREEN}4 conteneurs DevOps spécifiques${NC} : Portainer, MongoDB, Backend, Frontend"
echo -e "✅ ${GREEN}Métriques individuelles${NC} : Chaque conteneur a ses propres valeurs"
echo -e "✅ ${GREEN}Couleurs distinctes${NC} : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
echo -e "✅ ${GREEN}Status individuel${NC} : État de chaque conteneur affiché séparément"
echo -e "✅ ${GREEN}Métriques qui changent${NC} : Les valeurs évoluent en temps réel"
echo -e "✅ ${GREEN}Pas de valeurs identiques${NC} : Chaque conteneur a ses propres métriques"
echo -e "✅ ${GREEN}Correction du problème de duplication${NC} : Une seule valeur affichée par panel"

echo ""
echo -e "${CYAN}🌐 Accès aux dashboards:${NC}"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"

echo ""
echo -e "${CYAN}🎯 Dashboard disponible:${NC}"
echo "=========================="
echo "✅ 'DevOps Project - Monitoring Final (Single Values)' - MÉTRIQUES SANS DUPLICATION"
echo "   - URL: http://localhost:3000/d/176bde7a-d6a6-4c4c-875b-1ea81b0f376e/devops-project-monitoring-final-single-values"
echo "   - Une seule valeur par métrique (plus de duplication)"
echo "   - Panels Gauge au lieu de stat panels"
echo "   - Métriques en temps réel des 4 conteneurs DevOps"
echo "   - Portainer, MongoDB, Backend, Frontend"
echo "   - Métriques individuelles qui changent en temps réel"
echo "   - Graphiques CPU et Memory qui évoluent"
echo "   - Rafraîchissement automatique toutes les 2 secondes"

echo ""
echo -e "${CYAN}🌐 Ouverture de Grafana...${NC}"
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo -e "${GREEN}✅ Dashboard Single Values ouvert !${NC}"
echo "   - Une seule valeur par métrique (plus de duplication)"
echo "   - Panels Gauge au lieu de stat panels"
echo "   - Métriques en temps réel des 4 conteneurs DevOps"
echo "   - Portainer, MongoDB, Backend, Frontend"
echo "   - Métriques individuelles qui changent en temps réel"
echo "   - Graphiques CPU et Memory qui évoluent"
echo "   - Rafraîchissement automatique toutes les 2 secondes"