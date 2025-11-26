# 🚀 Guia Definitivo - Auto-Deploy do GitHub no Netlify

## 📋 Situação Atual
- ✅ Site funcionando: https://sunny-lollipop-051661.netlify.app
- ✅ Deploy manual via CLI funciona perfeitamente
- ❌ Auto-deploy do GitHub falha por causa do submodule

## 🎯 Objetivo
Configurar auto-deploy do GitHub SEM problemas de submodule

---

## 📝 Passo a Passo (Faça no Netlify Dashboard)

### 1. Acesse o Netlify Dashboard
1. Vá para: https://app.netlify.com
2. Encontre o site: `sunny-lollipop-051661`
3. Clique nele

### 2. Conectar ao Repositório GitHub
1. Vá em **Site settings** (no menu lateral)
2. Clique em **Build & deploy**
3. Em **Continuous deployment**, clique em **Link repository**
4. Escolha **GitHub**
5. Autorize o Netlify (se necessário)
6. Selecione o repositório: `italoandres/eshop-admin-panel-updated`
7. Branch: `main`

### 3. Configurar Build Settings
Na mesma página de **Build & deploy**, configure:

**Base directory:**
```
eshop-admin-panel-main
```

**Build command:**
```
npm install && npm run build
```

**Publish directory:**
```
eshop-admin-panel-main/dist
```

### 4. Adicionar Variável de Ambiente (IMPORTANTE!)
1. Ainda em **Build & deploy**, vá para **Environment variables**
2. Clique em **Add a variable**
3. Adicione:
   - **Key:** `GIT_SUBMODULE_STRATEGY`
   - **Value:** `none`
4. Clique em **Save**

### 5. Fazer o Primeiro Deploy
1. Vá para **Deploys** (no menu lateral)
2. Clique em **Trigger deploy** → **Deploy site**
3. Aguarde o build terminar
4. Se der erro de submodule ainda, vá para o Passo 6

### 6. Plano B - Modificar Build Command (Se Passo 5 Falhar)
1. Volte em **Site settings** → **Build & deploy** → **Build settings**
2. Mude o **Build command** para:
```
git config --global submodule.recurse false && npm install && npm run build
```
3. Salve e faça novo deploy

---

## ✅ Resultado Esperado
Após configurar, toda vez que você fizer `git push` para o repositório `eshop-admin-panel-updated`, o Netlify vai:
1. Detectar o push automaticamente
2. Fazer build
3. Deploy automático

---

## 🔧 Troubleshooting

### Se ainda der erro de submodule:
Execute localmente para limpar o histórico:
```bash
cd eshop-admin-panel-main
git rm --cached admin-panel-clean 2>$null
git commit -m "Remove submodule reference"
git push origin main
```

### Se quiser testar antes de configurar:
Continue usando deploy manual:
```bash
cd eshop-admin-panel-main
netlify deploy --prod
```

---

## 📌 Notas Importantes
- O repositório `eshop-admin-panel-updated` está em: https://github.com/italoandres/eshop-admin-panel-updated
- A pasta `eshop-admin-panel-main` dentro dele é o projeto React
- O submodule `admin-panel-clean` não existe mais, mas o Git ainda tem referência
- A variável `GIT_SUBMODULE_STRATEGY=none` diz ao Netlify para ignorar submodules

---

**Última atualização:** 25/11/2025
