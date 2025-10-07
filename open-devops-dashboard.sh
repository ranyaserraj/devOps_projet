#!/bin/bash

echo "🚀 DevOps Project - Monitoring Final"
echo "===================================="
echo ""

# Vérifier que tous les services sont en cours d'exécution
echo "📊 Vérification des services..."
docker ps --filter "name=idurar-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Afficher les métriques actuelles
echo "📈 Métriques actuelles des conteneurs DevOps:"
echo "============================================="

# Fonction pour afficher les métriques d'un conteneur
show_metrics() {
    local container_name=$1
    local cpu_usage=$(docker stats --no-stream --format "{{.CPUPerc}}" $container_name 2>/dev/null | sed 's/%//')
    local mem_usage=$(docker stats --no-stream --format "{{.MemUsage}}" $container_name 2>/dev/null)
    local status=$(docker ps --filter "name=$container_name" --format "{{.Status}}" 2>/dev/null)
    
    if [ -n "$status" ]; then
        echo "📊 $container_name:"
        echo "   💻 CPU: ${cpu_usage}%"
        echo "   🧠 Memory: $mem_usage"
        echo "   📋 Status: $status"
        echo ""
    else
        echo "❌ $container_name: Conteneur non trouvé"
        echo ""
    fi
}

show_metrics "idurar-frontend"
show_metrics "idurar-backend"
show_metrics "idurar-mongodb"
show_metrics "idurar-portainer"

echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 cAdvisor: http://localhost:8080"
echo ""

echo "🎯 Dashboards disponibles:"
echo "=========================="
echo "1. 'DevOps Project - Monitoring Final' (Nouveau)"
echo "2. 'DevOps Project - Métriques Système'"
echo "3. 'DevOps Project - Conteneurs Non-Optimisés (Live)'"
echo ""

echo "💡 Pour une surveillance en temps réel:"
echo "   ./devops-dashboard-live.sh --continuous"
echo ""

echo "🌐 Ouverture de Grafana..."
sleep 2
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard DevOps Project ouvert !"
echo "   - Sélectionnez 'DevOps Project - Monitoring Final'"
echo "   - Métriques en temps réel des conteneurs non-optimisés"
echo "   - Rafraîchissement automatique toutes les 5 secondes"
