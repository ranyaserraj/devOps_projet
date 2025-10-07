#!/bin/bash

echo "📊 MONITORING VERSION NON-OPTIMISÉE"
echo "=================================="
echo ""

# Fonction pour afficher les métriques
show_metrics() {
    echo "🔍 MÉTRIQUES EN TEMPS RÉEL"
    echo "-------------------------"
    
    echo "📦 Conteneurs actifs:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep idurar
    
    echo ""
    echo "📈 Utilisation CPU:"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep idurar
    
    echo ""
    echo "💾 Utilisation mémoire:"
    docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" | grep idurar
    
    echo ""
    echo "🌐 Test de connectivité:"
    
    # Test MongoDB
    timeout 3 bash -c "</dev/tcp/localhost/27017" 2>/dev/null && echo "✅ MongoDB (27017) - OK" || echo "❌ MongoDB (27017) - KO"
    
    # Test Backend
    timeout 3 bash -c "</dev/tcp/localhost/5000" 2>/dev/null && echo "✅ Backend (5000) - OK" || echo "❌ Backend (5000) - KO"
    
    # Test Frontend
    timeout 3 bash -c "</dev/tcp/localhost/3000" 2>/dev/null && echo "✅ Frontend (3000) - OK" || echo "❌ Frontend (3000) - KO"
    
    # Test Portainer
    timeout 3 bash -c "</dev/tcp/localhost/9000" 2>/dev/null && echo "✅ Portainer (9000) - OK" || echo "❌ Portainer (9000) - KO"
    
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

# Fonction pour exporter les métriques
export_metrics() {
    local filename="metrics-non-optimized-$(date +%Y%m%d-%H%M%S).txt"
    
    echo "📤 EXPORT DES MÉTRIQUES"
    echo "====================="
    echo "Fichier: $filename"
    echo ""
    
    {
        echo "=== MÉTRIQUES VERSION NON-OPTIMISÉE ==="
        echo "Date: $(date)"
        echo ""
        
        echo "=== CONTENEURS ==="
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep idurar
        echo ""
        
        echo "=== CPU USAGE ==="
        docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep idurar
        echo ""
        
        echo "=== MEMORY USAGE ==="
        docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" | grep idurar
        echo ""
        
        echo "=== IMAGES SIZES ==="
        docker images | grep -E "(idurar|mongo|portainer)" | head -10
        echo ""
        
        echo "=== SYSTEM INFO ==="
        echo "Docker version: $(docker --version)"
        echo "System: $(uname -a)"
        echo ""
        
    } > "$filename"
    
    echo "✅ Métriques exportées vers: $filename"
}

# Menu principal
echo "🎯 CHOISISSEZ UNE OPTION:"
echo "1. Afficher les métriques une fois"
echo "2. Monitoring continu"
echo "3. Exporter les métriques"
echo "4. Démarrer l'app non-optimisée"
echo "5. Arrêter l'app non-optimisée"
echo "6. Quitter"
echo ""

read -p "Votre choix (1-6): " choice

case $choice in
    1)
        show_metrics
        ;;
    2)
        continuous_monitoring
        ;;
    3)
        export_metrics
        ;;
    4)
        echo "🚀 Démarrage de l'app non-optimisée..."
        docker-compose up -d
        echo "⏳ Attente du démarrage (30s)..."
        sleep 30
        show_metrics
        ;;
    5)
        echo "🛑 Arrêt de l'app non-optimisée..."
        docker-compose down
        echo "✅ App arrêtée"
        ;;
    6)
        echo "👋 Au revoir!"
        exit 0
        ;;
    *)
        echo "❌ Choix invalide"
        exit 1
        ;;
esac

echo "✅ Opération terminée!"
