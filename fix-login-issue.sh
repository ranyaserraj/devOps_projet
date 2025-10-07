#!/bin/bash

echo "🔧 CORRECTION DU PROBLÈME DE LOGIN"
echo "=================================="

# Variables
FRONTEND_URL="http://localhost:3002"
BACKEND_URL="http://localhost:5001"
GRAFANA_URL="http://localhost:3000"

echo ""
echo "📊 1. Vérification des Services"
echo "==============================="

# Vérifier les conteneurs
echo "Conteneurs actifs:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | grep -E "(idurar|grafana|prometheus|cadvisor)"

echo ""
echo "📡 2. Test des Connexions"
echo "========================="

# Test frontend
echo "Frontend (http://localhost:3002):"
if curl -s "$FRONTEND_URL" | grep -q "IDURAR"; then
    echo "✅ Frontend accessible"
else
    echo "❌ Frontend non accessible"
fi

# Test backend
echo "Backend (http://localhost:5001):"
if curl -s "$BACKEND_URL/api/health" | grep -q "OK"; then
    echo "✅ Backend accessible"
else
    echo "❌ Backend non accessible"
fi

# Test Grafana
echo "Grafana (http://localhost:3000):"
if curl -s "$GRAFANA_URL" | grep -q "grafana\|login"; then
    echo "✅ Grafana accessible"
else
    echo "❌ Grafana non accessible"
fi

echo ""
echo "🔍 3. Diagnostic des Problèmes"
echo "==============================="

# Vérifier les logs backend
echo "Logs Backend (dernières 10 lignes):"
docker logs idurar-backend --tail 10

echo ""
echo "🔧 4. Solutions Recommandées"
echo "============================="

echo "✅ Services opérationnels:"
echo "   - Frontend: http://localhost:3002"
echo "   - Backend: http://localhost:5001"
echo "   - Grafana: http://localhost:3000 (admin/admin123)"
echo "   - Portainer: http://localhost:9000"

echo ""
echo "🎯 Pour tester le login:"
echo "1. Ouvrez http://localhost:3002"
echo "2. Cliquez sur 'Register' ou 'Sign Up'"
echo "3. Créez un nouveau compte"
echo "4. Connectez-vous avec ce compte"

echo ""
echo "📊 Pour voir les métriques:"
echo "1. Ouvrez http://localhost:3000"
echo "2. Connectez-vous avec admin/admin123"
echo "3. Cherchez les dashboards 'DevOps'"

echo ""
echo "🔧 Si le problème persiste:"
echo "1. Vérifiez les logs: docker logs idurar-backend"
echo "2. Redémarrez: docker-compose restart"
echo "3. Vérifiez la configuration réseau"

echo ""
echo "✅ Diagnostic terminé !"
