#!/bin/bash

echo "🔄 Surveillance continue de Docker et de la stack Idurar..."

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

# Boucle de surveillance
while true; do
    echo "🔍 Vérification $(date '+%H:%M:%S')..."
    
    if check_docker; then
        echo "✅ Docker: OK"
        stack_status=$(check_stack)
        echo "📈 Stack: $stack_status services"
        
        if [ "$stack_status" = "6/6" ]; then
            echo "🎉 Tout fonctionne parfaitement !"
        else
            echo "⚠️  Certains services ne répondent pas"
            echo "🔄 Redémarrage de la stack..."
            ./start-idurar-monitoring.sh
        fi
    else
        echo "❌ Docker arrêté - Redémarrage automatique..."
        ./start-docker-and-stack.sh
    fi
    
    echo "⏳ Attente de 30 secondes avant la prochaine vérification..."
    sleep 30
done
