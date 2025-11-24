const Product = require('../models/Product');
const { uploadImage, uploadMultipleImages, isBase64Image } = require('../services/cloudinaryService');

// Listar produtos com filtros
exports.getAllProducts = async (req, res) => {
  try {
    const { 
      keyword = '',
      pageSize = 20,
      page = 1,
      categories = '[]',
      featuredSection = '' // novo parâmetro
    } = req.query;

    const query = {};
    
    // Filtro de busca por palavra-chave
    if (keyword) {
      query.$or = [
        { name: { $regex: keyword, $options: 'i' } },
        { description: { $regex: keyword, $options: 'i' } }
      ];
    }
    
    // Filtro por categorias
    const categoryIds = JSON.parse(categories);
    if (categoryIds.length > 0) {
      query['categories._id'] = { $in: categoryIds };
    }
    
    // Filtro por seção destacada
    if (featuredSection) {
      const sectionMap = {
        'highlights': 'featuredSections.highlights',
        'newArrivals': 'featuredSections.newArrivals',
        'offers': 'featuredSections.offers',
        'main': 'featuredSections.main'
      };
      
      if (sectionMap[featuredSection]) {
        query[sectionMap[featuredSection]] = true;
      }
    }

    // ✅ VALIDAÇÃO: Garantir valores positivos
    const limit = Math.max(1, parseInt(pageSize) || 20);
    const pageNum = Math.max(1, parseInt(page) || 1);
    const skip = Math.max(0, (pageNum - 1) * limit);

    const products = await Product.find(query)
      .sort({ createdAt: -1 })
      .limit(limit)
      .skip(skip)
      .exec();

    const total = await Product.countDocuments(query);

    // Converte para formato compatível com Flutter
    const compatibleProducts = products.map(p => p.toCompatibleFormat());

    // Formato compatível com Flutter
    res.json({
      data: compatibleProducts,
      meta: {
        totalPages: Math.ceil(total / limit),
        currentPage: pageNum,
        total: total,
        pageSize: limit
      }
    });
  } catch (error) {
    console.error('Erro ao buscar produtos:', error);
    res.status(500).json({ message: error.message });
  }
};

// Buscar produto por ID
exports.getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) {
      return res.status(404).json({ message: 'Produto não encontrado' });
    }
    // Retorna formato compatível
    const compatible = product.toCompatibleFormat();
    res.json(compatible);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Criar produto
exports.createProduct = async (req, res) => {
  try {
    const product = new Product(req.body);

    // 🔥 CLOUDINARY: Upload de imagens base64 para Cloudinary
    if (product.images && product.images.length > 0) {
      const uploadedImages = [];
      for (const img of product.images) {
        if (isBase64Image(img)) {
          try {
            const uploaded = await uploadImage(img, 'products');
            uploadedImages.push(uploaded.url);
            console.log('✅ Produto imagem uploaded:', uploaded.url);
          } catch (error) {
            console.warn('⚠️ Cloudinary falhou, usando base64');
            uploadedImages.push(img);
          }
        } else {
          uploadedImages.push(img);
        }
      }
      product.images = uploadedImages;
    }

    // 🔥 CLOUDINARY: Upload de imagens das variantes
    if (product.variants && product.variants.length > 0) {
      for (const variant of product.variants) {
        if (variant.images && variant.images.length > 0) {
          const uploadedVariantImages = [];
          for (const img of variant.images) {
            if (img.url && isBase64Image(img.url)) {
              try {
                const uploaded = await uploadImage(img.url, 'products/variants');
                uploadedVariantImages.push({ url: uploaded.url, alt: img.alt || '' });
              } catch (error) {
                uploadedVariantImages.push(img);
              }
            } else {
              uploadedVariantImages.push(img);
            }
          }
          variant.images = uploadedVariantImages;
        }
      }

      // Extrair imagens das variantes
      if (!product.images || product.images.length === 0) {
        product.images = product.variants.flatMap(v =>
          v.images ? v.images.map(img => img.url) : []
        );
      }

      // Extrair priceTags das variantes
      if (!product.priceTags || product.priceTags.length === 0) {
        const allPrices = product.variants.flatMap(v =>
          v.sizes ? v.sizes.map(s => s.price) : []
        );

        if (allPrices.length > 0) {
          const minPrice = Math.min(...allPrices);
          const maxPrice = Math.max(...allPrices);

          if (minPrice === maxPrice) {
            product.priceTags = [{ name: 'Preço', price: minPrice }];
          } else {
            product.priceTags = [
              { name: 'A partir de', price: minPrice },
              { name: 'Até', price: maxPrice }
            ];
          }
        }
      }

      // Criar categoria padrão se não existir
      if (!product.categories || product.categories.length === 0) {
        product.categories = [
          {
            name: 'Produtos',
            image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400'
          }
        ];
      }
    }

    const newProduct = await product.save();
    res.status(201).json(newProduct);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Atualizar produto
exports.updateProduct = async (req, res) => {
  try {
    // Buscar produto existente
    const existingProduct = await Product.findById(req.params.id);

    if (!existingProduct) {
      return res.status(404).json({ message: 'Produto não encontrado' });
    }

    // Atualizar campos
    Object.assign(existingProduct, req.body);

    // 🔥 CLOUDINARY: Upload de novas imagens base64 para Cloudinary
    if (existingProduct.images && existingProduct.images.length > 0) {
      const uploadedImages = [];
      for (const img of existingProduct.images) {
        if (isBase64Image(img)) {
          try {
            const uploaded = await uploadImage(img, 'products');
            uploadedImages.push(uploaded.url);
            console.log('✅ Produto imagem updated:', uploaded.url);
          } catch (error) {
            console.warn('⚠️ Cloudinary falhou, usando base64');
            uploadedImages.push(img);
          }
        } else {
          uploadedImages.push(img);
        }
      }
      existingProduct.images = uploadedImages;
    }

    // 🔥 CLOUDINARY: Upload de imagens das variantes
    if (existingProduct.variants && existingProduct.variants.length > 0) {
      for (const variant of existingProduct.variants) {
        if (variant.images && variant.images.length > 0) {
          const uploadedVariantImages = [];
          for (const img of variant.images) {
            if (img.url && isBase64Image(img.url)) {
              try {
                const uploaded = await uploadImage(img.url, 'products/variants');
                uploadedVariantImages.push({ url: uploaded.url, alt: img.alt || '' });
              } catch (error) {
                uploadedVariantImages.push(img);
              }
            } else {
              uploadedVariantImages.push(img);
            }
          }
          variant.images = uploadedVariantImages;
        }
      }

      // Extrair imagens das variantes
      if (!existingProduct.images || existingProduct.images.length === 0) {
        existingProduct.images = existingProduct.variants.flatMap(v =>
          v.images ? v.images.map(img => img.url) : []
        );
      }

      // Extrair priceTags das variantes
      if (!existingProduct.priceTags || existingProduct.priceTags.length === 0) {
        const allPrices = existingProduct.variants.flatMap(v =>
          v.sizes ? v.sizes.map(s => s.price) : []
        );

        if (allPrices.length > 0) {
          const minPrice = Math.min(...allPrices);
          const maxPrice = Math.max(...allPrices);

          if (minPrice === maxPrice) {
            existingProduct.priceTags = [{ name: 'Preço', price: minPrice }];
          } else {
            existingProduct.priceTags = [
              { name: 'A partir de', price: minPrice },
              { name: 'Até', price: maxPrice }
            ];
          }
        }
      }

      // Criar categoria padrão se não existir
      if (!existingProduct.categories || existingProduct.categories.length === 0) {
        existingProduct.categories = [
          {
            name: 'Produtos',
            image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400'
          }
        ];
      }
    }

    const updatedProduct = await existingProduct.save();
    res.json(updatedProduct);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Deletar produto
exports.deleteProduct = async (req, res) => {
  try {
    const product = await Product.findByIdAndDelete(req.params.id);
    
    if (!product) {
      return res.status(404).json({ message: 'Produto não encontrado' });
    }
    
    res.json({ message: 'Produto deletado com sucesso' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};