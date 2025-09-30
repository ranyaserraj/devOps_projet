#!/bin/bash

# Script de comparaison des versions Docker optimisées vs non-optimisées
# Usage: ./compare-docker-versions.sh

echo "🔍 Comparaison des versions Docker - IDURAR ERP CRM"
echo "=================================================="

# Fonction pour mesurer les ressources
measure_resources() {
    local compose_file=$1
    local version_name=$2
    
    echo "📊 Mesure des ressources pour $version_name..."
    
    # Attendre que les conteneurs soient prêts
    sleep 10
    
    # Mesurer les ressources
    docker stats --no-stream --format "{{.Container}},{{.CPUPerc}},{{.MemUsage}},{{.MemPerc}}" $(docker-compose -f $compose_file ps -q) > /tmp/resources_$version_name.txt
    
    # Mesurer les performances
    local backend_port=$(docker-compose -f $compose_file ps | grep backend | awk '{print $NF}' | cut -d: -f2 | cut -d- -f1)
    local frontend_port=$(docker-compose -f $compose_file ps | grep frontend | awk '{print $NF}' | cut -d: -f2 | cut -d- -f1)
    
    if [ ! -z "$backend_port" ]; then
        curl -s -w "%{time_total}" http://localhost:$backend_port/api/health -o /dev/null > /tmp/backend_perf_$version_name.txt
    fi
    
    if [ ! -z "$frontend_port" ]; then
        curl -s -w "%{time_total}" http://localhost:$frontend_port -o /dev/null > /tmp/frontend_perf_$version_name.txt
    fi
}

# Fonction pour afficher les résultats
show_results() {
    echo ""
    echo "📈 RÉSULTATS DE LA COMPARAISON"
    echo "=============================="
    
    echo ""
    echo "💾 UTILISATION MÉMOIRE:"
    echo "----------------------"
    echo "Non-optimisé:"
    cat /tmp/resources_non_optimized.txt | while IFS=',' read container cpu mem mem_perc; do
        echo "  - $container: $mem ($mem_perc)"
    done
    
    echo ""
    echo "Optimisé:"
    cat /tmp/resources_optimized.txt | while IFS=',' read container cpu mem mem_perc; do
        echo "  - $container: $mem ($mem_perc)"
    done
    
    echo ""
    echo "⚡ PERFORMANCES:"
    echo "---------------"
    echo "Backend API:"
    echo "  - Non-optimisé: $(cat /tmp/backend_perf_non_optimized.txt 2>/dev/null || echo 'N/A')s"
    echo "  - Optimisé: $(cat /tmp/backend_perf_optimized.txt 2>/dev/null || echo 'N/A')s"
    
    echo ""
    echo "Frontend:"
    echo "  - Non-optimisé: $(cat /tmp/frontend_perf_non_optimized.txt 2>/dev/null || echo 'N/A')s"
    echo "  - Optimisé: $(cat /tmp/frontend_perf_optimized.txt 2>/dev/null || echo 'N/A')s"
}

# Nettoyer les fichiers temporaires
cleanup() {
    rm -f /tmp/resources_*.txt /tmp/*_perf_*.txt
}

# Gestion des signaux
trap cleanup EXIT

echo ""
echo "🚀 Test des conteneurs NON-OPTIMISÉS..."
echo "======================================"

# Arrêter les conteneurs optimisés s'ils sont en cours
docker-compose -f docker-compose-optimized.yml down 2>/dev/null

# Lancer les conteneurs non-optimisés
docker-compose -f docker-compose-houda.yml up -d

# Mesurer les ressources
measure_resources "docker-compose-houda.yml" "non_optimized"

echo ""
echo "🛑 Arrêt des conteneurs non-optimisés..."
docker-compose -f docker-compose-houda.yml down

echo ""
echo "🚀 Test des conteneurs OPTIMISÉS..."
echo "=================================="

# Lancer les conteneurs optimisés
docker-compose -f docker-compose-optimized.yml up -d

# Mesurer les ressources
measure_resources "docker-compose-optimized.yml" "optimized"

# Afficher les résultats
show_results

echo ""
echo "✅ Comparaison terminée!"
echo "📄 Rapport détaillé disponible dans: COMPARISON-REPORT.md"

# Arrêter les conteneurs optimisés
docker-compose -f docker-compose-optimized.yml down
