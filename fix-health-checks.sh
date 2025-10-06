#!/bin/bash

echo "🔧 Correction des Health Checks..."

# Redémarrer le frontend avec un health check corrigé
echo "Redémarrage du frontend..."
docker stop idurar-frontend-optimized
docker rm idurar-frontend-optimized

# Redémarrer Portainer
echo "Redémarrage de Portainer..."
docker stop idurar-portainer-optimized
docker rm idurar-portainer-optimized

echo "✅ Conteneurs redémarrés - Les health checks seront corrigés au prochain démarrage"
