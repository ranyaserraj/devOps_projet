#!/bin/bash

echo "🚀 Démarrage rapide de la stack Idurar avec monitoring..."

# Fonction pour vérifier si Docker fonctionne
check_docker() {
    docker info > /dev/null 2>&1
    return $?
}

# Fonction pour démarrer Docker Desktop
start_docker() {
    echo "🔄 Démarrage de Docker Desktop..."
    open -a Docker
    
    echo "⏳ Attente du démarrage de Docker Desktop..."
    local attempts=0
    local max_attempts=20
    
    while [ $attempts -lt $max_attempts ]; do
        if check_docker; then
            echo "✅ Docker Desktop est maintenant en cours d'exécution"
            return 0
        fi
        
        echo "⏳ Tentative $((attempts + 1))/$max_attempts - Attente..."
        sleep 3
        attempts=$((attempts + 1))
    done
    
    echo "❌ Docker Desktop n'a pas pu démarrer dans les temps"
    return 1
}

# Vérifier si Docker fonctionne
if check_docker; then
    echo "✅ Docker est déjà en cours d'exécution"
else
    echo "❌ Docker n'est pas en cours d'exécution"
    start_docker
    if [ $? -ne 0 ]; then
        echo "❌ Impossible de démarrer Docker. Veuillez le démarrer manuellement."
        exit 1
    fi
fi

# Attendre un peu pour que Docker soit complètement prêt
echo "⏳ Attente que Docker soit complètement prêt..."
sleep 5

# Démarrer la stack Idurar
echo "🚀 Démarrage de la stack Idurar avec monitoring..."
cd /Users/HouDa/devOps_projet
docker-compose -f docker-compose-monitoring.yml up -d

# Attendre que les services soient prêts
echo "⏳ Attente du démarrage des services..."
sleep 20

# Vérifier le statut
echo "🔍 Vérification du statut des services..."
docker-compose -f docker-compose-monitoring.yml ps

echo ""
echo "🎉 Stack Idurar avec monitoring démarrée !"
echo ""
echo "🌐 Accès aux services:"
echo "   • Grafana:         http://localhost:3000 (admin/admin123)"
echo "   • cAdvisor:        http://localhost:8080"
echo "   • Prometheus:      http://localhost:9090"
echo "   • Frontend Idurar: http://localhost:3001"
echo "   • Backend Idurar:  http://localhost:5002"
echo ""
echo "💡 Pour éviter que Docker s'arrête:"
echo "   1. Gardez Docker Desktop ouvert"
echo "   2. Activez le démarrage automatique dans les préférences"
echo "   3. Utilisez ce script si Docker s'arrête: ./quick-start.sh"
