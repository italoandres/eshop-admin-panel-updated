# 🛍️ EShop Backend - API REST

Backend white-label para e-commerce desenvolvido em **Node.js + Express + TypeScript + MongoDB**.

---

## 📋 Índice

- [Sobre](#sobre)
- [Stack Tecnológica](#stack-tecnológica)
- [Funcionalidades](#funcionalidades)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Executando](#executando)
- [Endpoints da API](#endpoints-da-api)
- [Deploy](#deploy)
- [Customização](#customização)

---

## 🎯 Sobre

Este é o backend de um sistema de e-commerce white-label. Cada cliente que comprar este código pode fazer deploy próprio e ter sua loja independente.

**Características principais:**
- ✅ Código-fonte completo e documentado
- ✅ Arquitetura escalável e limpa
- ✅ Upload de imagens no Cloudinary (sem base64!)
- ✅ Autenticação JWT segura
- ✅ Validação robusta com Zod
- ✅ Tratamento de erros profissional
- ✅ TypeScript para type-safety
- ✅ Pronto para produção

---

## 🚀 Stack Tecnológica

### Core
- **Node.js** v18+
- **TypeScript** 5.3
- **Express** 4.18

### Banco de Dados
- **MongoDB** com Mongoose

### Upload de Imagens
- **Cloudinary** (grátis até 25GB)
- **Multer** para multipart/form-data

### Segurança
- **Helmet** - Headers de segurança
- **CORS** - Proteção cross-origin
- **JWT** - Tokens de autenticação
- **bcrypt** - Hash de senhas
- **express-rate-limit** - Proteção contra abuso

### Validação
- **Zod** - Validação de schemas

---

## ⚡ Funcionalidades

### Autenticação
- ✅ Registro de usuários
- ✅ Login com JWT
- ✅ Refresh token automático
- ✅ Logout
- ✅ Proteção de rotas

### Banners
- ✅ CRUD completo
- ✅ Upload para Cloudinary (sem base64!)
- ✅ Ativar/desativar banners
- ✅ Ordenação customizada
- ✅ Rotas públicas (app) e admin

### Produtos
- ✅ CRUD completo
- ✅ Upload de múltiplas imagens
- ✅ Categorias e highlights
- ✅ Guia de tamanhos
- ✅ Paginação
- ✅ Busca textual
- ✅ Filtros por categoria

### Pedidos
- ✅ Criar pedido
- ✅ Listar pedidos do usuário
- ✅ Histórico de status
- ✅ Código de rastreamento
- ✅ Estatísticas (admin)
- ✅ Atualizar status (admin)

---

## 📁 Estrutura do Projeto

\`\`\`
backend/
├── src/
│   ├── config/              # Configurações (DB, Cloudinary, ENV)
│   ├── models/              # Mongoose schemas
│   ├── controllers/         # Business logic
│   ├── routes/              # Express routes
│   ├── middleware/          # Auth, error handling, upload
│   ├── services/            # Cloudinary, tokens
│   ├── types/               # TypeScript definitions
│   ├── utils/               # Helpers e errors
│   └── server.ts            # Entry point
├── .env.example             # Template de variáveis
├── package.json
├── tsconfig.json
└── README.md
\`\`\`

---

## 📦 Pré-requisitos

- **Node.js** v18 ou superior
- **MongoDB** (local ou MongoDB Atlas)
- **Conta Cloudinary** (grátis): https://cloudinary.com

---

## 🔧 Instalação

### 1. Clone o repositório

\`\`\`bash
git clone <seu-repositorio>
cd backend
\`\`\`

### 2. Instale as dependências

\`\`\`bash
npm install
\`\`\`

### 3. Configure as variáveis de ambiente

\`\`\`bash
cp .env.example .env
\`\`\`

Edite o arquivo `.env` com suas configurações.

---

## ⚙️ Configuração

### MongoDB

**Opção 1: MongoDB Atlas (Recomendado)**

1. Acesse https://www.mongodb.com/cloud/atlas
2. Crie uma conta gratuita
3. Crie um cluster
4. Crie um usuário de banco
5. Copie a connection string
6. Cole no `.env`:

\`\`\`bash
MONGODB_URI=mongodb+srv://usuario:senha@cluster.mongodb.net/eshop?retryWrites=true&w=majority
\`\`\`

**Opção 2: MongoDB Local**

\`\`\`bash
MONGODB_URI=mongodb://localhost:27017/eshop
\`\`\`

### Cloudinary

1. Acesse https://cloudinary.com
2. Crie uma conta gratuita (25GB grátis!)
3. Vá em Dashboard
4. Copie: Cloud Name, API Key, API Secret
5. Cole no `.env`:

\`\`\`bash
CLOUDINARY_CLOUD_NAME=seu_cloud_name
CLOUDINARY_API_KEY=sua_api_key
CLOUDINARY_API_SECRET=sua_api_secret
\`\`\`

### JWT Secret

Gere uma chave secreta forte:

\`\`\`bash
openssl rand -base64 32
\`\`\`

Cole no `.env`:

\`\`\`bash
JWT_SECRET=sua_chave_secreta_gerada
JWT_REFRESH_SECRET=outra_chave_secreta_gerada
\`\`\`

---

## 🚀 Executando

### Desenvolvimento

\`\`\`bash
npm run dev
\`\`\`

Servidor rodando em: http://localhost:5000

### Build para produção

\`\`\`bash
npm run build
npm start
\`\`\`

---

## 📡 Endpoints da API

### Base URL
\`\`\`
http://localhost:5000/api
\`\`\`

### Health Check
\`\`\`
GET /health
\`\`\`

### Autenticação

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| POST | `/auth/register` | Registrar usuário | ❌ |
| POST | `/auth/login` | Fazer login | ❌ |
| POST | `/auth/refresh` | Renovar token | ❌ |
| GET | `/auth/me` | Dados do usuário | ✅ |
| POST | `/auth/logout` | Fazer logout | ✅ |

### Banners (App)

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| GET | `/stores/:storeId/banners` | Lista banners ativos | ❌ |

### Banners (Admin)

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| GET | `/admin/stores/:storeId/banners/all` | Lista todos banners | ✅ Admin |
| GET | `/admin/stores/:storeId/banners/:id` | Busca banner | ✅ Admin |
| POST | `/admin/stores/:storeId/banners` | Cria banner | ✅ Admin |
| PUT | `/admin/stores/:storeId/banners/:id` | Atualiza banner | ✅ Admin |
| DELETE | `/admin/stores/:storeId/banners/:id` | Deleta banner | ✅ Admin |
| PATCH | `/admin/stores/:storeId/banners/:id/toggle` | Ativa/desativa | ✅ Admin |

### Produtos

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| GET | `/products` | Lista produtos | ❌ |
| GET | `/products/:id` | Busca produto | ❌ |
| POST | `/products` | Cria produto | ✅ Admin |
| PUT | `/products/:id` | Atualiza produto | ✅ Admin |
| DELETE | `/products/:id` | Deleta produto | ✅ Admin |
| PATCH | `/products/:id/toggle` | Ativa/desativa | ✅ Admin |

### Pedidos

| Método | Endpoint | Descrição | Auth |
|--------|----------|-----------|------|
| GET | `/orders` | Meus pedidos | ✅ |
| GET | `/orders/:id` | Detalhes do pedido | ✅ |
| POST | `/orders` | Criar pedido | ✅ |
| GET | `/orders/admin/all` | Todos pedidos | ✅ Admin |
| GET | `/orders/admin/stats` | Estatísticas | ✅ Admin |
| PATCH | `/orders/admin/:id/status` | Atualizar status | ✅ Admin |

---

## 🌐 Deploy

Consulte o arquivo **[DEPLOY_GUIDE.md](./DEPLOY_GUIDE.md)** para instruções completas de deploy em:

- ✅ Render.com
- ✅ Railway.app
- ✅ Heroku
- ✅ VPS (Digital Ocean, AWS, etc)

---

## 🎨 Customização

### Mudar nome da loja

No `.env`:

\`\`\`bash
DEFAULT_STORE_ID=minha_loja
STORE_NAME=Minha Loja Incrível
\`\`\`

### Mudar porta

\`\`\`bash
PORT=3000
\`\`\`

### Mudar CORS (permitir outros domínios)

\`\`\`bash
CORS_ORIGIN=https://meusite.com,https://admin.meusite.com
\`\`\`

### Adicionar novos campos em models

Edite os arquivos em `src/models/` e rode:

\`\`\`bash
npm run build
\`\`\`

---

## 🔒 Segurança

- ✅ Senhas hasheadas com bcrypt
- ✅ JWT com expiração
- ✅ Helmet para headers seguros
- ✅ Rate limiting contra abuso
- ✅ CORS configurado
- ✅ Validação de inputs com Zod
- ✅ MongoDB injection prevention

---

## 📝 Licença

Este código é vendido como produto white-label. Você tem direito de:
- ✅ Usar comercialmente
- ✅ Modificar livremente
- ✅ Fazer deploy ilimitado
- ❌ Revender o código-fonte

---

## 🆘 Suporte

Para dúvidas sobre o código, consulte:
1. Este README
2. DEPLOY_GUIDE.md
3. Comentários no código
4. Documentação do TypeScript/Express

---

## 🎉 Pronto para Vender!

Este backend está **100% pronto** para ser vendido a clientes. Basta:

1. Cliente configura `.env`
2. Cliente faz deploy (Render/Railway/Heroku)
3. Cliente integra com Flutter app e Admin React
4. 🚀 Loja no ar!

**Tempo estimado de setup: 30 minutos**
