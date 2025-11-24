# 🚀 Guia Completo de Deploy - EShop Backend

Este guia te ensina a fazer deploy do backend em diferentes plataformas.

---

## 📋 Índice

1. [Deploy no Render.com (Recomendado)](#1-deployno-rendercom)
2. [Deploy no Railway.app](#2-deploy-no-railwayapp)
3. [Deploy no Heroku](#3-deploy-no-heroku)
4. [Deploy em VPS (AWS, Digital Ocean, etc)](#4-deploy-em-vps)
5. [Configuração de Domínio Customizado](#5-domínio-customizado)
6. [Troubleshooting](#6-troubleshooting)

---

## 1. Deploy no Render.com

### Por que Render?
- ✅ **Grátis** até 750h/mês
- ✅ Deploy automático via Git
- ✅ SSL grátis
- ✅ Fácil de usar
- ✅ Sem cartão de crédito

### Passo a passo

#### 1.1 Criar conta no Render

1. Acesse https://render.com
2. Clique em "Get Started for Free"
3. Crie conta com GitHub/GitLab/Email

#### 1.2 Preparar repositório

O código precisa estar em um repositório Git (GitHub, GitLab, etc).

\`\`\`bash
# Se ainda não tem
git init
git add .
git commit -m "Initial commit"
git remote add origin <seu-repo-url>
git push -u origin main
\`\`\`

#### 1.3 Criar Web Service

1. No dashboard do Render, clique em "New +"
2. Selecione "Web Service"
3. Conecte seu repositório
4. Selecione o repositório do backend
5. Configure:

**Name:** `eshop-backend` (ou nome da sua loja)
**Region:** Oregon (US West) - mais próximo do Brasil
**Branch:** `main`
**Root Directory:** `backend`
**Runtime:** `Node`
**Build Command:**
\`\`\`bash
npm install && npm run build
\`\`\`

**Start Command:**
\`\`\`bash
npm start
\`\`\`

**Plan:** Free

#### 1.4 Configurar Variáveis de Ambiente

Na seção "Environment Variables", adicione:

\`\`\`bash
NODE_ENV=production
PORT=5000

# MongoDB Atlas (crie em mongodb.com/cloud/atlas)
MONGODB_URI=mongodb+srv://usuario:senha@cluster.mongodb.net/eshop

# JWT Secrets (gere com: openssl rand -base64 32)
JWT_SECRET=sua_chave_secreta_forte_aqui
JWT_REFRESH_SECRET=outra_chave_secreta_forte_aqui
JWT_EXPIRES_IN=7d
JWT_REFRESH_EXPIRES_IN=30d

# Cloudinary (crie em cloudinary.com)
CLOUDINARY_CLOUD_NAME=seu_cloud_name
CLOUDINARY_API_KEY=sua_api_key
CLOUDINARY_API_SECRET=sua_api_secret

# CORS (URLs do seu frontend)
CORS_ORIGIN=https://seu-app.netlify.app,https://seu-admin.vercel.app

# Opcional
DEFAULT_STORE_ID=eshop_001
STORE_NAME=EShop
ADMIN_TOKEN=eshop_admin_token_2024
\`\`\`

#### 1.5 Deploy!

1. Clique em "Create Web Service"
2. Aguarde o build (3-5 minutos)
3. Quando aparecer "Live", seu backend está no ar! 🎉

**URL gerada:** `https://eshop-backend.onrender.com`

#### 1.6 Testar

\`\`\`bash
curl https://eshop-backend.onrender.com/health
\`\`\`

Deve retornar:
\`\`\`json
{
  "status": "ok",
  "timestamp": "2024-01-15T12:00:00.000Z",
  "environment": "production",
  "uptime": 123.45
}
\`\`\`

---

## 2. Deploy no Railway.app

### Por que Railway?
- ✅ Interface moderna
- ✅ $5 grátis por mês
- ✅ Deploy rápido
- ✅ PostgreSQL/MongoDB inclusos

### Passo a passo

#### 2.1 Criar conta

1. Acesse https://railway.app
2. Clique em "Start a New Project"
3. Faça login com GitHub

#### 2.2 Deploy do código

1. Clique em "Deploy from GitHub repo"
2. Selecione seu repositório
3. Railway detecta automaticamente Node.js

#### 2.3 Configurar variáveis

1. Vá em "Variables"
2. Clique em "RAW Editor"
3. Cole:

\`\`\`bash
NODE_ENV=production
MONGODB_URI=mongodb+srv://...
JWT_SECRET=...
JWT_REFRESH_SECRET=...
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...
CORS_ORIGIN=...
\`\`\`

#### 2.4 Deploy automático

Railway faz deploy automaticamente! Aguarde 2-3 minutos.

**URL gerada:** `https://eshop-backend-production.up.railway.app`

---

## 3. Deploy no Heroku

### Pré-requisitos
- Conta no Heroku
- Heroku CLI instalado

### Passo a passo

#### 3.1 Instalar Heroku CLI

\`\`\`bash
# macOS
brew tap heroku/brew && brew install heroku

# Linux
curl https://cli-assets.heroku.com/install.sh | sh
\`\`\`

#### 3.2 Login

\`\`\`bash
heroku login
\`\`\`

#### 3.3 Criar app

\`\`\`bash
cd backend
heroku create eshop-backend
\`\`\`

#### 3.4 Configurar variáveis

\`\`\`bash
heroku config:set NODE_ENV=production
heroku config:set MONGODB_URI=mongodb+srv://...
heroku config:set JWT_SECRET=...
heroku config:set JWT_REFRESH_SECRET=...
heroku config:set CLOUDINARY_CLOUD_NAME=...
heroku config:set CLOUDINARY_API_KEY=...
heroku config:set CLOUDINARY_API_SECRET=...
heroku config:set CORS_ORIGIN=...
\`\`\`

#### 3.5 Deploy

\`\`\`bash
git push heroku main
\`\`\`

**URL gerada:** `https://eshop-backend.herokuapp.com`

---

## 4. Deploy em VPS

### Opções de VPS
- Digital Ocean ($5/mês)
- AWS Lightsail ($3.50/mês)
- Linode ($5/mês)
- Vultr ($2.50/mês)

### Passo a passo (Ubuntu 22.04)

#### 4.1 Conectar via SSH

\`\`\`bash
ssh root@seu-ip
\`\`\`

#### 4.2 Instalar Node.js

\`\`\`bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
\`\`\`

#### 4.3 Instalar MongoDB (Opcional)

\`\`\`bash
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod
\`\`\`

#### 4.4 Clonar repositório

\`\`\`bash
cd /var/www
git clone <seu-repo-url>
cd backend
npm install
npm run build
\`\`\`

#### 4.5 Configurar .env

\`\`\`bash
nano .env
\`\`\`

Cole suas variáveis de ambiente.

#### 4.6 Instalar PM2 (Process Manager)

\`\`\`bash
npm install -g pm2
pm2 start dist/server.js --name eshop-backend
pm2 startup
pm2 save
\`\`\`

#### 4.7 Configurar Nginx (Reverse Proxy)

\`\`\`bash
sudo apt-get install -y nginx

sudo nano /etc/nginx/sites-available/eshop
\`\`\`

Cole:

\`\`\`nginx
server {
    listen 80;
    server_name seu-dominio.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
\`\`\`

Ativar:

\`\`\`bash
sudo ln -s /etc/nginx/sites-available/eshop /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
\`\`\`

#### 4.8 Configurar SSL com Certbot

\`\`\`bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d seu-dominio.com
\`\`\`

---

## 5. Domínio Customizado

### Render/Railway/Heroku

#### 5.1 Comprar domínio

Opções:
- Registro.br (Brasil) - R$ 40/ano
- Namecheap - $8.88/ano
- GoDaddy - $11.99/ano

#### 5.2 Configurar DNS

No painel do seu domínio, adicione um registro CNAME:

\`\`\`
Type: CNAME
Name: api (ou backend)
Value: seu-app.onrender.com
TTL: 3600
\`\`\`

#### 5.3 Adicionar domínio customizado

**Render:**
1. Vá em Settings
2. Custom Domains
3. Adicione: `api.seu-dominio.com`
4. Render configura SSL automaticamente

**Railway:**
1. Settings → Domains
2. Generate Domain ou adicione customizado

**Heroku:**
\`\`\`bash
heroku domains:add api.seu-dominio.com
\`\`\`

---

## 6. Troubleshooting

### ❌ Erro: "Application failed to start"

**Causa:** Variáveis de ambiente faltando

**Solução:** Verifique se todas as variáveis estão configuradas:
\`\`\`bash
MONGODB_URI
JWT_SECRET
JWT_REFRESH_SECRET
CLOUDINARY_CLOUD_NAME
CLOUDINARY_API_KEY
CLOUDINARY_API_SECRET
\`\`\`

---

### ❌ Erro: "Cannot connect to MongoDB"

**Causa:** Connection string inválida ou IP não autorizado

**Solução:**
1. MongoDB Atlas → Network Access
2. Adicione IP: `0.0.0.0/0` (permite todos)
3. Ou adicione IP do Render/Railway

---

### ❌ Erro: "CORS blocked"

**Causa:** Frontend não está na whitelist do CORS

**Solução:** Adicione URL do frontend no `.env`:
\`\`\`bash
CORS_ORIGIN=https://seu-frontend.com,https://admin.vercel.app
\`\`\`

---

### ❌ Erro: "Rate limit exceeded"

**Causa:** Muitas requisições do mesmo IP

**Solução:** Aumente o limite no `.env`:
\`\`\`bash
RATE_LIMIT_MAX_REQUESTS=200
\`\`\`

---

### ❌ App "dorme" depois de inatividade (Render Free)

**Causa:** Plano gratuito do Render hiberna após 15 min

**Solução:**
1. Upgrade para plano pago ($7/mês)
2. Ou use serviço de "keep-alive": https://cron-job.org

---

### ❌ Logs não aparecem

**Solução:**

**Render:** Vá em "Logs" no dashboard

**Railway:** Terminal integrado

**Heroku:**
\`\`\`bash
heroku logs --tail
\`\`\`

**VPS:**
\`\`\`bash
pm2 logs eshop-backend
\`\`\`

---

## 🎉 Deploy Concluído!

Seu backend está no ar! Agora:

1. ✅ Teste todos os endpoints
2. ✅ Configure o Flutter app com a nova URL
3. ✅ Configure o Admin React com a nova URL
4. ✅ Faça um pedido de teste
5. 🚀 **Loja no ar!**

---

## 📞 Precisa de Ajuda?

- Render Docs: https://render.com/docs
- Railway Docs: https://docs.railway.app
- MongoDB Atlas: https://docs.atlas.mongodb.com
- Cloudinary Docs: https://cloudinary.com/documentation

---

**Tempo médio de deploy: 20-30 minutos** ⏱️
