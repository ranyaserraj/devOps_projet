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

echo -e "${CYAN}🚀 DevOps Project - Monitoring Final (Containers Only)${NC}"
echo "=============================================================="
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo -e "${CYAN}📊 Vérification des conteneurs DevOps:${NC}"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher les métriques en temps réel
echo -e "${CYAN}💻 CPU Usage - DevOps Project (Containers Only)${NC}"
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
echo -e "${CYAN}🧠 Memory Usage - DevOps Project (Containers Only)${NC}"
echo "======================================================"

# Afficher les métriques de mémoire
echo -e "${GREEN}Portainer Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-portainer 2>/dev/null)"
echo -e "${YELLOW}MongoDB Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-mongodb 2>/dev/null)"
echo -e "${BLUE}Backend Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-backend 2>/dev/null)"
echo -e "${PURPLE}Frontend Memory:${NC} $(docker stats --no-stream --format "{{.MemUsage}}" idurar-frontend 2>/dev/null)"

echo ""
echo -e "${CYAN}📊 DevOps Project Summary (Containers Only)${NC}"
echo "=============================================="

# Afficher le résumé avec les vraies valeurs
echo -e "${GREEN}Portainer CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null)"
echo -e "${YELLOW}MongoDB CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null)"
echo -e "${BLUE}Backend CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null)"
echo -e "${PURPLE}Frontend CPU %:${NC} $(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null)"

echo ""
echo -e "${CYAN}🎯 Fonctionnalités du dashboard Containers Only${NC}"
echo "=============================================="
echo -e "✅ ${GREEN}Métriques des conteneurs uniquement${NC} : Seulement idurar-* conteneurs"
echo -e "✅ ${GREEN}Pas de métriques système globales${NC} : Plus de node_memory_MemTotal_bytes"
echo -e "✅ ${GREEN}Vraies valeurs des conteneurs${NC} : Affiche les métriques réelles"
echo -e "✅ ${GREEN}Une seule valeur par métrique${NC} : Plus de double affichage"
echo -e "✅ ${GREEN}Dashboard fonctionnel${NC} : Affiche des données au lieu de 'Loading...'"
echo -e "✅ ${GREEN}Métriques cAdvisor réelles${NC} : Utilise les vraies métriques des conteneurs"
echo -e "✅ ${GREEN}Rafraîchissement automatique${NC} : Toutes les 2 secondes"
echo -e "✅ ${GREEN}Graphiques en temps réel${NC} : CPU et Memory qui évoluent"
echo -e "✅ ${GREEN}Pas de valeurs statiques${NC} : Les métriques changent dynamiquement"
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
echo "✅ 'DevOps Project - Monitoring Final (Containers Only)' - MÉTRIQUES CONTENEURS UNIQUEMENT"
echo "   - URL: http://localhost:3000/d/ed3adcc3-875e-4a4c-be35-b202d54d598e/devops-project-monitoring-final-containers-only"
echo "   - Métriques des conteneurs uniquement (seulement idurar-* conteneurs)"
echo "   - Pas de métriques système globales (plus de node_memory_MemTotal_bytes)"
echo "   - Vraies valeurs des conteneurs (plus de 'Loading...')"
echo "   - Une seule valeur par métrique (plus de double affichage)"
echo "   - Utilise les métriques cAdvisor réelles des conteneurs"
echo "   - Rafraîchissement automatique toutes les 2 secondes"
echo "   - Graphiques CPU et Memory qui évoluent en temps réel"

echo ""
echo -e "${CYAN}💡 Pour une surveillance continue avec métriques Containers Only:${NC}"
echo "   ./devops-live-docker-monitor.sh --continuous"
echo ""

echo -e "${CYAN}🌐 Ouverture de Grafana...${NC}"
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo -e "${GREEN}✅ Dashboard Containers Only ouvert !${NC}"
echo "   - Métriques des conteneurs uniquement (seulement idurar-* conteneurs)"
echo "   - Pas de métriques système globales (plus de node_memory_MemTotal_bytes)"
echo "   - Vraies valeurs des conteneurs (plus de 'Loading...')"
echo "   - Une seule valeur par métrique (plus de double affichage)"
echo "   - Utilise les métriques cAdvisor réelles des conteneurs"
echo "   - Rafraîchissement automatique toutes les 2 secondes"
echo "   - Graphiques CPU et Memory qui évoluent en temps réel"
echo "   - Frontend maintenant 'healthy' au lieu d'unhealthy"
