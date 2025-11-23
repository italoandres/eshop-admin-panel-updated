# ✅ PAINEL ADMIN ATUALIZADO

## 🎯 O QUE FOI ATUALIZADO

### Configuração da API
- ✅ `.env.local` → Apontando para Render
- ✅ `.env.production` → Já estava correto
- ✅ `src/config/api.js` → Já tinha fallback correto

## 🚀 COMO USAR

### 1. Desenvolvimento Local

```bash
cd eshop-admin-panel-main/eshop-admin-panel-main/eshop-admin-panel-main
npm install
npm run dev
```

Acesse: `http://localhost:5173`

### 2. Deploy no Netlify

#### Opção A: Via GitHub (Recomendado)

1. **Criar repositório no GitHub**:
```bash
cd eshop-admin-panel-main/eshop-admin-panel-main/eshop-admin-panel-main
git init
git add .
git commit -m "Initial commit - Admin Panel"
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/eshop-admin-panel.git
git push -u origin main
```

2. **Conectar no Netlify**:
   - Acesse: https://app.netlify.com
   - New site → Import an existing project
   - Conecte o repositório
   - Build settings:
     - Build command: `npm run build`
     - Publish directory: `dist`
   - Deploy!

#### Opção B: Deploy Manual

```bash
npm run build
# Arraste a pasta 'dist' para o Netlify
```

### 3. Configurar Variáveis de Ambiente no Netlify

No Netlify Dashboard:
- Site settings → Environment variables
- Adicionar:
  ```
  VITE_API_URL=https://eshop-backend-bfhw.onrender.com/api
  VITE_ADMIN_TOKEN=eshop_admin_token_2024
  VITE_STORE_ID=store_001
  ```

## 🔐 Login

- **Token**: `eshop_admin_token_2024`

## 📝 Funcionalidades

- ✅ Gerenciar Banners
- ✅ Gerenciar Produtos
- ✅ Configurações da Loja
- ✅ Regras de Desconto

## 🌐 URLs

- **Backend API**: https://eshop-backend-bfhw.onrender.com
- **Painel Admin (Netlify)**: https://sunny-lollipop-051661.netlify.app
- **App Flutter**: http://localhost:8080

## ✅ TUDO PRONTO!

O painel está configurado e pronto para usar! 🎉
