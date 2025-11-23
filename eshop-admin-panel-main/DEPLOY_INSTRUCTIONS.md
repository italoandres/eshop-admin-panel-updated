# 🚀 Instruções de Deploy - Admin Panel

## 📦 Este é o Admin Panel do E-Shop

Para fazer deploy no Vercel, siga os passos abaixo:

---

## ✅ Opção 1: Deploy Direto (Se este for um repositório separado)

1. Acesse: https://vercel.com
2. Click em "Add New..." → "Project"
3. Selecione este repositório
4. Configuração:
   - **Framework**: Vite
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
5. Adicione variável de ambiente:
   ```
   VITE_API_URL=https://eshop-backend-bfhw.onrender.com/api
   ```
6. Click em "Deploy"

---

## 🔄 Opção 2: Criar Repositório Separado (Se ainda não fez)

### No GitHub:
1. Crie novo repositório: `eshop-admin-panel`
2. Não inicialize com README

### No Terminal:
```bash
# Navegar para esta pasta
cd admin-panel

# Inicializar git
git init

# Adicionar arquivos
git add .

# Commit
git commit -m "Initial commit: Admin Panel"

# Adicionar remote (SUBSTITUA SEU_USUARIO)
git remote add origin https://github.com/SEU_USUARIO/eshop-admin-panel.git

# Push
git branch -M main
git push -u origin main
```

Depois siga a Opção 1 acima.

---

## 🔧 Configuração da API

O admin panel se conecta ao backend através da variável de ambiente:

```env
VITE_API_URL=https://eshop-backend-bfhw.onrender.com/api
```

Para desenvolvimento local, use:
```env
VITE_API_URL=http://localhost:4000/api
```

---

## 🧪 Testar Localmente

```bash
# Instalar dependências
npm install

# Rodar em desenvolvimento
npm run dev

# Build para produção
npm run build

# Preview do build
npm run preview
```

---

## 📋 Estrutura do Projeto

```
admin-panel/
├── src/
│   ├── components/     # Componentes React
│   ├── pages/          # Páginas
│   ├── services/       # API services
│   ├── config/         # Configurações
│   └── App.jsx         # App principal
├── public/             # Arquivos estáticos
├── package.json        # Dependências
├── vite.config.js      # Config do Vite
└── vercel.json         # Config do Vercel
```

---

## 🌐 URLs

- **Backend API**: https://eshop-backend-bfhw.onrender.com
- **Admin Panel**: (será gerado após deploy no Vercel)

---

## 📞 Suporte

Veja os guias na raiz do projeto:
- `GUIA_DEPLOY_VERCEL.md`
- `SOLUCAO_ERRO_VERCEL.md`
- `SOLUCAO_REPOSITORIO_SEPARADO.md`

---

**Boa sorte com o deploy! 🚀**
