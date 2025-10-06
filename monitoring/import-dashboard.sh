#!/bin/bash

# Script pour importer le dashboard dans Grafana
echo "Importation du dashboard DevOps Containers..."

# Attendre que Grafana soit prêt
sleep 10

# URL de l'API Grafana
GRAFANA_URL="http://localhost:3000"
USER="admin"
PASSWORD="admin123"

# Créer le dashboard via l'API
curl -X POST \
  -H "Content-Type: application/json" \
  -u "$USER:$PASSWORD" \
  -d @grafana/dashboards/devops-containers.json \
  "$GRAFANA_URL/api/dashboards/db"

echo "Dashboard importé avec succès!"
echo "Accédez à Grafana: http://localhost:3000"
echo "Identifiants: admin / admin123"
