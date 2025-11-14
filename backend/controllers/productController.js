const Product = require('../models/Product');

// Listar produtos com filtros
exports.getAllProducts = async (req, res) => {
  try {
    const { 
      keyword = '',
      pageSize = 20,
      page = 1,
      categories = '[]'
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

    const limit = parseInt(pageSize);
    const skip = (parseInt(page) - 1) * limit;

    const products = await Product.find(query)
      .sort({ createdAt: -1 })
      .limit(limit)
      .skip(skip)
      .exec();

    const total = await Product.countDocuments(query);

    // Formato compatível com Flutter
    res.json({
      data: products,
      meta: {
        totalPages: Math.ceil(total / limit),
        currentPage: parseInt(page),
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
    res.json(product);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Criar produto
exports.createProduct = async (req, res) => {
  try {
    const product = new Product(req.body);
    const newProduct = await product.save();
    res.status(201).json(newProduct);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};

// Atualizar produto
exports.updateProduct = async (req, res) => {
  try {
    const product = await Product.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    );
    
    if (!product) {
      return res.status(404).json({ message: 'Produto não encontrado' });
    }
    
    res.json(product);
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
