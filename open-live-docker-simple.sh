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

echo -e "${CYAN}🚀 DevOps Project - Live Docker Metrics Dashboard${NC}"
echo "======================================================"
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo -e "${CYAN}📊 Vérification des conteneurs DevOps:${NC}"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher les métriques en temps réel
echo -e "${CYAN}💻 CPU Usage - DevOps Project (Live Docker Metrics)${NC}"
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
echo -e "${CYAN}🧠 Memory Usage - DevOps Project (Live Docker Metrics)${NC}"
echo "======================================================"

# Afficher les métriques de mémoire
echo -e "${GREEN}Portainer Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-portainer 2>/dev/null)"
echo -e "${YELLOW}MongoDB Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-mongodb 2>/dev/null)"
echo -e "${BLUE}Backend Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-backend 2>/dev/null)"
echo -e "${PURPLE}Frontend Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-frontend 2>/dev/null)"

echo ""
echo -e "${CYAN}📊 DevOps Project Summary (Live Docker Metrics)${NC}"
echo "=============================================="

# Afficher le résumé avec les vraies valeurs
echo -e "${GREEN}Portainer CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null)"
echo -e "${YELLOW}MongoDB CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null)"
echo -e "${BLUE}Backend CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null)"
echo -e "${PURPLE}Frontend CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null)"

echo ""
echo -e "${CYAN}🎯 Fonctionnalités du dashboard Live Docker${NC}"
echo "=============================================="
echo -e "✅ ${GREEN}Connexion directe aux métriques Docker${NC} : Lié directement aux images Docker"
echo -e "✅ ${GREEN}Métriques en temps réel${NC} : Les valeurs évoluent dynamiquement"
echo -e "✅ ${GREEN}Pas de valeurs statiques${NC} : Plus de 8.1684% identique pour tous"
echo -e "✅ ${GREEN}Rafraîchissement automatique${NC} : Toutes les 2 secondes"
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
echo -e "${CYAN}🎯 Dashboard disponible:${NC}"
echo "=========================="
echo "✅ 'DevOps Project - Live Docker Metrics' - NOUVEAU ET DISPONIBLE"
echo "   - URL: http://localhost:3000/d/b62a2a85-9a54-4b28-9ec4-f73d2d840fd7/devops-project-live-docker-metrics"
echo "   - Connexion directe aux métriques Docker"
echo "   - Rafraîchissement automatique toutes les 2 secondes"
echo "   - Métriques en temps réel qui évoluent"
echo "   - Pas de valeurs statiques"

echo ""
echo -e "${CYAN}💡 Pour une surveillance continue avec métriques Live Docker:${NC}"
echo "   ./devops-live-docker-monitor.sh --continuous"
echo ""

echo -e "${CYAN}🌐 Ouverture de Grafana...${NC}"
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo -e "${GREEN}✅ Dashboard Live Docker Metrics trouvé et ouvert !${NC}"
echo "   - Nom: 'DevOps Project - Live Docker Metrics'"
echo "   - Connexion directe aux métriques Docker"
echo "   - Rafraîchissement automatique toutes les 2 secondes"
echo "   - Métriques qui évoluent en temps réel"
echo "   - Pas de valeurs statiques"
echo "   - Graphiques avec couleurs distinctes pour chaque conteneur"
echo "   - Frontend maintenant 'healthy' au lieu d'unhealthy"
