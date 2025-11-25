import { useState, useEffect } from 'react';
import axios from 'axios';
import API_BASE_URL from '../config/api';

const API_URL = API_BASE_URL;
const STORE_ID = 'eshop_001';

export default function Settings() {
  const [settings, setSettings] = useState({
    storeName: 'EShop',
    logoUrl: '',
    logoPosition: 'center', // 'left' ou 'center'
    email: 'contato@eshop.com',
    phone: '(11) 99999-9999',
  });
  const [logoFile, setLogoFile] = useState(null);
  const [logoPreview, setLogoPreview] = useState('');
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState({ type: '', text: '' });

  // Carregar configurações ao montar
  useEffect(() => {
    loadSettings();
  }, []);

  const loadSettings = async () => {
    try {
      const response = await axios.get(`${API_URL}/store-settings/${STORE_ID}`);
      if (response.data.success) {
        setSettings(response.data.data);
        setLogoPreview(response.data.data.logoUrl);
      }
    } catch (error) {
      console.error('Erro ao carregar configurações:', error);
    }
  };

  // Função para redimensionar imagem
  const resizeImage = (file, maxWidth = 400, maxHeight = 400) => {
    return new Promise((resolve) => {
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = new Image();
        img.onload = () => {
          const canvas = document.createElement('canvas');
          let width = img.width;
          let height = img.height;

          // Calcular novas dimensões mantendo proporção
          if (width > height) {
            if (width > maxWidth) {
              height = (height * maxWidth) / width;
              width = maxWidth;
            }
          } else {
            if (height > maxHeight) {
              width = (width * maxHeight) / height;
              height = maxHeight;
            }
          }

          canvas.width = width;
          canvas.height = height;

          const ctx = canvas.getContext('2d');
          ctx.drawImage(img, 0, 0, width, height);

          // Converter para base64 com qualidade alta
          const resizedBase64 = canvas.toDataURL('image/png', 0.9);
          resolve(resizedBase64);
        };
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    });
  };

  const handleLogoChange = async (e) => {
    const file = e.target.files[0];
    if (file) {
      // Validar tipo de arquivo
      if (!file.type.startsWith('image/')) {
        setMessage({ type: 'error', text: 'Por favor, selecione uma imagem válida' });
        return;
      }

      // Validar tamanho (máximo 5MB)
      if (file.size > 5 * 1024 * 1024) {
        setMessage({ type: 'error', text: 'Imagem muito grande. Máximo 5MB' });
        return;
      }

      setLogoFile(file);
      
      // Redimensionar e mostrar preview
      const resized = await resizeImage(file);
      setLogoPreview(resized);
      
      setMessage({ type: 'success', text: 'Imagem carregada e otimizada!' });
      setTimeout(() => setMessage({ type: '', text: '' }), 2000);
    }
  };

  const handleUploadLogo = async () => {
    if (!logoFile || !logoPreview) {
      setMessage({ type: 'error', text: 'Selecione uma imagem primeiro' });
      return;
    }

    setLoading(true);
    setMessage({ type: '', text: '' });

    try {
      // Usar a imagem já redimensionada do preview
      const response = await axios.post(
        `${API_URL}/store-settings/${STORE_ID}/logo`,
        { logoUrl: logoPreview }
      );

      if (response.data.success) {
        setMessage({ type: 'success', text: 'Logo atualizada com sucesso!' });
        setSettings(response.data.data);
        setLogoFile(null); // Limpar arquivo
        setTimeout(() => setMessage({ type: '', text: '' }), 3000);
      }
    } catch (error) {
      console.error('Erro ao fazer upload:', error);
      const errorMsg = error.response?.data?.message || 'Erro ao fazer upload da logo';
      setMessage({ type: 'error', text: errorMsg });
    } finally {
      setLoading(false);
    }
  };

  const handleSaveSettings = async () => {
    setLoading(true);
    setMessage({ type: '', text: '' });

    try {
      const response = await axios.put(
        `${API_URL}/store-settings/${STORE_ID}`,
        settings
      );

      if (response.data.success) {
        setMessage({ type: 'success', text: 'Configurações salvas com sucesso!' });
        setTimeout(() => setMessage({ type: '', text: '' }), 3000);
      }
    } catch (error) {
      console.error('Erro ao salvar:', error);
      setMessage({ type: 'error', text: 'Erro ao salvar configurações' });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h1 className="text-3xl font-bold mb-6">Configurações</h1>

      {/* Mensagem de feedback */}
      {message.text && (
        <div
          className={`mb-6 p-4 rounded-lg ${
            message.type === 'success'
              ? 'bg-green-100 text-green-700 border border-green-300'
              : 'bg-red-100 text-red-700 border border-red-300'
          }`}
        >
          {message.text}
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Logo da Loja */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-semibold mb-4 flex items-center">
            <span className="text-2xl mr-2">🎨</span>
            Logo da Loja
          </h2>
          <div className="space-y-4">
            {/* Preview da Logo */}
            <div className="flex justify-center items-center h-32 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300">
              {logoPreview ? (
                <img
                  src={logoPreview}
                  alt="Logo Preview"
                  className="max-h-28 max-w-full object-contain"
                />
              ) : (
                <div className="text-center text-gray-400">
                  <svg
                    className="mx-auto h-12 w-12 mb-2"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                    />
                  </svg>
                  <p className="text-sm">Nenhuma logo carregada</p>
                </div>
              )}
            </div>

            {/* Input de arquivo */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Selecionar Logo
              </label>
              <input
                type="file"
                accept="image/png,image/jpeg,image/jpg"
                onChange={handleLogoChange}
                className="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
              />
              <p className="mt-2 text-xs text-gray-500">
                PNG ou JPG. Tamanho recomendado: 135x45px (proporção 3:1)
              </p>
            </div>

            {/* Posicionamento da Logo */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Posicionamento no App
              </label>
              <div className="flex gap-4">
                <label className="flex items-center cursor-pointer">
                  <input
                    type="radio"
                    name="logoPosition"
                    value="left"
                    checked={settings.logoPosition === 'left'}
                    onChange={(e) =>
                      setSettings({ ...settings, logoPosition: e.target.value })
                    }
                    className="mr-2"
                  />
                  <span className="text-sm">Esquerda</span>
                </label>
                <label className="flex items-center cursor-pointer">
                  <input
                    type="radio"
                    name="logoPosition"
                    value="center"
                    checked={settings.logoPosition === 'center'}
                    onChange={(e) =>
                      setSettings({ ...settings, logoPosition: e.target.value })
                    }
                    className="mr-2"
                  />
                  <span className="text-sm">Centro</span>
                </label>
              </div>
            </div>

            {/* Botão de upload */}
            <button
              onClick={handleUploadLogo}
              disabled={loading || !logoFile}
              className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition disabled:bg-gray-400 disabled:cursor-not-allowed"
            >
              {loading ? 'Enviando...' : 'Atualizar Logo'}
            </button>
          </div>
        </div>

        {/* Informações da Loja */}
        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-semibold mb-4 flex items-center">
            <span className="text-2xl mr-2">🏪</span>
            Informações da Loja
          </h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Nome da Loja
              </label>
              <input
                type="text"
                value={settings.storeName}
                onChange={(e) =>
                  setSettings({ ...settings, storeName: e.target.value })
                }
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Email de Contato
              </label>
              <input
                type="email"
                value={settings.email}
                onChange={(e) =>
                  setSettings({ ...settings, email: e.target.value })
                }
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Telefone
              </label>
              <input
                type="tel"
                value={settings.phone}
                onChange={(e) =>
                  setSettings({ ...settings, phone: e.target.value })
                }
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
            <button
              onClick={handleSaveSettings}
              disabled={loading}
              className="w-full bg-green-600 text-white py-2 rounded-lg hover:bg-green-700 transition disabled:bg-gray-400"
            >
              {loading ? 'Salvando...' : 'Salvar Informações'}
            </button>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-semibold mb-4 flex items-center">
            <span className="text-2xl mr-2">🔐</span>
            Segurança
          </h2>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Token Atual
              </label>
              <input
                type="text"
                defaultValue="eshop_admin_token_2024"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg bg-gray-50"
                disabled
              />
            </div>
            <button className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 transition">
              Gerar Novo Token
            </button>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-semibold mb-4 flex items-center">
            <span className="text-2xl mr-2">🎨</span>
            Aparência
          </h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-700">Modo Escuro</span>
              <label className="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" className="sr-only peer" />
                <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
              </label>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-700">Notificações</span>
              <label className="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" className="sr-only peer" defaultChecked />
                <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
              </label>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-xl font-semibold mb-4 flex items-center">
            <span className="text-2xl mr-2">ℹ️</span>
            Sobre o Sistema
          </h2>
          <div className="space-y-2 text-sm text-gray-600">
            <p><strong>Versão:</strong> 1.0.0</p>
            <p><strong>Backend:</strong> http://localhost:4000</p>
            <p><strong>Status:</strong> <span className="text-green-600">✓ Operacional</span></p>
            <p><strong>Última atualização:</strong> Hoje</p>
          </div>
        </div>
      </div>
    </div>
  );
}
