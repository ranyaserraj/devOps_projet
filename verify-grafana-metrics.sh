#!/bin/bash

echo "🔍 Vérification des métriques Grafana"
echo "===================================="
echo ""

# Vérifier que tous les services sont en cours d'exécution
echo "📊 État des services de monitoring:"
docker ps --filter "name=non-optimized" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Vérifier Node Exporter
echo "🔍 Vérification de Node Exporter:"
if curl -s http://localhost:9100/metrics > /dev/null; then
    echo "✅ Node Exporter fonctionne (Port 9100)"
else
    echo "❌ Node Exporter ne répond pas"
fi

# Vérifier Prometheus
echo "🔍 Vérification de Prometheus:"
if curl -s http://localhost:9090/api/v1/query?query=up > /dev/null; then
    echo "✅ Prometheus fonctionne (Port 9090)"
else
    echo "❌ Prometheus ne répond pas"
fi

# Vérifier Grafana
echo "🔍 Vérification de Grafana:"
if curl -s http://localhost:3000/api/health > /dev/null; then
    echo "✅ Grafana fonctionne (Port 3000)"
else
    echo "❌ Grafana ne répond pas"
fi

echo ""

# Vérifier les métriques système
echo "📈 Vérification des métriques système:"
echo "======================================="

# CPU
cpu_metrics=$(curl -s "http://localhost:9090/api/v1/query?query=node_cpu_seconds_total" | jq '.data.result | length' 2>/dev/null)
if [ "$cpu_metrics" -gt 0 ]; then
    echo "✅ Métriques CPU disponibles ($cpu_metrics métriques)"
else
    echo "❌ Métriques CPU non disponibles"
fi

# Mémoire
mem_metrics=$(curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemTotal_bytes" | jq '.data.result | length' 2>/dev/null)
if [ "$mem_metrics" -gt 0 ]; then
    echo "✅ Métriques mémoire disponibles ($mem_metrics métriques)"
else
    echo "❌ Métriques mémoire non disponibles"
fi

# Réseau
net_metrics=$(curl -s "http://localhost:9090/api/v1/query?query=node_network_receive_bytes_total" | jq '.data.result | length' 2>/dev/null)
if [ "$net_metrics" -gt 0 ]; then
    echo "✅ Métriques réseau disponibles ($net_metrics métriques)"
else
    echo "❌ Métriques réseau non disponibles"
fi

# Disque
disk_metrics=$(curl -s "http://localhost:9090/api/v1/query?query=node_disk_read_bytes_total" | jq '.data.result | length' 2>/dev/null)
if [ "$disk_metrics" -gt 0 ]; then
    echo "✅ Métriques disque disponibles ($disk_metrics métriques)"
else
    echo "❌ Métriques disque non disponibles"
fi

echo ""

# Afficher les métriques actuelles
echo "📊 Métriques actuelles du système:"
echo "================================="

# CPU Usage
cpu_usage=$(curl -s "http://localhost:9090/api/v1/query?query=100 - (avg by (instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)" | jq -r '.data.result[0].value[1]' 2>/dev/null)
if [ "$cpu_usage" != "null" ] && [ -n "$cpu_usage" ]; then
    echo "💻 CPU Usage: ${cpu_usage}%"
else
    echo "💻 CPU Usage: Non disponible"
fi

# Mémoire
mem_total=$(curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemTotal_bytes" | jq -r '.data.result[0].value[1]' 2>/dev/null)
mem_available=$(curl -s "http://localhost:9090/api/v1/query?query=node_memory_MemAvailable_bytes" | jq -r '.data.result[0].value[1]' 2>/dev/null)

if [ "$mem_total" != "null" ] && [ "$mem_available" != "null" ]; then
    mem_total_gb=$(echo "scale=2; $mem_total / 1024 / 1024 / 1024" | bc 2>/dev/null)
    mem_available_gb=$(echo "scale=2; $mem_available / 1024 / 1024 / 1024" | bc 2>/dev/null)
    mem_used_gb=$(echo "scale=2; $mem_total_gb - $mem_available_gb" | bc 2>/dev/null)
    echo "🧠 Mémoire: ${mem_used_gb}GB utilisés / ${mem_total_gb}GB total"
else
    echo "🧠 Mémoire: Non disponible"
fi

echo ""
echo "🌐 Accès aux dashboards:"
echo "========================"
echo "📊 Grafana: http://localhost:3000 (admin/admin123)"
echo "📈 Prometheus: http://localhost:9090"
echo "🔍 Node Exporter: http://localhost:9100"
echo ""
echo "🎯 Dashboard recommandé: 'DevOps Project - Métriques Système'"
echo ""
echo "✅ Vérification terminée !"
