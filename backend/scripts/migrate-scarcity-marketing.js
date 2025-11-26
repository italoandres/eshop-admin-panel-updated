// Script para adicionar campo scarcityMarketing em produtos existentes
const mongoose = require('mongoose');
const Product = require('../models/Product');

// Conectar ao MongoDB
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb+srv://italoandres:Italo2001@cluster0.aqvqo.mongodb.net/ecommerce?retryWrites=true&w=majority&appName=Cluster0';

async function migrateScarcityMarketing() {
  try {
    console.log('🔄 Conectando ao MongoDB...');
    await mongoose.connect(MONGODB_URI);
    console.log('✅ Conectado!');

    console.log('🔄 Buscando produtos sem scarcityMarketing...');
    const products = await Product.find({
      $or: [
        { scarcityMarketing: { $exists: false } },
        { scarcityMarketing: null }
      ]
    });

    console.log(`📦 Encontrados ${products.length} produtos para atualizar`);

    if (products.length === 0) {
      console.log('✅ Todos os produtos já têm scarcityMarketing!');
      process.exit(0);
    }

    // Atualizar cada produto
    for (const product of products) {
      product.scarcityMarketing = {
        enabled: false,
        unitsLeft: 10
      };
      await product.save();
      console.log(`✅ Atualizado: ${product.name}`);
    }

    console.log(`🎉 Migração completa! ${products.length} produtos atualizados.`);
    process.exit(0);
  } catch (error) {
    console.error('❌ Erro na migração:', error);
    process.exit(1);
  }
}

migrateScarcityMarketing();
