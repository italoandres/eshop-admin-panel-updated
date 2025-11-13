require('dotenv').config();
const mongoose = require('mongoose');
const Banner = require('../models/Banner');

const seedBanners = [
  {
    storeId: 'store_001',
    title: 'Black Friday - 100 Milhões em Cupons',
    imageUrl: 'https://http2.mlstatic.com/D_NQ_NP_2X_933830-MLA80046906138_102024-OO.webp',
    targetUrl: 'https://www.mercadolivre.com.br/ofertas',
    order: 1,
    active: true,
    startAt: null,
    endAt: null,
  },
  {
    storeId: 'store_001',
    title: 'Meli+ Mega - 4 Streamings por R$ 39,90',
    imageUrl: 'https://http2.mlstatic.com/D_NQ_NP_2X_664457-MLA79903685225_102024-OO.webp',
    targetUrl: 'https://www.mercadolivre.com.br/meli-mais',
    order: 2,
    active: true,
    startAt: null,
    endAt: null,
  },
  {
    storeId: 'store_001',
    title: 'Ofertas Especiais - Até 70% OFF',
    imageUrl: 'https://http2.mlstatic.com/D_NQ_NP_2X_795023-MLA79903685227_102024-OO.webp',
    targetUrl: 'https://www.mercadolivre.com.br/ofertas',
    order: 3,
    active: true,
    startAt: null,
    endAt: null,
  },
];

async function seed() {
  try {
    console.log('🌱 Conectando ao MongoDB...');
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('✅ Conectado!');

    console.log('🗑️  Limpando banners existentes...');
    await Banner.deleteMany({ storeId: 'store_001' });

    console.log('📝 Inserindo banners de teste...');
    const banners = await Banner.insertMany(seedBanners);

    console.log(`✅ ${banners.length} banners inseridos com sucesso!`);
    console.log('\n📋 Banners criados:');
    banners.forEach((banner, index) => {
      console.log(`  ${index + 1}. ${banner.title} (ID: ${banner._id})`);
    });

    console.log('\n🎉 Seed concluído com sucesso!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Erro ao fazer seed:', error);
    process.exit(1);
  }
}

seed();
