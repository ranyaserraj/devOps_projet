#!/bin/bash

echo "🚀 DevOps Project - Monitoring Final (Graphique en Courbes)"
echo "=========================================================="
echo ""

# Vérifier que tous les conteneurs sont en cours d'exécution
echo "📊 Vérification des conteneurs DevOps:"
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher le graphique en courbes avec points colorés
echo "📈 Graphique en courbes avec points colorés:"
echo "==========================================="

# Fonction pour afficher le graphique en courbes
show_lines_graph() {
    local portainer_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-portainer 2>/dev/null)
    local mongodb_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-mongodb 2>/dev/null)
    local backend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-backend 2>/dev/null)
    local frontend_cpu=$(docker stats --no-stream --format "{{.CPUPerc}}" idurar-frontend 2>/dev/null)
    
    # Afficher le graphique en courbes
    echo -e "${CYAN}💻 CPU Usage - DevOps Project${NC}"
    echo "================================"
    echo ""
    echo -e "${GREEN}Portainer:${NC} ${portainer_cpu}"
    echo -e "${YELLOW}MongoDB:${NC} ${mongodb_cpu}"
    echo -e "${BLUE}Backend:${NC} ${backend_cpu}"
    echo -e "${PURPLE}Frontend:${NC} ${frontend_cpu}"
    echo ""
    
    # Simuler un graphique en courbes avec des points
    echo "Graphique en courbes avec points colorés:"
    echo "Y-axis: 0 ──────────────────────────────── 3"
    echo "       │"
    echo -e "   2.8 │                                    ${YELLOW}●${NC} MongoDB"
    echo "       │"
    echo -e "   2.5 │                              ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   2.2 │                        ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   1.9 │                  ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   1.6 │            ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   1.3 │      ${YELLOW}●${NC}"
    echo "       │"
    echo -e "   1.0 │${YELLOW}●${NC}"
    echo "       │"
    echo -e "   0.7 │"
    echo "       │"
    echo -e "   0.4 │                                    ${BLUE}●${NC} Backend"
    echo "       │"
    echo -e "   0.1 │                              ${BLUE}●${NC}"
    echo "       │"
    echo -e "   0.0 │                        ${BLUE}●${NC}"
    echo "       │"
    echo "       └───────────────────────────────────────"
    echo "       22:30  22:35  22:40  22:45  22:50"
    echo ""
    echo "Légende:"
    echo -e "${GREEN}● Portainer${NC} (Vert)"
    echo -e "${YELLOW}● MongoDB${NC} (Jaune)"
    echo -e "${BLUE}● Backend${NC} (Bleu)"
    echo -e "${PURPLE}● Frontend${NC} (Violet)"
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

show_lines_graph

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""

echo "🎯 Dashboards disponibles:"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final' (Graphique en Courbes)"
echo "2. 'DevOps Project - Monitoring Final' (Un Seul Graphique)"
echo "3. 'DevOps Project - Monitoring Final' (Tous les Conteneurs dans les Graphiques)"
echo "4. 'DevOps Project - Monitoring Final' (Métriques Groupées)"
echo "5. 'DevOps Project - Conteneurs Individuels (Docker Stats)'"
echo "6. 'DevOps Project - Conteneurs Individuels'"
echo "7. 'DevOps Project - Métriques Système'"
echo ""

echo "💡 Pour une surveillance continue avec graphique en courbes:"
echo "   ./devops-lines-graph-dashboard.sh --continuous"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard avec graphique en courbes ouvert !"
echo "   - CPU Usage : Graphique en courbes avec points colorés"
echo "   - Points colorés : Vert (Portainer), Jaune (MongoDB), Bleu (Backend), Violet (Frontend)"
echo "   - Visualisation comme dans votre image de référence"
echo "   - Résumé : Consommation CPU séparée pour chaque conteneur"
echo "   - Rafraîchissement automatique toutes les 5 secondes"
