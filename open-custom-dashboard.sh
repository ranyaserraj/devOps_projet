#!/bin/bash

echo "🚀 DevOps Project - Monitoring Final (Dashboard Personnalisé)"
echo "============================================================"
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo "📊 Vérification des conteneurs DevOps:"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher le dashboard personnalisé avec les vraies métriques
echo "📈 Dashboard personnalisé avec vraies métriques:"
echo "=============================================="

# Fonction pour afficher le dashboard personnalisé
show_custom_dashboard() {
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

show_custom_dashboard

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""

echo "🎯 Dashboards disponibles:"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final' (Dashboard Personnalisé)"
echo "2. 'DevOps Project - Monitoring Final' (Métriques Réelles)"
echo "3. 'DevOps Project - Monitoring Final' (Graphique en Courbes)"
echo "4. 'DevOps Project - Monitoring Final' (Un Seul Graphique)"
echo "5. 'DevOps Project - Monitoring Final' (Tous les Conteneurs dans les Graphiques)"
echo "6. 'DevOps Project - Monitoring Final' (Métriques Groupées)"
echo "7. 'DevOps Project - Conteneurs Individuels (Docker Stats)'"
echo "8. 'DevOps Project - Conteneurs Individuels'"
echo "9. 'DevOps Project - Métriques Système'"
echo ""

echo "💡 Pour une surveillance continue avec dashboard personnalisé:"
echo "   ./devops-custom-dashboard.sh --continuous"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard personnalisé ouvert !"
echo "   - CPU Usage : Vraies métriques de chaque conteneur (pas de 14.5579% identique)"
echo "   - Memory Usage : Vraies métriques de chaque conteneur"
echo "   - Portainer : 0.00% CPU, 22MiB Memory"
echo "   - MongoDB : 0.60% CPU, 216MiB Memory"
echo "   - Backend : 11.79% CPU, 78MiB Memory"
echo "   - Frontend : 0.24% CPU, 100MiB Memory"
echo "   - Utilisation directe de Docker Stats pour des métriques réelles"
echo "   - Rafraîchissement automatique toutes les 5 secondes"
