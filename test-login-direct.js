const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

// Configuration de la base de données
const MONGODB_URI = 'mongodb://admin:password123@localhost:27017/idurar_erp_crm?authSource=admin';

// Modèles
const AdminSchema = new mongoose.Schema({
  name: String,
  email: String,
  isActive: { type: Boolean, default: true },
  createdAt: { type: Date, default: Date.now }
});

const AdminPasswordSchema = new mongoose.Schema({
  admin: { type: mongoose.Schema.Types.ObjectId, ref: 'Admin' },
  password: String,
  createdAt: { type: Date, default: Date.now }
});

const Admin = mongoose.model('Admin', AdminSchema);
const AdminPassword = mongoose.model('AdminPassword', AdminPasswordSchema);

async function testLogin() {
  try {
    // Connexion à MongoDB
    await mongoose.connect(MONGODB_URI);
    console.log('✅ Connexion à MongoDB réussie');

    // Vérifier l'utilisateur admin
    const admin = await Admin.findOne({ email: 'admin@admin.com' });
    if (!admin) {
      console.log('❌ Utilisateur admin non trouvé');
      return;
    }
    console.log('✅ Utilisateur admin trouvé:', admin.email);

    // Vérifier le mot de passe
    const adminPassword = await AdminPassword.findOne({ admin: admin._id });
    if (!adminPassword) {
      console.log('❌ Mot de passe admin non trouvé');
      return;
    }
    console.log('✅ Mot de passe admin trouvé');

    // Tester le hash du mot de passe
    const isValid = await bcrypt.compare('admin123', adminPassword.password);
    if (isValid) {
      console.log('✅ Mot de passe valide');
    } else {
      console.log('❌ Mot de passe invalide');
    }

    console.log('🎯 Test de login terminé !');

  } catch (error) {
    console.error('❌ Erreur:', error.message);
  } finally {
    await mongoose.disconnect();
    console.log('🔌 Déconnexion de MongoDB');
  }
}

testLogin();
