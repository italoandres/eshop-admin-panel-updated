import { useState, useEffect } from 'react';
import axios from 'axios';
import API_BASE_URL from '../config/api';
import LogoEditorModal from '../components/LogoEditorModal';

const API_URL = API_BASE_URL;
const STORE_ID = 'eshop_001';

// Função de validação de arquivo
const validateFile = (file) => {
  const MAX_SIZE = 5 * 1024 * 1024; // 5MB
  const ALLOWED_TYPES = ['image/png', 'image/jpeg', 'image/jpg'];

  if (!file) {
    return { valid: false, error: 'Nenhum arquivo selecionado' };
  }

  if (!ALLOWED_TYPES.includes(file.type)) {
    return { valid: false, error: 'Formato inválido. Use PNG ou JPG' };
  }

  if (file.size > MAX_SIZE) {
    return { valid: false, error: 'Arquivo muito grande. Máximo 5MB' };
  }

  return { valid: true };
};

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
  const [croppedLogoBase64, setCroppedLogoBase64] = useState('');
  const [isEditorOpen, setIsEditorOpen] = useState(false);
  const [selectedImageFile, setSelectedImageFile] = useState(null);
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
      setMessage({ 
        type: 'error', 
        text: 'Erro ao carregar configurações. Tente recarregar a página.' 
      });
    }
  };

  const handleLogoChange = (e) => {
    const file = e.target.files[0];
    if (!file) {
      console.log('Settings: No file selected');
      return;
    }

    console.log('Settings: File selected:', file.name, 'Size:', file.size, 'Type:', file.type);

    // Validar arquivo usando função de validação
    const validation = validateFile(file);
    if (!validation.valid) {
      console.log('Settings: File validation failed:', validation.error);
      setMessage({ type: 'error', text: validation.error });
      // Limpar o input para permitir selecionar o mesmo arquivo novamente
      e.target.value = '';
      return;
    }

    console.log('Settings: File validated, opening editor');
    
    // Limpar estados anteriores
    setCroppedLogoBase64('');
    
    // Abrir editor com a imagem selecionada
    setSelectedImageFile(file);
    setLogoFile(file);
    setIsEditorOpen(true);
    setMessage({ type: '', text: '' });
    
    // Limpar o input para permitir selecionar o mesmo arquivo novamente
    e.target.value = '';
  };

  const handleEditorSave = (croppedBase64) => {
    try {
      // Validar se recebemos uma imagem válida
      if (!croppedBase64 || !croppedBase64.startsWith('data:image/')) {
        throw new Error('Imagem inválida gerada pelo editor');
      }

      // Receber imagem cropada do editor
      setCroppedLogoBase64(croppedBase64);
      setLogoPreview(croppedBase64);
      setIsEditorOpen(false);
      setMessage({ type: 'success', text: 'Logo editada com sucesso! Clique em "Atualizar Logo" para salvar.' });
      setTimeout(() => setMessage({ type: '', text: '' }), 3000);
    } catch (error) {
      console.error('Erro ao processar imagem do editor:', error);
      setMessage({ type: 'error', text: 'Erro ao processar imagem. Tente novamente.' });
      setIsEditorOpen(false);
    }
  };

  const handleEditorClose = () => {
    setIsEditorOpen(false);
  };

  const handleUploadLogo = async () => {
    if (!croppedLogoBase64) {
      setMessage({ type: 'error', text: 'Selecione e edite uma imagem primeiro' });
      return;
    }

    setLoading(true);
    setMessage({ type: '', text: '' });

    try {
      // Usar a imagem cropada circular do editor
      const response = await axios.post(
        `${API_URL}/store-settings/${STORE_ID}/logo`,
        { logoUrl: croppedLogoBase64 },
        { timeout: 30000 } // 30 segundos de timeout
      );

      if (response.data.success) {
        setMessage({ type: 'success', text: 'Logo atualizada com sucesso!' });
        setSettings(response.data.data);
        setLogoFile(null);
        setCroppedLogoBase64('');
        setTimeout(() => setMessage({ type: '', text: '' }), 3000);
      }
    } catch (error) {
      console.error('Erro ao fazer upload:', error);
      
      // Tratamento de erros específicos
      let errorMsg = 'Erro ao fazer upload da logo';
      
      if (error.code === 'ECONNABORTED' || error.message.includes('timeout')) {
        errorMsg = 'Tempo de upload excedido. Verifique sua conexão e tente novamente.';
      } else if (error.response) {
        // Erro do servidor
        errorMsg = error.response.data?.message || `Erro no servidor: ${error.response.status}`;
      } else if (error.request) {
        // Sem resposta do servidor
        errorMsg = 'Sem resposta do servidor. Verifique sua conexão com a internet.';
      }
      
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
            {/* Preview da Logo - Circular */}
            <div className="flex justify-center items-center h-40 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300">
              {logoPreview ? (
                <div className="relative w-32 h-32 rounded-full overflow-hidden border-4 border-white shadow-lg animate-scaleIn">
                  <img
                    src={logoPreview}
                    alt="Logo Preview"
                    className="w-full h-full object-cover transition-transform duration-300 hover:scale-110"
                  />
                </div>
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
              <label htmlFor="logo-file-input" className="block text-sm font-medium text-gray-700 mb-2">
                Selecionar Logo
              </label>
              <input
                id="logo-file-input"
                type="file"
                accept="image/png,image/jpeg,image/jpg"
                onChange={handleLogoChange}
                className="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                aria-label="Selecionar arquivo de logo"
              />
              <p className="mt-2 text-xs text-gray-500">
                PNG ou JPG (máximo 5MB). A logo será exibida em formato circular no app.
              </p>
            </div>

            {/* Botão de upload */}
            <button
              onClick={handleUploadLogo}
              disabled={loading || !croppedLogoBase64}
              className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all duration-150 disabled:bg-gray-400 disabled:cursor-not-allowed"
              aria-label="Atualizar logo da loja"
            >
              {loading ? 'Enviando...' : 'Atualizar Logo'}
            </button>
          </div>
        </div>

        {/* Logo Editor Modal */}
        <LogoEditorModal
          isOpen={isEditorOpen}
          onClose={handleEditorClose}
          onSave={handleEditorSave}
          imageFile={selectedImageFile}
        />

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
              className="w-full bg-green-600 text-white py-2 rounded-lg hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2 transition-all duration-150 disabled:bg-gray-400 disabled:cursor-not-allowed"
              aria-label="Salvar informações da loja"
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
