#!/bin/bash

echo "🔍 Surveillance de Docker et de la stack Idurar..."

# Fonction pour vérifier si Docker fonctionne
check_docker() {
    docker info > /dev/null 2>&1
    return $?
}

# Fonction pour vérifier si la stack fonctionne
check_stack() {
    local services_ok=0
    local total_services=6
    
    curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "302\|200" && ((services_ok++))
    curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "307\|200" && ((services_ok++))
    curl -s -o /dev/null -w "%{http_code}" http://localhost:9090 | grep -q "302\|200" && ((services_ok++))
    curl -s -o /dev/null -w "%{http_code}" http://localhost:9100 | grep -q "200" && ((services_ok++))
    curl -s -o /dev/null -w "%{http_code}" http://localhost:5002 | grep -q "404\|200" && ((services_ok++))
    curl -s -o /dev/null -w "%{http_code}" http://localhost:3001 | grep -q "200" && ((services_ok++))
    
    echo "$services_ok/$total_services"
}

# Vérification initiale
echo "📊 État actuel:"

if check_docker; then
    echo "✅ Docker: En cours d'exécution"
    stack_status=$(check_stack)
    echo "📈 Stack Idurar: $stack_status services opérationnels"
    
    if [ "$stack_status" = "6/6" ]; then
        echo "🎉 Tous les services fonctionnent parfaitement !"
        echo ""
        echo "🌐 Accès aux dashboards:"
        echo "   • Grafana:         http://localhost:3000 (admin/admin123)"
        echo "   • cAdvisor:        http://localhost:8080"
        echo "   • Prometheus:      http://localhost:9090"
        echo "   • Frontend Idurar: http://localhost:3001"
        echo "   • Backend Idurar:  http://localhost:5002"
    else
        echo "⚠️  Certains services ne répondent pas"
        echo "🔄 Redémarrage de la stack..."
        ./start-idurar-monitoring.sh
    fi
else
    echo "❌ Docker: Arrêté"
    echo "🔄 Redémarrage automatique de Docker et de la stack..."
    ./start-docker-and-stack.sh
fi

echo ""
echo "💡 Pour éviter que Docker s'arrête:"
echo "   1. Gardez Docker Desktop ouvert"
echo "   2. Activez le démarrage automatique dans les préférences"
echo "   3. Utilisez ce script régulièrement: ./monitor-docker.sh"
