import { useState, useEffect } from 'react';
import { useMutation } from '@tanstack/react-query';
import { bannerService } from '../../services/bannerService';

export default function BannerForm({ banner, onClose, onSuccess }) {
  const [formData, setFormData] = useState({
    title: '',
    description: '',
    imageUrl: '',
    link: '',
    order: 0,
    isActive: true,
  });
  
  const [uploadMode, setUploadMode] = useState('url'); // 'url' ou 'file'
  const [selectedFile, setSelectedFile] = useState(null);
  const [previewUrl, setPreviewUrl] = useState('');
  const [uploading, setUploading] = useState(false);
  const [imageDimensions, setImageDimensions] = useState(null);

  useEffect(() => {
    if (banner) {
      setFormData({
        title: banner.title || '',
        description: banner.description || '',
        imageUrl: banner.imageUrl || '',
        link: banner.link || '',
        order: banner.order || 0,
        isActive: banner.isActive ?? true,
      });
    }
  }, [banner]);

  const createMutation = useMutation({
    mutationFn: bannerService.create,
    onSuccess: () => {
      alert('Banner criado com sucesso!');
      onSuccess();
    },
    onError: (error) => {
      alert('Erro ao criar banner: ' + error.message);
    },
  });

  const updateMutation = useMutation({
    mutationFn: ({ id, data }) => bannerService.update(id, data),
    onSuccess: () => {
      alert('Banner atualizado com sucesso!');
      onSuccess();
    },
    onError: (error) => {
      alert('Erro ao atualizar banner: ' + error.message);
    },
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    if (banner) {
      updateMutation.mutate({ id: banner._id, data: formData });
    } else {
      createMutation.mutate(formData);
    }
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value,
    }));
  };

  const handleFileSelect = (e) => {
    const file = e.target.files[0];
    if (!file) return;

    // Validar tipo de arquivo
    if (!file.type.startsWith('image/')) {
      alert('Por favor, selecione apenas arquivos de imagem!');
      return;
    }

    // Validar tamanho (máximo 5MB)
    if (file.size > 5 * 1024 * 1024) {
      alert('A imagem deve ter no máximo 5MB!');
      return;
    }

    setSelectedFile(file);

    // Criar preview
    const reader = new FileReader();
    reader.onloadend = () => {
      const url = reader.result;
      setPreviewUrl(url);
      
      // Verificar dimensões da imagem
      const img = new Image();
      img.onload = () => {
        setImageDimensions({ width: img.width, height: img.height });
        
        // Avisar se as dimensões não são ideais
        if (img.width < 800 || img.height < 400) {
          alert('⚠️ Atenção: A imagem é menor que o recomendado (800x400px). Pode ficar pixelizada.');
        }
      };
      img.src = url;
    };
    reader.readAsDataURL(file);
  };

  const handleUpload = async () => {
    if (!selectedFile) return;

    setUploading(true);
    try {
      // Converter imagem para base64
      const reader = new FileReader();
      reader.onloadend = () => {
        const base64String = reader.result;
        setFormData((prev) => ({
          ...prev,
          imageUrl: base64String,
        }));
        setUploading(false);
        alert('✅ Imagem carregada com sucesso!');
      };
      reader.readAsDataURL(selectedFile);
    } catch (error) {
      setUploading(false);
      alert('Erro ao fazer upload da imagem: ' + error.message);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        <div className="p-6">
          <div className="flex justify-between items-center mb-6">
            <h2 className="text-2xl font-bold">
              {banner ? 'Editar Banner' : 'Novo Banner'}
            </h2>
            <button
              onClick={onClose}
              className="text-gray-500 hover:text-gray-700 text-2xl"
            >
              ×
            </button>
          </div>

          <form onSubmit={handleSubmit}>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Título *
                </label>
                <input
                  type="text"
                  name="title"
                  value={formData.title}
                  onChange={handleChange}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  required
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Descrição
                </label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleChange}
                  rows="3"
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Imagem do Banner *
                </label>
                
                {/* Dimensões Recomendadas */}
                <div className="mb-3 p-3 bg-blue-50 border border-blue-200 rounded-lg">
                  <div className="flex items-start">
                    <span className="text-blue-600 text-xl mr-2">📐</span>
                    <div className="text-sm">
                      <p className="font-semibold text-blue-900">Dimensões Recomendadas:</p>
                      <p className="text-blue-700">
                        <strong>800 x 400 pixels</strong> (proporção 2:1)
                      </p>
                      <p className="text-blue-600 text-xs mt-1">
                        Formatos: JPG, PNG, WebP | Tamanho máximo: 5MB
                      </p>
                    </div>
                  </div>
                </div>

                {/* Tabs para escolher modo */}
                <div className="flex gap-2 mb-3">
                  <button
                    type="button"
                    onClick={() => setUploadMode('file')}
                    className={`flex-1 py-2 px-4 rounded-lg font-medium transition ${
                      uploadMode === 'file'
                        ? 'bg-blue-600 text-white'
                        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                    }`}
                  >
                    📤 Upload de Arquivo
                  </button>
                  <button
                    type="button"
                    onClick={() => setUploadMode('url')}
                    className={`flex-1 py-2 px-4 rounded-lg font-medium transition ${
                      uploadMode === 'url'
                        ? 'bg-blue-600 text-white'
                        : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                    }`}
                  >
                    🔗 URL da Imagem
                  </button>
                </div>

                {/* Upload de Arquivo */}
                {uploadMode === 'file' && (
                  <div className="space-y-3">
                    <div className="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center hover:border-blue-500 transition">
                      <input
                        type="file"
                        accept="image/*"
                        onChange={handleFileSelect}
                        className="hidden"
                        id="file-upload"
                      />
                      <label
                        htmlFor="file-upload"
                        className="cursor-pointer flex flex-col items-center"
                      >
                        <span className="text-4xl mb-2">📁</span>
                        <span className="text-sm font-medium text-gray-700">
                          Clique para selecionar uma imagem
                        </span>
                        <span className="text-xs text-gray-500 mt-1">
                          ou arraste e solte aqui
                        </span>
                      </label>
                    </div>

                    {selectedFile && (
                      <div className="bg-gray-50 p-3 rounded-lg">
                        <div className="flex items-center justify-between mb-2">
                          <div className="flex items-center">
                            <span className="text-green-600 mr-2">✓</span>
                            <span className="text-sm font-medium text-gray-700">
                              {selectedFile.name}
                            </span>
                          </div>
                          <button
                            type="button"
                            onClick={() => {
                              setSelectedFile(null);
                              setPreviewUrl('');
                              setImageDimensions(null);
                            }}
                            className="text-red-600 hover:text-red-700 text-sm"
                          >
                            ✕ Remover
                          </button>
                        </div>
                        
                        {imageDimensions && (
                          <div className="text-xs text-gray-600 mb-2">
                            Dimensões: {imageDimensions.width} x {imageDimensions.height}px
                            {imageDimensions.width === 800 && imageDimensions.height === 400 && (
                              <span className="text-green-600 ml-2">✓ Perfeito!</span>
                            )}
                          </div>
                        )}

                        <button
                          type="button"
                          onClick={handleUpload}
                          disabled={uploading}
                          className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition disabled:opacity-50"
                        >
                          {uploading ? 'Carregando...' : '📤 Usar Esta Imagem'}
                        </button>
                      </div>
                    )}
                  </div>
                )}

                {/* URL da Imagem */}
                {uploadMode === 'url' && (
                  <div>
                    <input
                      type="url"
                      name="imageUrl"
                      value={formData.imageUrl}
                      onChange={handleChange}
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                      placeholder="https://exemplo.com/imagem.jpg"
                      required={uploadMode === 'url'}
                    />
                    <p className="text-xs text-gray-500 mt-1">
                      Cole a URL de uma imagem hospedada na internet
                    </p>
                  </div>
                )}

                {/* Preview da Imagem */}
                {(formData.imageUrl || previewUrl) && (
                  <div className="mt-3">
                    <p className="text-sm font-medium text-gray-700 mb-2">Preview:</p>
                    <div className="relative">
                      <img
                        src={previewUrl || formData.imageUrl}
                        alt="Preview"
                        className="w-full h-48 object-cover rounded-lg border-2 border-gray-200"
                        onError={(e) => {
                          e.target.src = 'https://via.placeholder.com/800x400/EEE/999?text=Preview+Indisponível';
                        }}
                      />
                      <div className="absolute top-2 right-2 bg-black bg-opacity-60 text-white text-xs px-2 py-1 rounded">
                        Preview
                      </div>
                    </div>
                  </div>
                )}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Link (opcional)
                </label>
                <input
                  type="url"
                  name="link"
                  value={formData.link}
                  onChange={handleChange}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="https://..."
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Ordem de Exibição
                </label>
                <input
                  type="number"
                  name="order"
                  value={formData.order}
                  onChange={handleChange}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                  min="0"
                />
              </div>

              <div className="flex items-center">
                <input
                  type="checkbox"
                  name="isActive"
                  checked={formData.isActive}
                  onChange={handleChange}
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500"
                />
                <label className="ml-2 text-sm font-medium text-gray-700">
                  Banner Ativo
                </label>
              </div>
            </div>

            <div className="flex gap-3 mt-6">
              <button
                type="button"
                onClick={onClose}
                className="flex-1 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition"
              >
                Cancelar
              </button>
              <button
                type="submit"
                disabled={createMutation.isPending || updateMutation.isPending}
                className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition disabled:opacity-50"
              >
                {createMutation.isPending || updateMutation.isPending
                  ? 'Salvando...'
                  : banner
                  ? 'Atualizar'
                  : 'Criar'}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
