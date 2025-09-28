# IDURAR ERP CRM - Docker Setup

Ce guide vous explique comment exécuter l'application IDURAR ERP CRM avec Docker.

## Prérequis

- Docker Desktop installé
- Docker Compose installé

## Démarrage rapide

1. **Cloner le projet** (déjà fait)
```bash
git clone https://github.com/idurar/idurar-erp-crm.git
cd idurar-erp-crm
```

2. **Configurer les variables d'environnement**
```bash
# Copier le fichier de configuration
cp docker.env .env
```

3. **Lancer tous les services**
```bash
docker-compose up -d
```

## Services inclus

- **MongoDB**: Base de données sur le port 27017
- **Backend**: API Node.js sur le port 5000
- **Frontend**: Interface React sur le port 3000

## Accès à l'application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000
- **MongoDB**: localhost:27017

## Commandes utiles

```bash
# Voir les logs
docker-compose logs -f

# Arrêter les services
docker-compose down

# Redémarrer un service spécifique
docker-compose restart backend

# Reconstruire les images
docker-compose build --no-cache

# Supprimer tous les volumes (ATTENTION: supprime les données)
docker-compose down -v
```

## Configuration

Modifiez le fichier `docker.env` pour personnaliser:
- Mots de passe de la base de données
- Clés JWT
- Configuration email
- Configuration AWS S3

## Dépannage

Si vous rencontrez des problèmes:

1. Vérifiez que Docker Desktop est démarré
2. Vérifiez les logs: `docker-compose logs`
3. Redémarrez les services: `docker-compose restart`
4. Reconstruisez les images: `docker-compose build --no-cache`

