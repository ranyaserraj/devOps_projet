#!/bin/bash

echo "🚀 LANCEMENT GRAFANA - Version Non-Optimisée"
echo "==========================================="
echo ""

# Fonction pour vérifier les prérequis
check_prerequisites() {
    echo "🔍 Vérification des prérequis..."
    
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker n'est pas installé"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo "❌ Docker Compose n'est pas installé"
        exit 1
    fi
    
    echo "✅ Prérequis OK"
    echo ""
}

# Fonction pour créer le réseau
create_network() {
    echo "🌐 Création du réseau..."
    docker network create idurar-network 2>/dev/null || echo "Réseau idurar-network existant"
    docker network create monitoring-network 2>/dev/null || echo "Réseau monitoring-network existant"
    echo "✅ Réseaux créés"
    echo ""
}

# Fonction pour démarrer l'app non-optimisée
start_non_optimized_app() {
    echo "🚀 Démarrage de l'app non-optimisée..."
    docker-compose up -d
    
    echo "⏳ Attente du démarrage (45s)..."
    sleep 45
    
    echo "📊 État des conteneurs:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep idurar
    echo ""
}

# Fonction pour démarrer Grafana
start_grafana() {
    echo "📊 Démarrage de Grafana..."
    docker-compose -f monitoring/docker-compose-grafana-non-optimized.yml up -d
    
    echo "⏳ Attente de Grafana (30s)..."
    sleep 30
    
    echo "📊 Services de monitoring:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(grafana|prometheus|cadvisor)"
    echo ""
}

# Fonction pour importer le dashboard
import_dashboard() {
    echo "📈 Import du dashboard..."
    
    # Attendre que Grafana soit prêt
    echo "⏳ Attente de Grafana (20s)..."
    sleep 20
    
    # Importer le dashboard
    curl -X POST -H "Content-Type: application/json" \
         -u "admin:admin123" \
         -d @monitoring/grafana/dashboards/non-optimized-complete.json \
         http://localhost:3000/api/dashboards/db 2>/dev/null
    
    echo "✅ Dashboard importé"
    echo ""
}

# Fonction pour afficher les URLs
show_urls() {
    echo "🌐 URLs D'ACCÈS"
    echo "==============="
    echo ""
    echo "📱 Application Non-Optimisée:"
    echo "   Frontend: http://localhost:3000"
    echo "   Backend:  http://localhost:5000"
    echo "   MongoDB:  localhost:27017"
    echo "   Portainer: http://localhost:9000"
    echo ""
    echo "📊 Monitoring:"
    echo "   Grafana: http://localhost:3000 (admin/admin123)"
    echo "   Prometheus: http://localhost:9090"
    echo "   cAdvisor: http://localhost:8080"
    echo ""
    echo "🎯 Dashboard: 'DevOps Project - Version Non-Optimisée (Complet)'"
    echo ""
}

# Fonction pour afficher les métriques
show_metrics() {
    echo "📊 MÉTRIQUES ACTUELLES"
    echo "====================="
    echo ""
    
    echo "📦 Conteneurs:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep idurar
    
    echo ""
    echo "📈 CPU Usage:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep idurar
    
    echo ""
    echo "💾 Memory Usage:"
    docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" | grep idurar
    
    echo ""
    echo "📏 Taille des images:"
    docker images | grep -E "(idurar|mongo|portainer)" | head -5
    echo ""
}

# Fonction pour monitoring continu
continuous_monitoring() {
    echo "🔄 MONITORING CONTINU (Ctrl+C pour arrêter)"
    echo "==========================================="
    echo ""
    
    while true; do
        clear
        echo "📊 MONITORING VERSION NON-OPTIMISÉE - $(date)"
        echo "=============================================="
        show_metrics
        
        echo "⏳ Prochaine mise à jour dans 10s..."
        sleep 10
    done
}

# Fonction pour nettoyer
cleanup() {
    echo "🧹 Nettoyage..."
    docker-compose down 2>/dev/null
    docker-compose -f monitoring/docker-compose-grafana-non-optimized.yml down 2>/dev/null
    echo "✅ Nettoyage terminé"
}

# Menu principal
echo "🎯 CHOISISSEZ UNE OPTION:"
echo "1. Configuration complète (app + Grafana)"
echo "2. Démarrer seulement l'app non-optimisée"
echo "3. Démarrer seulement Grafana"
echo "4. Afficher les métriques"
echo "5. Monitoring continu"
echo "6. Afficher les URLs"
echo "7. Nettoyer et arrêter"
echo "8. Quitter"
echo ""

read -p "Votre choix (1-8): " choice

case $choice in
    1)
        check_prerequisites
        create_network
        start_non_optimized_app
        start_grafana
        import_dashboard
        show_urls
        show_metrics
        echo "✅ Configuration complète terminée !"
        ;;
    2)
        check_prerequisites
        create_network
        start_non_optimized_app
        show_metrics
        ;;
    3)
        check_prerequisites
        create_network
        start_grafana
        import_dashboard
        show_urls
        ;;
    4)
        show_metrics
        ;;
    5)
        continuous_monitoring
        ;;
    6)
        show_urls
        ;;
    7)
        cleanup
        ;;
    8)
        echo "👋 Au revoir!"
        exit 0
        ;;
    *)
        echo "❌ Choix invalide"
        exit 1
        ;;
esac

echo "✅ Opération terminée!"
