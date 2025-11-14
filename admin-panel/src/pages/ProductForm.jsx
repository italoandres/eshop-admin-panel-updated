import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { Plus, X, Upload, Star, Check, Image as ImageIcon, Package } from 'lucide-react';

const ProductForm = () => {
  const navigate = useNavigate();
  const { id } = useParams();
  const isEdit = !!id;

  const [formData, setFormData] = useState({
    name: '',
    description: '',
    shippingInfo: {
      isFree: false,
      shippingCost: 0
    }
  });

  // Sistema de variações
  const [availableSizes, setAvailableSizes] = useState([]);
  const [sizeInput, setSizeInput] = useState('');
  const [variants, setVariants] = useState([]);
  const [colorInput, setColorInput] = useState('');
  const [selectedVariant, setSelectedVariant] = useState(null);
  const [loading, setLoading] = useState(false);

  // Carregar produto ao editar
  useEffect(() => {
    if (isEdit && id) {
      setLoading(true);
      fetch(`http://localhost:4000/api/products/${id}`)
        .then(res => res.json())
        .then(data => {
          setFormData({
            name: data.name || '',
            description: data.description || '',
            shippingInfo: data.shippingInfo || {
              isFree: false,
              shippingCost: 0
            }
          });
          setAvailableSizes(data.availableSizes || []);
          setVariants(data.variants || []);
        })
        .catch(error => {
          console.error('Erro ao carregar produto:', error);
          alert('Erro ao carregar produto');
        })
        .finally(() => setLoading(false));
    }
  }, [id, isEdit]);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Validações
    if (availableSizes.length === 0) {
      alert('Adicione pelo menos um tamanho!');
      return;
    }
    
    if (variants.length === 0) {
      alert('Adicione pelo menos uma cor!');
      return;
    }

    const incompleteVariant = variants.find(v => 
      !v.images || v.images.length === 0 || 
      !v.sizes || v.sizes.length === 0
    );

    if (incompleteVariant) {
      alert(`Configure a cor "${incompleteVariant.color}" completamente!`);
      return;
    }

    setLoading(true);

    try {
      const productData = {
        ...formData,
        availableSizes,
        variants
      };

      const url = isEdit 
        ? `http://localhost:4000/api/products/${id}`
        : 'http://localhost:4000/api/products';
      
      const method = isEdit ? 'PUT' : 'POST';

      const response = await fetch(url, {
        method,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(productData)
      });

      if (response.ok) {
        alert(isEdit ? 'Produto atualizado!' : 'Produto criado!');
        navigate('/products');
      } else {
        alert('Erro ao salvar produto');
      }
    } catch (error) {
      console.error('Erro:', error);
      alert('Erro ao salvar produto');
    } finally {
      setLoading(false);
    }
  };

  // Gerenciar tamanhos
  const addSize = (e) => {
    if (e.key === 'Enter' && sizeInput.trim()) {
      e.preventDefault();
      if (!availableSizes.includes(sizeInput.trim())) {
        setAvailableSizes([...availableSizes, sizeInput.trim()]);
      }
      setSizeInput('');
    }
  };

  const removeSize = (size) => {
    setAvailableSizes(availableSizes.filter(s => s !== size));
    // Remove dos variants também
    setVariants(variants.map(v => ({
      ...v,
      sizes: v.sizes.filter(vs => vs.size !== size)
    })));
  };

  // Gerenciar cores
  const addColor = (e) => {
    if (e.key === 'Enter' && colorInput.trim()) {
      e.preventDefault();
      if (!variants.find(v => v.color === colorInput.trim())) {
        setVariants([...variants, {
          color: colorInput.trim(),
          images: [],
          sizes: []
        }]);
      }
      setColorInput('');
    }
  };

  const removeColor = (color) => {
    setVariants(variants.filter(v => v.color !== color));
    if (selectedVariant?.color === color) {
      setSelectedVariant(null);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 p-6">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="flex justify-between items-center mb-6">
          <div>
            <h1 className="text-3xl font-bold text-gray-900">
              {isEdit ? 'Editar Produto' : 'Novo Produto'}
            </h1>
            <p className="text-gray-600 mt-1">
              Preencha as informações do produto com variações de cor e tamanho
            </p>
          </div>
          <button
            onClick={() => navigate('/products')}
            className="px-4 py-2 text-gray-600 hover:text-gray-800 hover:bg-gray-100 rounded-lg transition"
          >
            Cancelar
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Informações Básicas */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h2 className="text-xl font-semibold mb-6 flex items-center gap-2">
              <Package className="text-blue-600" size={24} />
              Informações Básicas
            </h2>
            
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Nome do Produto <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                  placeholder="Ex: Camiseta Básica Premium"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Descrição <span className="text-red-500">*</span>
                </label>
                <textarea
                  required
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition"
                  rows="4"
                  placeholder="Descreva o produto em detalhes..."
                />
              </div>
            </div>
          </div>

          {/* Tamanhos Disponíveis */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h2 className="text-xl font-semibold mb-4">
              📏 Tamanhos Disponíveis
            </h2>
            <p className="text-sm text-gray-600 mb-4">
              Digite o tamanho e pressione <kbd className="px-2 py-1 bg-gray-100 rounded">Enter</kbd>
            </p>
            
            <input
              type="text"
              value={sizeInput}
              onChange={(e) => setSizeInput(e.target.value)}
              onKeyDown={addSize}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent mb-4"
              placeholder="Ex: PP, P, M, G, GG, XG..."
            />

            {availableSizes.length > 0 && (
              <div className="flex flex-wrap gap-2">
                {availableSizes.map((size) => (
                  <div
                    key={size}
                    className="group relative bg-gradient-to-br from-blue-50 to-blue-100 border-2 border-blue-200 rounded-lg px-4 py-2 flex items-center gap-2 hover:shadow-md transition"
                  >
                    <span className="font-semibold text-blue-900">{size}</span>
                    <button
                      type="button"
                      onClick={() => removeSize(size)}
                      className="text-red-500 hover:text-red-700 opacity-0 group-hover:opacity-100 transition"
                    >
                      <X size={16} />
                    </button>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Cores do Produto */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h2 className="text-xl font-semibold mb-4">
              🎨 Cores do Produto
            </h2>
            <p className="text-sm text-gray-600 mb-4">
              Digite a cor e pressione <kbd className="px-2 py-1 bg-gray-100 rounded">Enter</kbd>
            </p>
            
            <input
              type="text"
              value={colorInput}
              onChange={(e) => setColorInput(e.target.value)}
              onKeyDown={addColor}
              className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent mb-4"
              placeholder="Ex: Preto, Branco, Azul Marinho..."
            />

            {variants.length > 0 && (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {variants.map((variant) => (
                  <div
                    key={variant.color}
                    className="group relative bg-gradient-to-br from-purple-50 to-pink-50 border-2 border-purple-200 rounded-xl p-4 hover:shadow-lg transition"
                  >
                    <div className="flex justify-between items-start mb-3">
                      <h3 className="font-bold text-lg text-purple-900">{variant.color}</h3>
                      <button
                        type="button"
                        onClick={() => removeColor(variant.color)}
                        className="text-red-500 hover:text-red-700 opacity-0 group-hover:opacity-100 transition"
                      >
                        <X size={18} />
                      </button>
                    </div>

                    <div className="space-y-2 text-sm text-gray-600 mb-4">
                      <div className="flex items-center gap-2">
                        <ImageIcon size={16} />
                        <span>{variant.images.length} foto(s)</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <Package size={16} />
                        <span>{variant.sizes.length} tamanho(s)</span>
                      </div>
                    </div>

                    <button
                      type="button"
                      onClick={() => setSelectedVariant(variant)}
                      className="w-full bg-purple-600 text-white py-2 rounded-lg hover:bg-purple-700 transition font-medium"
                    >
                      Configurar
                    </button>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Frete */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
            <h2 className="text-xl font-semibold mb-4">
              🚚 Informações de Frete
            </h2>
            
            <div className="space-y-4">
              <label className="flex items-center gap-3 cursor-pointer">
                <input
                  type="checkbox"
                  checked={formData.shippingInfo.isFree}
                  onChange={(e) => setFormData({
                    ...formData,
                    shippingInfo: { ...formData.shippingInfo, isFree: e.target.checked }
                  })}
                  className="w-5 h-5 text-blue-600 rounded focus:ring-2 focus:ring-blue-500"
                />
                <span className="font-medium">Frete Grátis</span>
              </label>

              {!formData.shippingInfo.isFree && (
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Custo do Frete (R$)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={formData.shippingInfo.shippingCost}
                    onChange={(e) => setFormData({
                      ...formData,
                      shippingInfo: { ...formData.shippingInfo, shippingCost: parseFloat(e.target.value) }
                    })}
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="0.00"
                  />
                </div>
              )}
            </div>
          </div>

          {/* Botões de Ação */}
          <div className="flex justify-end gap-4 sticky bottom-6 bg-white p-4 rounded-xl shadow-lg border border-gray-200">
            <button
              type="button"
              onClick={() => navigate('/products')}
              className="px-6 py-3 border-2 border-gray-300 rounded-lg hover:bg-gray-50 transition font-medium"
            >
              Cancelar
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-8 py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg hover:from-blue-700 hover:to-purple-700 disabled:opacity-50 transition font-medium shadow-md"
            >
              {loading ? 'Salvando...' : '✨ Salvar Produto'}
            </button>
          </div>
        </form>
      </div>

      {/* Modal de Configuração de Variante */}
      {selectedVariant && (
        <VariantConfigModal
          variant={selectedVariant}
          availableSizes={availableSizes}
          onClose={() => setSelectedVariant(null)}
          onSave={(updatedVariant) => {
            setVariants(variants.map(v => 
              v.color === selectedVariant.color ? updatedVariant : v
            ));
            setSelectedVariant(null);
          }}
        />
      )}
    </div>
  );
};

// Modal de Configuração de Variante
const VariantConfigModal = ({ variant, availableSizes, onClose, onSave }) => {
  const [localVariant, setLocalVariant] = useState(JSON.parse(JSON.stringify(variant)));
  const [imageInput, setImageInput] = useState('');
  const [uploading, setUploading] = useState(false);
  const [draggedIndex, setDraggedIndex] = useState(null);

  const addImage = () => {
    if (imageInput.trim() && localVariant.images.length < 10) {
      setLocalVariant({
        ...localVariant,
        images: [...localVariant.images, { url: imageInput.trim(), isCover: localVariant.images.length === 0 }]
      });
      setImageInput('');
    }
  };

  // Upload de arquivo
  const handleFileUpload = async (files) => {
    if (!files || files.length === 0) return;
    
    const remainingSlots = 10 - localVariant.images.length;
    const filesToUpload = Array.from(files).slice(0, remainingSlots);
    
    setUploading(true);
    
    try {
      const uploadedImages = [];
      
      for (const file of filesToUpload) {
        // Converter para base64
        const base64 = await fileToBase64(file);
        uploadedImages.push({
          url: base64,
          isCover: localVariant.images.length === 0 && uploadedImages.length === 0
        });
      }
      
      setLocalVariant({
        ...localVariant,
        images: [...localVariant.images, ...uploadedImages]
      });
    } catch (error) {
      console.error('Erro ao fazer upload:', error);
      alert('Erro ao fazer upload das imagens');
    } finally {
      setUploading(false);
    }
  };

  const fileToBase64 = (file) => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result);
      reader.onerror = (error) => reject(error);
    });
  };

  const removeImage = (index) => {
    const newImages = localVariant.images.filter((_, i) => i !== index);
    // Se removeu a capa, define a primeira como capa
    if (localVariant.images[index].isCover && newImages.length > 0) {
      newImages[0].isCover = true;
    }
    setLocalVariant({ ...localVariant, images: newImages });
  };

  const setCoverImage = (index) => {
    const newImages = [...localVariant.images];
    const [coverImage] = newImages.splice(index, 1);
    coverImage.isCover = true;
    
    // Remove isCover das outras
    newImages.forEach(img => img.isCover = false);
    
    // Coloca a imagem de capa no início
    setLocalVariant({
      ...localVariant,
      images: [coverImage, ...newImages]
    });
  };

  // Drag and Drop para reordenar
  const handleDragStart = (index) => {
    setDraggedIndex(index);
  };

  const handleDragOver = (e, index) => {
    e.preventDefault();
    if (draggedIndex === null || draggedIndex === index) return;
    
    const newImages = [...localVariant.images];
    const draggedImage = newImages[draggedIndex];
    newImages.splice(draggedIndex, 1);
    newImages.splice(index, 0, draggedImage);
    
    setLocalVariant({ ...localVariant, images: newImages });
    setDraggedIndex(index);
  };

  const handleDragEnd = () => {
    setDraggedIndex(null);
  };

  const toggleSize = (size) => {
    const existingSize = localVariant.sizes.find(s => s.size === size);
    
    if (existingSize) {
      setLocalVariant({
        ...localVariant,
        sizes: localVariant.sizes.filter(s => s.size !== size)
      });
    } else {
      setLocalVariant({
        ...localVariant,
        sizes: [...localVariant.sizes, {
          size,
          sku: `${variant.color.toUpperCase()}-${size}-001`,
          ean: '',
          quantity: 0,
          price: 0
        }]
      });
    }
  };

  const updateSizeDetail = (size, field, value) => {
    setLocalVariant({
      ...localVariant,
      sizes: localVariant.sizes.map(s =>
        s.size === size ? { ...s, [field]: value } : s
      )
    });
  };

  const handleSave = () => {
    if (localVariant.images.length === 0) {
      alert('Adicione pelo menos uma foto!');
      return;
    }
    if (localVariant.sizes.length === 0) {
      alert('Selecione pelo menos um tamanho!');
      return;
    }
    
    const incompleteSizes = localVariant.sizes.filter(s => !s.sku || !s.quantity || !s.price);
    if (incompleteSizes.length > 0) {
      alert('Preencha SKU, Quantidade e Preço para todos os tamanhos!');
      return;
    }

    onSave(localVariant);
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="sticky top-0 bg-gradient-to-r from-purple-600 to-pink-600 text-white p-6 rounded-t-2xl">
          <div className="flex justify-between items-center">
            <h2 className="text-2xl font-bold">🎨 Configurar: {variant.color}</h2>
            <button
              onClick={onClose}
              className="text-white hover:bg-white hover:bg-opacity-20 p-2 rounded-lg transition"
            >
              <X size={24} />
            </button>
          </div>
        </div>

        <div className="p-6 space-y-6">
          {/* Fotos */}
          <div>
            <h3 className="text-lg font-semibold mb-3">📸 Fotos da Variação (até 10)</h3>
            
            {/* Upload de Arquivos */}
            <div className="mb-4">
              <label className="flex items-center justify-center w-full h-32 px-4 transition bg-white border-2 border-gray-300 border-dashed rounded-lg appearance-none cursor-pointer hover:border-purple-400 focus:outline-none">
                <div className="flex flex-col items-center space-y-2">
                  <Upload className="w-8 h-8 text-gray-400" />
                  <span className="font-medium text-gray-600">
                    {uploading ? 'Fazendo upload...' : 'Clique ou arraste imagens aqui'}
                  </span>
                  <span className="text-xs text-gray-500">
                    PNG, JPG, WEBP até 10MB (máx. 10 fotos)
                  </span>
                </div>
                <input
                  type="file"
                  multiple
                  accept="image/*"
                  onChange={(e) => handleFileUpload(e.target.files)}
                  className="hidden"
                  disabled={uploading || localVariant.images.length >= 10}
                />
              </label>
            </div>

            {/* Ou URL */}
            <div className="flex gap-2 mb-4">
              <input
                type="url"
                value={imageInput}
                onChange={(e) => setImageInput(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && (e.preventDefault(), addImage())}
                className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500"
                placeholder="Ou cole a URL da imagem e pressione Enter"
              />
              <button
                type="button"
                onClick={addImage}
                className="px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700"
                disabled={localVariant.images.length >= 10}
              >
                <Plus size={20} />
              </button>
            </div>

            {/* Grid de Miniaturas com Drag and Drop */}
            {localVariant.images.length > 0 && (
              <div>
                <p className="text-sm text-gray-600 mb-2">
                  ⭐ = Capa | Arraste para reordenar
                </p>
                <div className="grid grid-cols-5 gap-3">
                  {localVariant.images.map((img, index) => (
                    <div
                      key={index}
                      draggable
                      onDragStart={() => handleDragStart(index)}
                      onDragOver={(e) => handleDragOver(e, index)}
                      onDragEnd={handleDragEnd}
                      className={`relative group cursor-move ${
                        draggedIndex === index ? 'opacity-50' : ''
                      }`}
                    >
                      <img
                        src={img.url}
                        alt={`Foto ${index + 1}`}
                        className="w-full h-24 object-cover rounded-lg border-2 border-gray-200 hover:border-purple-400 transition"
                      />
                      
                      {/* Badge de posição */}
                      <div className="absolute bottom-1 left-1 bg-black bg-opacity-70 text-white text-xs px-2 py-1 rounded">
                        #{index + 1}
                      </div>
                      
                      {/* Botão de capa */}
                      <button
                        type="button"
                        onClick={() => setCoverImage(index)}
                        className={`absolute top-1 left-1 p-1 rounded shadow-md transition ${
                          img.isCover 
                            ? 'bg-yellow-400 text-yellow-900 scale-110' 
                            : 'bg-white text-gray-400 hover:bg-yellow-100'
                        }`}
                        title={img.isCover ? 'Foto de capa' : 'Definir como capa'}
                      >
                        <Star size={16} fill={img.isCover ? 'currentColor' : 'none'} />
                      </button>
                      
                      {/* Botão de remover */}
                      <button
                        type="button"
                        onClick={() => removeImage(index)}
                        className="absolute top-1 right-1 p-1 bg-red-500 text-white rounded shadow-md opacity-0 group-hover:opacity-100 transition"
                        title="Remover foto"
                      >
                        <X size={16} />
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>

          {/* Tamanhos */}
          <div>
            <h3 className="text-lg font-semibold mb-3">📏 Tamanhos Disponíveis</h3>
            <div className="flex flex-wrap gap-2 mb-4">
              {availableSizes.map((size) => {
                const isSelected = localVariant.sizes.some(s => s.size === size);
                return (
                  <button
                    key={size}
                    type="button"
                    onClick={() => toggleSize(size)}
                    className={`px-4 py-2 rounded-lg font-semibold transition ${
                      isSelected
                        ? 'bg-green-500 text-white'
                        : 'bg-gray-200 text-gray-700 hover:bg-gray-300'
                    }`}
                  >
                    {isSelected && <Check size={16} className="inline mr-1" />}
                    {size}
                  </button>
                );
              })}
            </div>
          </div>

          {/* Detalhes por Tamanho */}
          {localVariant.sizes.length > 0 && (
            <div>
              <h3 className="text-lg font-semibold mb-3">📦 Detalhes por Tamanho</h3>
              <div className="space-y-4">
                {localVariant.sizes.map((sizeDetail) => (
                  <div key={sizeDetail.size} className="border-2 border-gray-200 rounded-lg p-4 bg-gray-50">
                    <h4 className="font-bold text-lg mb-3 text-purple-900">{sizeDetail.size}</h4>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium mb-1">
                          SKU <span className="text-red-500">*</span>
                        </label>
                        <input
                          type="text"
                          required
                          value={sizeDetail.sku}
                          onChange={(e) => updateSizeDetail(sizeDetail.size, 'sku', e.target.value)}
                          className="w-full px-3 py-2 border rounded-lg"
                          placeholder="Ex: PRETO-PP-001"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium mb-1">
                          EAN (opcional)
                        </label>
                        <input
                          type="text"
                          value={sizeDetail.ean}
                          onChange={(e) => updateSizeDetail(sizeDetail.size, 'ean', e.target.value)}
                          className="w-full px-3 py-2 border rounded-lg"
                          placeholder="7891234567890"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium mb-1">
                          Quantidade <span className="text-red-500">*</span>
                        </label>
                        <input
                          type="number"
                          required
                          value={sizeDetail.quantity}
                          onChange={(e) => updateSizeDetail(sizeDetail.size, 'quantity', parseInt(e.target.value))}
                          className="w-full px-3 py-2 border rounded-lg"
                          placeholder="0"
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium mb-1">
                          Preço (R$) <span className="text-red-500">*</span>
                        </label>
                        <input
                          type="number"
                          step="0.01"
                          required
                          value={sizeDetail.price}
                          onChange={(e) => updateSizeDetail(sizeDetail.size, 'price', parseFloat(e.target.value))}
                          className="w-full px-3 py-2 border rounded-lg"
                          placeholder="0.00"
                        />
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="sticky bottom-0 bg-gray-50 p-6 rounded-b-2xl border-t flex justify-end gap-4">
          <button
            type="button"
            onClick={onClose}
            className="px-6 py-3 border-2 border-gray-300 rounded-lg hover:bg-gray-100 transition font-medium"
          >
            Cancelar
          </button>
          <button
            type="button"
            onClick={handleSave}
            className="px-8 py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white rounded-lg hover:from-purple-700 hover:to-pink-700 transition font-medium shadow-md"
          >
            ✅ Salvar Cor
          </button>
        </div>
      </div>
    </div>
  );
};

export default ProductForm;
