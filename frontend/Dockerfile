# Frontend Dockerfile pour IDURAR ERP CRM
FROM node:20.9.0-alpine

# Installer curl pour les health checks
RUN apk add --no-cache curl

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm ci

# Copier le code source
COPY . .

# Exposer le port
EXPOSE 3000

# Commande par défaut
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

