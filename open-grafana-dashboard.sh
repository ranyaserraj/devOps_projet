#!/bin/bash

echo "🚀 Ouverture du Dashboard Grafana - DevOps Project"
echo "================================================="
echo ""

# Vérifier que Grafana est accessible
echo "🔍 Vérification de Grafana..."
if curl -s http://localhost:3000/api/health > /dev/null; then
    echo "✅ Grafana est accessible"
else
    echo "❌ Grafana n'est pas accessible. Démarrage en cours..."
    docker restart grafana-non-optimized
    sleep 10
fi

echo ""

# Vérifier que les métriques sont disponibles
echo "📊 Vérification des métriques..."
cpu_metrics=$(curl -s "http://localhost:9090/api/v1/query?query=node_cpu_seconds_total" | jq '.data.result | length' 2>/dev/null)
mem_metrics=$(curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemTotal_bytes" | jq '.data.result | length' 2>/dev/null)

if [ "$cpu_metrics" -gt 0 ] && [ "$mem_metrics" -gt 0 ]; then
    echo "✅ Métriques système disponibles"
    echo "   - CPU: $cpu_metrics métriques"
    echo "   - Mémoire: $mem_metrics métriques"
else
    echo "❌ Métriques système non disponibles"
    echo "   Redémarrage de Node Exporter..."
    docker restart node-exporter-non-optimized
    sleep 5
fi

echo ""

# Afficher les informations d'accès
echo "🌐 Accès au Dashboard:"
echo "======================"
echo "📊 URL: http://localhost:3000"
echo "👤 Username: admin"
echo "🔑 Password: admin123"
echo ""
echo "🎯 Dashboard recommandé:"
echo "   'DevOps Project - Métriques Système'"
echo ""
echo "📋 Navigation:"
echo "   1. Se connecter avec admin/admin123"
echo "   2. Aller dans 'Dashboards'"
echo "   3. Sélectionner 'DevOps Project - Métriques Système'"
echo ""

# Afficher les métriques actuelles
echo "📊 Métriques actuelles:"
echo "======================"

# CPU
cpu_usage=$(curl -s "http://localhost:9090/api/v1/query?query=100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)" | jq -r '.data.result[0].value[1]' 2>/dev/null)
if [ "$cpu_usage" != "null" ] && [ -n "$cpu_usage" ]; then
    echo "💻 CPU: ${cpu_usage}%"
else
    echo "💻 CPU: Calcul en cours..."
fi

# Mémoire
mem_total=$(curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemTotal_bytes" | jq -r '.data.result[0].value[1]' 2>/dev/null)
mem_available=$(curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemAvailable_bytes" | jq -r '.data.result[0].value[1]' 2>/dev/null)

if [ "$mem_total" != "null" ] && [ "$mem_available" != "null" ]; then
    mem_total_gb=$(echo "scale=2; $mem_total / 1024 / 1024 / 1024" | bc 2>/dev/null)
    mem_available_gb=$(echo "scale=2; $mem_available / 1024 / 1024 / 1024" | bc 2>/dev/null)
    mem_used_gb=$(echo "scale=2; $mem_total_gb - $mem_available_gb" | bc 2>/dev/null)
    echo "🧠 Mémoire: ${mem_used_gb}GB / ${mem_total_gb}GB"
else
    echo "🧠 Mémoire: Calcul en cours..."
fi

echo ""

# Ouvrir Grafana dans le navigateur
echo "🌐 Ouverture de Grafana dans le navigateur..."
echo "   URL: http://localhost:3000"
echo ""

# Attendre un peu pour que les métriques se stabilisent
echo "⏳ Attente de la stabilisation des métriques..."
sleep 3

# Ouvrir le navigateur
open http://localhost:3000 2>/dev/null || xdg-open http://localhost:3000 2>/dev/null || echo "Veuillez ouvrir http://localhost:3000 dans votre navigateur"

echo ""
echo "✅ Dashboard Grafana ouvert !"
echo "   - Les métriques se mettent à jour automatiquement"
echo "   - Rafraîchissement toutes les 5 secondes"
echo "   - Dashboard: 'DevOps Project - Métriques Système'"
