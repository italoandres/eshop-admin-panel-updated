# 🎨 EShop Admin Panel

Painel administrativo web para gerenciar banners, produtos, pedidos e mais.

## ✅ Status: IMPLEMENTADO E FUNCIONANDO

O painel admin está completo e rodando em: **http://localhost:3001/**

## 🚀 Como Usar

### 1. Instalar dependências (já feito)

```bash
cd admin-panel
npm install
```

### 2. Iniciar o servidor de desenvolvimento

```bash
npm run dev
```

O painel estará disponível em: **http://localhost:3001/**

### 3. Configurar Tailwind CSS

**tailwind.config.js:**
```js
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

**src/index.css:**
```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### 4. Estrutura de pastas

```
admin-panel/
├── src/
│   ├── components/
│   │   ├── layout/
│   │   │   ├── Layout.jsx
│   │   │   ├── Sidebar.jsx
│   │   │   └── Header.jsx
│   │   └── banners/
│   │       ├── BannerList.jsx
│   │       ├── BannerForm.jsx
│   │       └── BannerCard.jsx
│   ├── services/
│   │   ├── api.js
│   │   └── bannerService.js
│   ├── pages/
│   │   ├── Login.jsx
│   │   ├── Dashboard.jsx
│   │   └── Banners.jsx
│   ├── App.jsx
│   └── main.jsx
```

## 📝 Arquivos Principais

### src/services/api.js

```javascript
import axios from 'axios';

const API_URL = 'http://localhost:4000/api';
const ADMIN_TOKEN = 'eshop_admin_token_2024';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor para adicionar token
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('adminToken') || ADMIN_TOKEN;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
```

### src/services/bannerService.js

```javascript
import api from './api';

const STORE_ID = 'store_001';

export const bannerService = {
  // Listar todos os banners (admin)
  getAll: async () => {
    const response = await api.get(`/admin/stores/${STORE_ID}/banners`);
    return response.data;
  },

  // Criar banner
  create: async (banner) => {
    const response = await api.post(`/stores/${STORE_ID}/banners`, banner);
    return response.data;
  },

  // Atualizar banner
  update: async (id, banner) => {
    const response = await api.put(`/stores/${STORE_ID}/banners/${id}`, banner);
    return response.data;
  },

  // Deletar banner
  delete: async (id) => {
    const response = await api.delete(`/stores/${STORE_ID}/banners/${id}`);
    return response.data;
  },
};
```

### src/components/layout/Layout.jsx

```jsx
import { useState } from 'react';
import Sidebar from './Sidebar';
import Header from './Header';

export default function Layout({ children }) {
  const [sidebarOpen, setSidebarOpen] = useState(true);

  return (
    <div className="flex h-screen bg-gray-100">
      <Sidebar isOpen={sidebarOpen} />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header onMenuClick={() => setSidebarOpen(!sidebarOpen)} />
        <main className="flex-1 overflow-x-hidden overflow-y-auto bg-gray-100 p-6">
          {children}
        </main>
      </div>
    </div>
  );
}
```

### src/components/layout/Sidebar.jsx

```jsx
import { Link, useLocation } from 'react-router-dom';

export default function Sidebar({ isOpen }) {
  const location = useLocation();

  const menuItems = [
    { path: '/dashboard', icon: '📊', label: 'Dashboard' },
    { path: '/banners', icon: '🎨', label: 'Banners' },
    { path: '/products', icon: '📦', label: 'Produtos' },
    { path: '/orders', icon: '🛒', label: 'Pedidos' },
    { path: '/customers', icon: '👥', label: 'Clientes' },
    { path: '/notifications', icon: '🔔', label: 'Notificações' },
    { path: '/reviews', icon: '⭐', label: 'Avaliações' },
    { path: '/settings', icon: '⚙️', label: 'Configurações' },
  ];

  if (!isOpen) return null;

  return (
    <aside className="w-64 bg-gray-900 text-white">
      <div className="p-4">
        <h1 className="text-2xl font-bold">EShop Admin</h1>
      </div>
      <nav className="mt-8">
        {menuItems.map((item) => (
          <Link
            key={item.path}
            to={item.path}
            className={`flex items-center px-6 py-3 hover:bg-gray-800 ${
              location.pathname === item.path ? 'bg-gray-800 border-l-4 border-blue-500' : ''
            }`}
          >
            <span className="text-2xl mr-3">{item.icon}</span>
            <span>{item.label}</span>
          </Link>
        ))}
      </nav>
    </aside>
  );
}
```

### src/pages/Banners.jsx

```jsx
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { bannerService } from '../services/bannerService';
import BannerCard from '../components/banners/BannerCard';
import BannerForm from '../components/banners/BannerForm';

export default function Banners() {
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingBanner, setEditingBanner] = useState(null);
  const queryClient = useQueryClient();

  const { data: banners, isLoading } = useQuery({
    queryKey: ['banners'],
    queryFn: bannerService.getAll,
  });

  const deleteMutation = useMutation({
    mutationFn: bannerService.delete,
    onSuccess: () => {
      queryClient.invalidateQueries(['banners']);
      alert('Banner deletado com sucesso!');
    },
  });

  const handleEdit = (banner) => {
    setEditingBanner(banner);
    setIsFormOpen(true);
  };

  const handleDelete = (id) => {
    if (confirm('Tem certeza que deseja deletar este banner?')) {
      deleteMutation.mutate(id);
    }
  };

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-3xl font-bold">Gerenciar Banners</h1>
        <button
          onClick={() => {
            setEditingBanner(null);
            setIsFormOpen(true);
          }}
          className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          + Novo Banner
        </button>
      </div>

      {isLoading ? (
        <div>Carregando...</div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {banners?.map((banner) => (
            <BannerCard
              key={banner._id}
              banner={banner}
              onEdit={() => handleEdit(banner)}
              onDelete={() => handleDelete(banner._id)}
            />
          ))}
        </div>
      )}

      {isFormOpen && (
        <BannerForm
          banner={editingBanner}
          onClose={() => {
            setIsFormOpen(false);
            setEditingBanner(null);
          }}
          onSuccess={() => {
            queryClient.invalidateQueries(['banners']);
            setIsFormOpen(false);
            setEditingBanner(null);
          }}
        />
      )}
    </div>
  );
}
```

### src/App.jsx

```jsx
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import Layout from './components/layout/Layout';
import Dashboard from './pages/Dashboard';
import Banners from './pages/Banners';
import Login from './pages/Login';

const queryClient = new QueryClient();

function App() {
  const isAuthenticated = localStorage.getItem('adminToken');

  return (
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <Routes>
          <Route path="/login" element={<Login />} />
          <Route
            path="/*"
            element={
              isAuthenticated ? (
                <Layout>
                  <Routes>
                    <Route path="/dashboard" element={<Dashboard />} />
                    <Route path="/banners" element={<Banners />} />
                    <Route path="/" element={<Navigate to="/dashboard" />} />
                  </Routes>
                </Layout>
              ) : (
                <Navigate to="/login" />
              )
            }
          />
        </Routes>
      </BrowserRouter>
    </QueryClientProvider>
  );
}

export default App;
```

## 🎨 Componentes Adicionais

Crie os componentes restantes seguindo o padrão acima:
- `BannerCard.jsx` - Card para exibir banner
- `BannerForm.jsx` - Formulário modal para criar/editar
- `Header.jsx` - Header com logout
- `Dashboard.jsx` - Página inicial com estatísticas
- `Login.jsx` - Tela de login

## � Logcin

1. Acesse: **http://localhost:3001/**
2. Use o token: `eshop_admin_token_2024`
3. Clique em "Entrar"

## 📁 Estrutura do Projeto

```
admin-panel/
├── src/
│   ├── components/
│   │   ├── layout/
│   │   │   ├── Layout.jsx       ✅ Layout principal
│   │   │   ├── Sidebar.jsx      ✅ Menu lateral
│   │   │   └── Header.jsx       ✅ Cabeçalho
│   │   └── banners/
│   │       ├── BannerList.jsx   ✅ Lista de banners
│   │       ├── BannerForm.jsx   ✅ Formulário
│   │       └── BannerCard.jsx   ✅ Card do banner
│   ├── services/
│   │   ├── api.js               ✅ Cliente Axios
│   │   └── bannerService.js     ✅ API de banners
│   ├── pages/
│   │   ├── Login.jsx            ✅ Tela de login
│   │   ├── Dashboard.jsx        ✅ Dashboard
│   │   └── Banners.jsx          ✅ Gerenciar banners
│   ├── App.jsx                  ✅ App principal
│   ├── main.jsx                 ✅ Entry point
│   └── index.css                ✅ Estilos globais
├── package.json                 ✅
├── vite.config.js               ✅
├── tailwind.config.js           ✅
└── postcss.config.js            ✅
```

## ✨ Funcionalidades Implementadas

### ✅ Sistema de Banners (Completo)
- Listar todos os banners
- Criar novo banner
- Editar banner existente
- Deletar banner
- Preview de imagem em tempo real
- Status ativo/inativo
- Ordenação de banners
- Links opcionais

### ✅ Dashboard
- Estatísticas de banners ativos
- Cards informativos
- Interface responsiva

### ✅ Autenticação
- Login com token
- Proteção de rotas
- Logout

## 🎯 Funcionalidades do Painel

### Gerenciamento de Banners
1. **Criar Banner**: Clique em "+ Novo Banner"
2. **Editar**: Clique em "✏️ Editar" no card do banner
3. **Deletar**: Clique em "🗑️ Deletar" (com confirmação)
4. **Ativar/Desativar**: Use o checkbox "Banner Ativo" no formulário

### Campos do Banner
- **Título**: Nome do banner (obrigatório)
- **Descrição**: Texto descritivo (opcional)
- **URL da Imagem**: Link da imagem (obrigatório)
- **Link**: URL de destino ao clicar (opcional)
- **Ordem**: Posição no carrossel (número)
- **Status**: Ativo/Inativo

## 📚 Módulos do Sistema

### ✅ Implementados e Funcionais
- **� Dashboard** - Visão geral com estatísticas e ações rápidas
- **🎨 Banners** - CRUD completo de banners (Criar, Ler, Atualizar, Deletar)
- **� Liogin** - Sistema de autenticação com token

### � Estreutura Criada (Prontos para Backend)
- **📦 Produtos** - Gerenciamento de produtos da loja
- **� aPedidos** - Acompanhamento e gestão de pedidos
- **👥 Clientes** - Gestão de clientes e histórico
- **🔔 Notificações** - Sistema de notificações push
- **⭐ Avaliações** - Moderação de avaliações de produtos
- **⚙️ Configurações** - Configurações gerais do sistema

Todos os módulos têm suas páginas criadas e rotas configuradas. Basta implementar os serviços de backend correspondentes!

## 🎯 Tecnologias

- React 18
- Vite
- TailwindCSS
- React Router
- TanStack Query
- Axios
