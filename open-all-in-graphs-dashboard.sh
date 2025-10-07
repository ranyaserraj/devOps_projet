#!/bin/bash

echo "🚀 DevOps Project - Monitoring Final (Tous les Conteneurs dans les Graphiques)"
echo "=============================================================================="
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo "📊 Vérification des conteneurs DevOps:"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher tous les conteneurs dans les deux graphiques
echo "📈 Tous les conteneurs dans les graphiques:"
echo "=========================================="

# Fonction pour afficher tous les conteneurs dans les graphiques
show_all_containers_in_graphs() {
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
    
    # Afficher le graphique CPU avec tous les conteneurs
    echo -e "${CYAN}💻 CPU Usage - DevOps Project${NC}"
    echo "================================"
    echo -e "${GREEN}Portainer:${NC} ${portainer_cpu} (${portainer_status})"
    echo -e "${YELLOW}MongoDB:${NC} ${mongodb_cpu} (${mongodb_status})"
    echo -e "${BLUE}Backend:${NC} ${backend_cpu} (${backend_status})"
    echo -e "${PURPLE}Frontend:${NC} ${frontend_cpu} (${frontend_status})"
    echo ""
    
    # Afficher le graphique Memory avec tous les conteneurs
    echo -e "${CYAN}🧠 Memory Usage - DevOps Project${NC}"
    echo "=================================="
    echo -e "${GREEN}Portainer:${NC} ${portainer_mem}"
    echo -e "${YELLOW}MongoDB:${NC} ${mongodb_mem}"
    echo -e "${BLUE}Backend:${NC} ${backend_mem}"
    echo -e "${PURPLE}Frontend:${NC} ${frontend_mem}"
    echo ""
    
    # Afficher le résumé
    echo -e "${CYAN}📊 DevOps Project Summary${NC}"
    echo "=========================="
    echo -e "${GREEN}Portainer CPU %:${NC} ${portainer_cpu}"
    echo -e "${YELLOW}MongoDB CPU %:${NC} ${mongodb_cpu}"
    echo -e "${BLUE}Backend CPU %:${NC} ${backend_cpu}"
    echo -e "${PURPLE}Frontend CPU %:${NC} ${frontend_cpu}"
    echo ""
}

show_all_containers_in_graphs

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""

echo "🎯 Dashboards disponibles:"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final' (Tous les Conteneurs dans les Graphiques)"
echo "2. 'DevOps Project - Monitoring Final' (Métriques Groupées)"
echo "3. 'DevOps Project - Conteneurs Individuels (Docker Stats)'"
echo "4. 'DevOps Project - Conteneurs Individuels'"
echo "5. 'DevOps Project - Métriques Système'"
echo ""

echo "💡 Pour une surveillance continue avec tous les conteneurs dans les graphiques:"
echo "   ./devops-all-in-graphs-dashboard.sh --continuous"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard avec tous les conteneurs dans les graphiques ouvert !"
echo "   - CPU Usage : Tous les conteneurs (Portainer, MongoDB, Backend, Frontend) avec couleurs distinctes"
echo "   - Memory Usage : Tous les conteneurs (Portainer, MongoDB, Backend, Frontend) avec couleurs distinctes"
echo "   - Couleurs : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
echo "   - Résumé : Consommation CPU séparée pour chaque conteneur"
echo "   - Rafraîchissement automatique toutes les 5 secondes"
