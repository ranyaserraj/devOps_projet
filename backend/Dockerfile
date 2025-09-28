# Backend Dockerfile pour IDURAR ERP CRM
FROM node:20.9.0-alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package*.json ./

# Installer les dépendances
RUN npm ci --only=production

# Copier le code source
COPY . .

# Exposer le port
EXPOSE 5000

# Commande par défaut
CMD ["npm", "start"]
