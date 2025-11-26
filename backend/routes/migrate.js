const express = require('express');
const router = express.Router();
const Product = require('../models/Product');

// Endpoint para migrar scarcityMarketing
router.post('/scarcity-marketing', async (req, res) => {
  try {
    console.log('🔄 Iniciando migração de scarcityMarketing...');

    // Buscar produtos sem scarcityMarketing
    const products = await Product.find({
      $or: [
        { scarcityMarketing: { $exists: false } },
        { scarcityMarketing: null }
      ]
    });

    console.log(`📦 Encontrados ${products.length} produtos para atualizar`);

    if (products.length === 0) {
      return res.json({ 
        message: 'Todos os produtos já têm scarcityMarketing!',
        updated: 0
      });
    }

    // Atualizar cada produto
    let updated = 0;
    for (const product of products) {
      product.scarcityMarketing = {
        enabled: false,
        unitsLeft: 10
      };
      await product.save();
      updated++;
      console.log(`✅ Atualizado: ${product.name}`);
    }

    res.json({ 
      message: `Migração completa! ${updated} produtos atualizados.`,
      updated
    });
  } catch (error) {
    console.error('❌ Erro na migração:', error);
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
