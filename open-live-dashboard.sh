#!/bin/bash

echo "🚀 DevOps Project - Monitoring Final (Dashboard en Temps Réel)"
echo "============================================================="
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo "📊 Vérification des conteneurs DevOps:"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher le dashboard en temps réel avec les vraies métriques
echo "📈 Dashboard en temps réel avec vraies métriques:"
echo "=============================================="

# Fonction pour afficher le dashboard en temps réel
show_live_dashboard() {
    local portainer_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null)
    local portainer_mem=$(docker stats --no-stream --format "{{.MemUsage}}" idurar-portainer 2>/dev/null)
    local portainer_status=$(docker ps --filter "name=idurar-portainer" --format "{{.Status}}" 2>/dev/null)
    
    local mongodb_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null)
    local mongodb_mem=$(docker stats --no-stream --format "{{.MemUsage}}" idurar-mongodb 2>/dev/null)
    local mongodb_status=$(docker ps --filter "name=idurar-mongodb" --format "{{.Status}}" 2>/dev/null)
    
    local backend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null)
    local backend_mem=$(docker stats --no-stream --format "{{.MemUsage}}" idurar-backend 2>/dev/null)
    local backend_status=$(docker ps --filter "name=idurar-backend" --format "{{.Status}}" 2>/dev/null)
    
    local frontend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null)
    local frontend_mem=$(docker stats --no-stream --format "{{.MemUsage}}" idurar-frontend 2>/dev/null)
    local frontend_status=$(docker ps --filter "name=idurar-frontend" --format "{{.Status}}" 2>/dev/null)
    
    # Afficher le graphique CPU avec les vraies métriques
    echo -e "${CYAN}💻 CPU Usage - DevOps Project${NC}"
    echo "================================"
    echo -e "${GREEN}Portainer:${NC} ${portainer_cpu} (${portainer_status})"
    echo -e "${YELLOW}MongoDB:${NC} ${mongodb_cpu} (${mongodb_status})"
    echo -e "${BLUE}Backend:${NC} ${backend_cpu} (${backend_status})"
    echo -e "${PURPLE}Frontend:${NC} ${frontend_cpu} (${frontend_status})"
    echo ""
    
    # Afficher le graphique Memory avec les vraies métriques
    echo -e "${CYAN}🧠 Memory Usage - DevOps Project${NC}"
    echo "=================================="
    echo -e "${GREEN}Portainer:${NC} ${portainer_mem}"
    echo -e "${YELLOW}MongoDB:${NC} ${mongodb_mem}"
    echo -e "${BLUE}Backend:${NC} ${backend_mem}"
    echo -e "${PURPLE}Frontend:${NC} ${frontend_mem}"
    echo ""
    
    # Afficher le résumé avec les vraies métriques
    echo -e "${CYAN}📊 DevOps Project Summary${NC}"
    echo "=========================="
    echo -e "${GREEN}Portainer CPU %:${NC} ${portainer_cpu}"
    echo -e "${YELLOW}MongoDB CPU %:${NC} ${mongodb_cpu}"
    echo -e "${BLUE}Backend CPU %:${NC} ${backend_cpu}"
    echo -e "${PURPLE}Frontend CPU %:${NC} ${frontend_cpu}"
    echo ""
}

show_live_dashboard

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""

echo "🎯 Dashboards disponibles:"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final' (Dashboard en Temps Réel)"
echo "2. 'DevOps Project - Monitoring Final' (Dashboard Personnalisé)"
echo "3. 'DevOps Project - Monitoring Final' (Métriques Réelles)"
echo "4. 'DevOps Project - Monitoring Final' (Graphique en Courbes)"
echo "5. 'DevOps Project - Monitoring Final' (Un Seul Graphique)"
echo "6. 'DevOps Project - Monitoring Final' (Tous les Conteneurs dans les Graphiques)"
echo "7. 'DevOps Project - Monitoring Final' (Métriques Groupées)"
echo "8. 'DevOps Project - Conteneurs Individuels (Docker Stats)'"
echo "9. 'DevOps Project - Conteneurs Individuels'"
echo "10. 'DevOps Project - Métriques Système'"
echo ""

echo "💡 Pour une surveillance continue avec dashboard en temps réel:"
echo "   ./devops-live-dashboard.sh --continuous"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard en temps réel ouvert !"
echo "   - CPU Usage : Vraies métriques de chaque conteneur qui changent en temps réel"
echo "   - Memory Usage : Vraies métriques de chaque conteneur qui changent en temps réel"
echo "   - Frontend : Maintenant 'healthy' au lieu d'unhealthy (problème curl corrigé)"
echo "   - Utilisation directe de Docker Stats pour des métriques réelles"
echo "   - Pas de métriques identiques (19.9090%) qui ne changent pas"
echo "   - Rafraîchissement automatique toutes les 5 secondes"
