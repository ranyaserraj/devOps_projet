const mongoose = require('mongoose');

// Configuration de la base de données
const MONGODB_URI = 'mongodb://admin:password123@mongodb:27017/idurar_erp_crm?authSource=admin';

// Modèles (simplifiés pour l'initialisation)
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

async function createAdminUser() {
  try {
    // Connexion à MongoDB
    await mongoose.connect(MONGODB_URI);
    console.log('✅ Connexion à MongoDB réussie');

    // Vérifier si l'admin existe déjà
    const existingAdmin = await Admin.findOne({ email: 'admin@admin.com' });
    if (existingAdmin) {
      console.log('⚠️ Utilisateur admin existe déjà');
      return;
    }

    // Créer l'utilisateur admin
    const admin = new Admin({
      name: 'Admin User',
      email: 'admin@admin.com',
      isActive: true
    });

    await admin.save();
    console.log('✅ Utilisateur admin créé');

    // Créer le mot de passe (hash simple pour le test)
    const bcrypt = require('bcrypt');
    const hashedPassword = await bcrypt.hash('admin123', 10);

    const adminPassword = new AdminPassword({
      admin: admin._id,
      password: hashedPassword
    });

    await adminPassword.save();
    console.log('✅ Mot de passe admin créé');

    console.log('🎯 Utilisateur admin créé avec succès !');
    console.log('📧 Email: admin@admin.com');
    console.log('🔑 Password: admin123');

  } catch (error) {
    console.error('❌ Erreur:', error.message);
  } finally {
    await mongoose.disconnect();
    console.log('🔌 Déconnexion de MongoDB');
  }
}

createAdminUser();
