import React, { useState, useEffect } from 'react';
import { X, Plus, Trash2, AlertCircle, Search } from 'lucide-react';
import axios from 'axios';

const API_URL = 'http://localhost:4000/api/discount-rules';
const PRODUCTS_API_URL = 'http://localhost:4000/api/products';

const RuleForm = ({ rule, onClose, onSuccess }) => {
  const [formData, setFormData] = useState({
    productId: rule?.productId || '',
    name: rule?.name || '',
    description: rule?.description || '',
    applyTo: rule?.applyTo || 'specific', // 'specific', 'all', 'category'
    category: rule?.category || '',
    tiers: rule?.tiers || [
      { quantity: 1, discountPercent: 25 },
      { quantity: 2, discountPercent: 40 }
    ]
  });
  const [errors, setErrors] = useState({});
  const [saving, setSaving] = useState(false);
  const [products, setProducts] = useState([]);
  const [filteredProducts, setFilteredProducts] = useState([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [showDropdown, setShowDropdown] = useState(false);
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [categories, setCategories] = useState([]);

  useEffect(() => {
    fetchProducts();
  }, []);

  useEffect(() => {
    if (searchTerm) {
      const filtered = products.filter(p => 
        p.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        p.sku?.toLowerCase().includes(searchTerm.toLowerCase())
      );
      setFilteredProducts(filtered);
    } else {
      setFilteredProducts([]);
    }
  }, [searchTerm, products]);

  const fetchProducts = async () => {
    try {
      const response = await axios.get(PRODUCTS_API_URL);
      const productList = response.data.data || [];
      setProducts(productList);
      
      // Extrair categorias únicas
      const uniqueCategories = [...new Set(
        productList.flatMap(p => p.categories?.map(c => c.name) || [])
      )];
      setCategories(uniqueCategories);
      
      // Se estiver editando, buscar produto selecionado
      if (rule?.productId) {
        const product = productList.find(p => p._id === rule.productId);
        if (product) {
          setSelectedProduct(product);
          setSearchTerm(product.name);
        }
      }
    } catch (error) {
      console.error('Erro ao buscar produtos:', error);
    }
  };

  const selectProduct = (product) => {
    setSelectedProduct(product);
    setFormData({ ...formData, productId: product._id });
    setSearchTerm(product.name);
    setShowDropdown(false);
  };

  const validateForm = () => {
    const newErrors = {};

    if (formData.applyTo === 'specific' && !formData.productId.trim()) {
      newErrors.productId = 'Selecione um produto';
    }

    if (formData.applyTo === 'category' && !formData.category.trim()) {
      newErrors.category = 'Selecione uma categoria';
    }

    if (!formData.name.trim()) {
      newErrors.name = 'Nome é obrigatório';
    }

    if (formData.tiers.length < 2) {
      newErrors.tiers = 'Mínimo 2 níveis necessários';
    }

    // Validar tiers
    const sortedTiers = [...formData.tiers].sort((a, b) => a.quantity - b.quantity);
    for (let i = 0; i < sortedTiers.length; i++) {
      const tier = sortedTiers[i];
      
      if (!tier.quantity || tier.quantity < 1) {
        newErrors[`tier_${i}_quantity`] = 'Quantidade inválida';
      }
      
      if (!tier.discountPercent || tier.discountPercent < 1 || tier.discountPercent > 99) {
        newErrors[`tier_${i}_discount`] = 'Desconto deve estar entre 1% e 99%';
      }
      
      if (i > 0 && tier.discountPercent <= sortedTiers[i-1].discountPercent) {
        newErrors[`tier_${i}_discount`] = 'Desconto deve ser maior que o anterior';
      }
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!validateForm()) {
      return;
    }

    try {
      setSaving(true);
      
      // Preparar dados para o backend
      const dataToSend = {
        name: formData.name,
        description: formData.description,
        tiers: formData.tiers,
        applyToAll: formData.applyTo === 'all',
        productId: formData.applyTo === 'specific' ? formData.productId : null,
        applicableProducts: formData.applyTo === 'category' ? 
          products.filter(p => p.categories?.some(c => c.name === formData.category)).map(p => p._id) : 
          []
      };
      
      if (rule) {
        await axios.put(`${API_URL}/${rule._id}`, dataToSend);
        alert('Promoção atualizada com sucesso!');
      } else {
        await axios.post(API_URL, dataToSend);
        alert('Promoção criada com sucesso!');
      }
      
      onSuccess();
    } catch (error) {
      console.error('Erro ao salvar:', error);
      alert(error.response?.data?.error || 'Erro ao salvar promoção');
    } finally {
      setSaving(false);
    }
  };

  const addTier = () => {
    const lastTier = formData.tiers[formData.tiers.length - 1];
    setFormData({
      ...formData,
      tiers: [
        ...formData.tiers,
        {
          quantity: lastTier.quantity + 1,
          discountPercent: Math.min(lastTier.discountPercent + 10, 99)
        }
      ]
    });
  };

  const removeTier = (index) => {
    if (formData.tiers.length <= 2) {
      alert('Mínimo 2 níveis necessários');
      return;
    }
    setFormData({
      ...formData,
      tiers: formData.tiers.filter((_, i) => i !== index)
    });
  };

  const updateTier = (index, field, value) => {
    const newTiers = [...formData.tiers];
    newTiers[index][field] = Number(value);
    setFormData({ ...formData, tiers: newTiers });
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="sticky top-0 bg-white border-b px-6 py-4 flex justify-between items-center">
          <h2 className="text-2xl font-bold text-gray-800">
            {rule ? 'Editar Promoção' : 'Nova Promoção'}
          </h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
          >
            <X size={24} />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="p-6">
          {/* Apply To */}
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Aplicar desconto a: *
            </label>
            <div className="grid grid-cols-3 gap-3">
              <button
                type="button"
                onClick={() => setFormData({ ...formData, applyTo: 'specific', productId: '', category: '' })}
                className={`px-4 py-3 rounded-lg border-2 transition-all ${
                  formData.applyTo === 'specific'
                    ? 'border-blue-500 bg-blue-50 text-blue-700 font-semibold'
                    : 'border-gray-300 hover:border-gray-400'
                }`}
              >
                Produto Específico
              </button>
              <button
                type="button"
                onClick={() => setFormData({ ...formData, applyTo: 'category', productId: '' })}
                className={`px-4 py-3 rounded-lg border-2 transition-all ${
                  formData.applyTo === 'category'
                    ? 'border-blue-500 bg-blue-50 text-blue-700 font-semibold'
                    : 'border-gray-300 hover:border-gray-400'
                }`}
              >
                Por Categoria
              </button>
              <button
                type="button"
                onClick={() => setFormData({ ...formData, applyTo: 'all', productId: '', category: '' })}
                className={`px-4 py-3 rounded-lg border-2 transition-all ${
                  formData.applyTo === 'all'
                    ? 'border-blue-500 bg-blue-50 text-blue-700 font-semibold'
                    : 'border-gray-300 hover:border-gray-400'
                }`}
              >
                Todos os Produtos
              </button>
            </div>
          </div>

          {/* Product Selection - Specific */}
          {formData.applyTo === 'specific' && (
            <div className="mb-6 relative">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Buscar Produto *
              </label>
              <div className="relative">
                <Search className="absolute left-3 top-3 text-gray-400" size={20} />
                <input
                  type="text"
                  value={searchTerm}
                  onChange={(e) => {
                    setSearchTerm(e.target.value);
                    setShowDropdown(true);
                  }}
                  onFocus={() => setShowDropdown(true)}
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  placeholder="Digite o nome ou SKU do produto..."
                />
              </div>
              
              {showDropdown && filteredProducts.length > 0 && (
                <div className="absolute z-10 w-full mt-1 bg-white border border-gray-300 rounded-lg shadow-lg max-h-60 overflow-y-auto">
                  {filteredProducts.map((product) => (
                    <button
                      key={product._id}
                      type="button"
                      onClick={() => selectProduct(product)}
                      className="w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center gap-3 border-b last:border-b-0"
                    >
                      {product.images && product.images[0] && (
                        <img
                          src={product.images[0]}
                          alt={product.name}
                          className="w-10 h-10 object-cover rounded"
                        />
                      )}
                      <div className="flex-1">
                        <div className="font-medium text-gray-900">{product.name}</div>
                        <div className="text-sm text-gray-500">
                          ID: {product._id.substring(0, 8)}... • R$ {product.priceTags?.[product.priceTags.length - 1]?.price || 0}
                        </div>
                      </div>
                    </button>
                  ))}
                </div>
              )}
              
              {selectedProduct && (
                <div className="mt-2 p-3 bg-green-50 border border-green-200 rounded-lg flex items-center gap-3">
                  {selectedProduct.images && selectedProduct.images[0] && (
                    <img
                      src={selectedProduct.images[0]}
                      alt={selectedProduct.name}
                      className="w-12 h-12 object-cover rounded"
                    />
                  )}
                  <div className="flex-1">
                    <div className="font-medium text-gray-900">{selectedProduct.name}</div>
                    <div className="text-sm text-gray-600">ID: {selectedProduct._id.substring(0, 12)}...</div>
                  </div>
                  <button
                    type="button"
                    onClick={() => {
                      setSelectedProduct(null);
                      setSearchTerm('');
                      setFormData({ ...formData, productId: '' });
                    }}
                    className="text-red-600 hover:text-red-700"
                  >
                    <X size={20} />
                  </button>
                </div>
              )}
              
              {errors.productId && (
                <p className="text-red-600 text-sm mt-1 flex items-center gap-1">
                  <AlertCircle size={16} />
                  {errors.productId}
                </p>
              )}
            </div>
          )}

          {/* Category Selection */}
          {formData.applyTo === 'category' && (
            <div className="mb-6">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Selecionar Categoria *
              </label>
              <select
                value={formData.category}
                onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="">Selecione uma categoria</option>
                {categories.map((cat) => (
                  <option key={cat} value={cat}>{cat}</option>
                ))}
              </select>
              {errors.category && (
                <p className="text-red-600 text-sm mt-1 flex items-center gap-1">
                  <AlertCircle size={16} />
                  {errors.category}
                </p>
              )}
            </div>
          )}

          {/* All Products Info */}
          {formData.applyTo === 'all' && (
            <div className="mb-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
              <p className="text-blue-800 font-medium">
                ℹ️ Este desconto será aplicado a TODOS os produtos da loja
              </p>
            </div>
          )}

          {/* Name */}
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Nome da Promoção *
            </label>
            <input
              type="text"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="Desconto Progressivo - Produto X"
            />
            {errors.name && (
              <p className="text-red-600 text-sm mt-1 flex items-center gap-1">
                <AlertCircle size={16} />
                {errors.name}
              </p>
            )}
          </div>

          {/* Description */}
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Descrição
            </label>
            <textarea
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              rows="3"
              placeholder="Quanto mais você compra, mais desconto ganha!"
            />
          </div>

          {/* Tiers */}
          <div className="mb-6">
            <div className="flex justify-between items-center mb-4">
              <label className="block text-sm font-medium text-gray-700">
                Níveis de Desconto * (mínimo 2)
              </label>
              <button
                type="button"
                onClick={addTier}
                disabled={formData.tiers.length >= 10}
                className="text-blue-600 hover:text-blue-700 flex items-center gap-1 text-sm font-medium disabled:opacity-50"
              >
                <Plus size={16} />
                Adicionar Nível
              </button>
            </div>

            <div className="space-y-3">
              {formData.tiers.map((tier, index) => (
                <div key={index} className="flex gap-3 items-start bg-gray-50 p-4 rounded-lg">
                  <div className="flex-1">
                    <label className="block text-xs text-gray-600 mb-1">Quantidade</label>
                    <input
                      type="number"
                      min="1"
                      value={tier.quantity}
                      onChange={(e) => updateTier(index, 'quantity', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    />
                  </div>
                  <div className="flex-1">
                    <label className="block text-xs text-gray-600 mb-1">Desconto (%)</label>
                    <input
                      type="number"
                      min="1"
                      max="99"
                      value={tier.discountPercent}
                      onChange={(e) => updateTier(index, 'discountPercent', e.target.value)}
                      className="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    />
                  </div>
                  <button
                    type="button"
                    onClick={() => removeTier(index)}
                    disabled={formData.tiers.length <= 2}
                    className="mt-6 p-2 text-red-600 hover:bg-red-50 rounded-lg disabled:opacity-30"
                  >
                    <Trash2 size={20} />
                  </button>
                </div>
              ))}
            </div>
            {errors.tiers && (
              <p className="text-red-600 text-sm mt-2 flex items-center gap-1">
                <AlertCircle size={16} />
                {errors.tiers}
              </p>
            )}
          </div>

          {/* Preview */}
          <div className="mb-6 p-4 bg-blue-50 rounded-lg border border-blue-200">
            <h4 className="font-semibold text-blue-900 mb-2">Preview:</h4>
            <div className="flex flex-wrap gap-2">
              {formData.tiers
                .sort((a, b) => a.quantity - b.quantity)
                .map((tier, index) => (
                  <div key={index} className="bg-white px-3 py-2 rounded-lg border border-blue-300">
                    <span className="font-semibold">{tier.quantity}x</span>
                    <span className="mx-1">→</span>
                    <span className="font-bold text-blue-600">-{tier.discountPercent}%</span>
                  </div>
                ))}
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-3 justify-end">
            <button
              type="button"
              onClick={onClose}
              className="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={saving}
              className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:opacity-50"
            >
              {saving ? 'Salvando...' : rule ? 'Atualizar' : 'Criar'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default RuleForm;
