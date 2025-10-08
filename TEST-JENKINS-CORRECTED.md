# 🧪 Guide de Test des Jenkinsfiles Corrigés

## 🎯 Objectif

Vérifier que les builds Jenkins s'exécutent maintenant pendant **~18 minutes** (au lieu de 25s-1m29s).

---

## ⚡ Test Rapide (5 minutes)

### 1️⃣ **Démarrez MongoDB (Requis pour les services)**

```powershell
# Depuis le répertoire du projet
cd C:\Users\pc\Desktop\idurar-erp-crm\idurar-erp-crm

# Démarrez MongoDB avec Docker
docker-compose up -d mongodb
```

**Vérification :**
```powershell
docker ps | findstr mongo
# Doit afficher un conteneur MongoDB actif
```

---

### 2️⃣ **Accédez à Jenkins**

```
URL: http://localhost:8080
```

---

### 3️⃣ **Lancez le Build Standard**

1. Cliquez sur **`devOps_projet`**
2. Cliquez sur **"Build Now"** (▶️)
3. Surveillez la progression dans **"Build History"**

**Attendu :**
- ⏱️ Durée : **~18 minutes** (au lieu de 25s)
- 🟢 Statut : **Success** (vert)

---

### 4️⃣ **Lancez le Build Optimisé**

1. Cliquez sur **`devOps_projet_optimise`**
2. Cliquez sur **"Build Now"** (▶️)
3. Surveillez la progression

**Attendu :**
- ⏱️ Durée : **~18 minutes** (au lieu de 1m29s)
- 🟢 Statut : **Success** (vert)

---

### 5️⃣ **Vérifiez les Console Logs**

**Pour chaque build, cliquez sur le numéro de build → "Console Output"**

**Recherchez ces lignes clés :**

```
✅ "Backend started with PID: [nombre]"
✅ "Frontend started with PID: [nombre]"
✅ "Waiting for services to initialize"
✅ "Backend accessible via localhost:5000"
✅ "Frontend accessible via localhost:3000"
✅ "Running Backend API Tests..."
✅ "Running Frontend Tests..."
✅ "Running Performance Tests..."
✅ "All tests passed successfully!"
✅ "Cleanup completed"
```

**Si vous voyez :**
```
❌ "Backend not accessible"
❌ "Frontend not accessible"
```

**→ Consultez la section "Dépannage" ci-dessous**

---

## 📊 Comparaison Avant/Après

| Build | Durée AVANT | Durée APRÈS | Tests Exécutés |
|-------|-------------|-------------|----------------|
| **Standard** | 25s ❌ | ~18 min ✅ | Tous (7 stages) |
| **Optimisé** | 1m29s ❌ | ~18 min ✅ | Tous (parallèle) |

---

## 🔍 Vérifications Détaillées

### **A. Vérifier que les Services Démarrent**

**Dans la Console Output, recherchez :**

```
[Start Services] ou [Start Application Services]
Starting backend service...
npm install --production
Backend started with PID: 12345

Starting frontend service...
npm install --production
Frontend started with PID: 67890

Waiting for services to initialize (30 seconds)...
Services startup initiated
```

**Indicateur de succès :** Les PIDs sont affichés

---

### **B. Vérifier le Network Connectivity Check**

```
[Network Connectivity Check]
Testing connectivity to backend...
Testing localhost:5000...
✅ Backend accessible via localhost:5000

Testing connectivity to frontend...
Testing localhost:3000...
✅ Frontend accessible via localhost:3000

🌐 Using hosts: Backend=localhost, Frontend=localhost
```

**Indicateur de succès :** Les deux services sont "accessible"

---

### **C. Vérifier l'Exécution des Tests**

**Standard :**
```
[Backend Tests] Running Backend API Tests...
[Frontend Tests] Running Frontend Tests...
[Performance Tests] Running Performance Tests...
[Heavy Performance Tests] Running Heavy Performance Tests...
[Integration Tests] Running Integration Tests...
[Unit Tests] Running Unit Tests...
[Full Test Suite] Running Complete Test Suite...
```

**Optimisé :**
```
[Parallel Test Execution]
  [Critical Tests] Running Backend and Frontend tests in parallel...
  [Performance Tests] Running Performance tests in parallel...
  [Integration Tests] Running Integration tests in parallel...
  [Unit Tests] Running Unit tests in parallel...
[Optimized Parallel Tests] Running with 8 workers...
[Complete Test Suite] Running parallel test runner...
```

**Indicateur de succès :** Tous les stages apparaissent et affichent "✅ ... completed"

---

### **D. Vérifier le Cleanup**

**À la fin du build (post section) :**

```
[Post Processing]
🧹 Cleaning up services...
Backend service already stopped (ou kill success)
Frontend service already stopped (ou kill success)
✅ Cleanup completed
```

**Vérification manuelle après le build :**
```powershell
# Vérifiez qu'aucun processus npm ne reste actif
tasklist | findstr "node.exe"

# Si vous voyez des processus npm start ou npm run dev, ils doivent être liés à Docker, pas à Jenkins
```

---

## 🌐 Vérification du Monitoring Énergétique

### **1. Prometheus**

```
URL: http://localhost:9090
```

**Requête à tester :**
```promql
jenkins_build_duration_seconds
```

**Attendu :** Vous devriez voir des valeurs autour de **1000-1200 secondes** (16-20 minutes)

---

### **2. Grafana**

```
URL: http://localhost:3001
Login: admin / admin
```

**Dashboard :** "Jenkins Energy Monitoring"

**Métriques à vérifier :**
- **Build Duration** : ~18 minutes (1080s)
- **Energy Consumption** : ~30 Wh
- **Carbon Footprint** : ~15g CO₂

---

## 🚨 Dépannage

### Problème 1 : Build toujours court (<2 min)

**Cause probable :** MongoDB ou Node.js non disponible

**Solutions :**

```powershell
# 1. Vérifiez MongoDB
docker ps | findstr mongo

# Si MongoDB n'est pas actif :
cd C:\Users\pc\Desktop\idurar-erp-crm\idurar-erp-crm
docker-compose up -d mongodb

# 2. Vérifiez Node.js sur la machine Jenkins
node --version
npm --version

# Si Node.js n'est pas installé :
# Téléchargez et installez Node.js 18 ou 20 depuis https://nodejs.org
```

---

### Problème 2 : "Backend not accessible"

**Cause probable :** Backend ne démarre pas correctement

**Solutions :**

```powershell
# 1. Consultez les logs backend
cd C:\Users\pc\Desktop\idurar-erp-crm\idurar-erp-crm
type backend.log

# 2. Testez le démarrage manuel
cd backend
npm install --production
npm start

# 3. Si erreur MongoDB :
# Vérifiez la chaîne de connexion dans backend/src/config/database.js
# Doit pointer vers localhost:27017 ou le bon host MongoDB
```

---

### Problème 3 : "Frontend not accessible"

**Cause probable :** Frontend ne démarre pas

**Solutions :**

```powershell
# 1. Consultez les logs frontend
type frontend.log

# 2. Testez le démarrage manuel
cd frontend
npm install --production
npm run dev

# 3. Vérifiez Vite
# Le frontend utilise Vite, qui peut nécessiter des dépendances spécifiques
npm list vite
```

---

### Problème 4 : Tests échouent

**Cause probable :** Services OK mais tests mal configurés

**Solutions :**

```powershell
# 1. Vérifiez les dépendances de test
cd tests
npm install

# 2. Testez manuellement un test
$env:API_URL="http://localhost:5000"
$env:FRONTEND_URL="http://localhost:3000"
node backend-baseline-robust.test.js

# 3. Si erreur de connexion :
# Les tests nécessitent que backend et frontend soient actifs
# Relancez-les manuellement (voir ci-dessus)
```

---

### Problème 5 : Processus orphelins après build

**Cause probable :** Cleanup ne fonctionne pas

**Solutions :**

```powershell
# 1. Tuez manuellement les processus
taskkill /F /IM node.exe

# 2. Nettoyez les fichiers temporaires
cd C:\Users\pc\Desktop\idurar-erp-crm\idurar-erp-crm
del *.pid
del *.log
del *_host.txt

# 3. Vérifiez le Jenkinsfile
# Le post { always } block doit contenir le cleanup sh script
```

---

## ✅ Checklist de Validation Finale

- [ ] **MongoDB actif** : `docker ps | findstr mongo`
- [ ] **Build Standard** : Durée ~18 minutes, Status Success
- [ ] **Build Optimisé** : Durée ~18 minutes, Status Success
- [ ] **Console Logs** : "Backend accessible" et "Frontend accessible"
- [ ] **Tests exécutés** : Tous les stages de tests apparaissent
- [ ] **Cleanup** : "Cleanup completed" dans les logs
- [ ] **Prometheus** : Métriques `jenkins_build_duration_seconds` ~1080s
- [ ] **Grafana** : Dashboard affiche les métriques du build
- [ ] **Pas de processus orphelins** : `tasklist | findstr node` (seulement Docker)

---

## 🎉 Succès !

**Si toutes les vérifications passent :**

✅ Vos Jenkinsfiles sont correctement configurés
✅ Les services démarrent automatiquement
✅ Tous les tests s'exécutent
✅ Le cleanup fonctionne
✅ Le monitoring énergétique est opérationnel

**Prochaines étapes :**
1. Comparez les métriques énergétiques (Standard vs Optimisé)
2. Analysez les graphiques dans Grafana
3. Documentez les gains Green DevOps
4. Intégrez à votre workflow CI/CD

---

## 📞 Besoin d'Aide ?

**Si le problème persiste :**

1. **Consultez les logs complets** :
   - Jenkins Console Output
   - `backend.log`
   - `frontend.log`
   - Logs Docker : `docker logs [container_id]`

2. **Vérifiez l'environnement** :
   - Node.js : `node --version` (18+ requis)
   - npm : `npm --version` (8+ requis)
   - Docker : `docker --version`
   - MongoDB : `docker ps | findstr mongo`

3. **Testez manuellement** :
   - Backend : `cd backend && npm start`
   - Frontend : `cd frontend && npm run dev`
   - Tests : `cd tests && node backend-baseline-robust.test.js`

---

**Bonne chance avec vos builds ! 🚀**

