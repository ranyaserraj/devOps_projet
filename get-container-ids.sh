#!/bin/bash

echo "🔍 RÉCUPÉRATION DES IDs DES CONTENEURS DEVOPS"
echo "============================================="
echo ""

# Obtenir les IDs des conteneurs DevOps
echo "📦 Conteneurs DevOps:"
docker ps --format "{{.Names}}\t{{.ID}}" | grep idurar

echo ""
echo "🔍 Recherche des IDs complets dans Prometheus..."

# Attendre que les métriques soient disponibles
sleep 10

# Rechercher les IDs complets
echo "📊 IDs trouvés dans Prometheus:"
curl -s "http://localhost:9090/api/v1/query?query=container_cpu_usage_seconds_total" | jq -r '.data.result[] | .metric.id' | grep -E "(9ee70a037896|3227c3249243|b6b1f44c7bf7|d7de7f419b87)" | head -10

echo ""
echo "✅ IDs récupérés !"
