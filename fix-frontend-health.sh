#!/bin/bash

echo "🔧 Correction du problème de health check du frontend"
echo "=================================================="
echo ""

# Arrêter le conteneur frontend
echo "📦 Arrêt du conteneur frontend..."
docker stop idurar-frontend 2>/dev/null || echo "Conteneur déjà arrêté"

# Supprimer le conteneur frontend
echo "🗑️ Suppression du conteneur frontend..."
docker rm idurar-frontend 2>/dev/null || echo "Conteneur déjà supprimé"

# Reconstruire l'image frontend avec curl
echo "🔨 Reconstruction de l'image frontend avec curl..."
docker build -t devops_projet-frontend ./frontend

# Redémarrer le conteneur frontend
echo "🚀 Redémarrage du conteneur frontend..."
docker-compose up -d frontend

# Attendre que le conteneur démarre
echo "⏳ Attente du démarrage du conteneur..."
sleep 10

# Vérifier le statut du conteneur
echo "📊 Vérification du statut du conteneur:"
docker ps --filter "name=idurar-frontend" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Vérifier les logs du conteneur
echo ""
echo "📋 Logs du conteneur frontend:"
docker logs --tail 10 idurar-frontend

echo ""
echo "✅ Correction terminée !"
echo "   - curl installé dans le conteneur frontend"
echo "   - Health check devrait maintenant fonctionner"
echo "   - Le conteneur devrait passer de 'unhealthy' à 'healthy'"
