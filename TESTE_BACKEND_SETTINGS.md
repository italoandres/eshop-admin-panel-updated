# 🔍 TESTE BACKEND - SETTINGS

## ❌ PROBLEMA: Rota não encontrada

### Possíveis Causas:

1. **Backend não está rodando**
2. **MongoDB não está conectado**
3. **Porta errada**
4. **CORS bloqueando**

## 🧪 TESTES PARA FAZER

### 1. Verificar se Backend está rodando:

```bash
# No terminal do backend, deve mostrar:
✅ MongoDB conectado com sucesso!
🚀 Servidor rodando na porta 4000
📍 API disponível em: http://localhost:4000/api
```

### 2. Testar Health Check:

```bash
# No navegador ou terminal:
curl http://localhost:4000/health

# Deve retornar:
{"status":"OK","timestamp":"2025-11-14T..."}
```

### 3. Testar Rota de Settings:

```bash
# GET - Buscar configurações
curl http://localhost:4000/api/store-settings/eshop_001

# Deve retornar:
{
  "success": true,
  "data": {
    "storeId": "eshop_001",
    "storeName": "Minha Loja",
    ...
  }
}
```

### 4. Testar Upload de Logo:

```bash
# POST - Upload logo
curl -X POST http://localhost:4000/api/store-settings/eshop_001/logo \
  -H "Content-Type: application/json" \
  -d '{"logoUrl":"data:image/png;base64,iVBORw0KG..."}'

# Deve retornar:
{
  "success": true,
  "message": "Logo atualizada com sucesso",
  "data": {...}
}
```

## 🔧 SOLUÇÕES

### Solução 1: Reiniciar Backend

```bash
# Parar backend (Ctrl+C)
# Iniciar novamente:
cd backend
npm start
```

### Solução 2: Verificar MongoDB

```bash
# Verificar se MongoDB está rodando
# Windows:
services.msc
# Procurar por "MongoDB"

# Ou testar conexão:
mongosh
# Se conectar, MongoDB está OK
```

### Solução 3: Verificar Porta

```bash
# Verificar se porta 4000 está em uso:
netstat -ano | findstr :4000

# Se estiver ocupada, matar processo ou mudar porta
```

### Solução 4: Verificar .env

```bash
# backend/.env deve ter:
MONGODB_URI=mongodb://localhost:27017/ecommerce
PORT=4000
```

## 📝 CHECKLIST DE DEBUGGING

- [ ] Backend está rodando?
- [ ] MongoDB está conectado?
- [ ] Health check funciona?
- [ ] Rota GET /api/store-settings/:storeId funciona?
- [ ] Console do backend mostra logs?
- [ ] Console do navegador mostra erros?
- [ ] Network tab mostra request?

## 🐛 ERROS COMUNS

### Erro: "Rota não encontrada"
**Causa**: Backend não está rodando ou rota errada
**Solução**: Reiniciar backend e verificar URL

### Erro: "Network Error"
**Causa**: Backend não acessível
**Solução**: Verificar se backend está na porta 4000

### Erro: "CORS"
**Causa**: CORS bloqueando request
**Solução**: Já configurado no server.js

### Erro: "MongoDB connection failed"
**Causa**: MongoDB não está rodando
**Solução**: Iniciar MongoDB

## 🚀 SOLUÇÃO RÁPIDA

Execute estes comandos em ordem:

```bash
# 1. Parar tudo
# Ctrl+C em todos os terminais

# 2. Iniciar MongoDB (se necessário)
# Windows: services.msc → MongoDB → Start

# 3. Iniciar Backend
cd backend
npm start

# Aguardar mensagens:
# ✅ MongoDB conectado
# 🚀 Servidor rodando

# 4. Testar
curl http://localhost:4000/health

# 5. Iniciar Admin Panel
cd admin-panel
npm run dev

# 6. Acessar
# http://localhost:5000/settings
```

## 📊 LOG ESPERADO

### Backend Console:
```
✅ MongoDB conectado com sucesso!
🚀 Servidor rodando na porta 4000
📍 API disponível em: http://localhost:4000/api
2025-11-14T... - GET /api/store-settings/eshop_001
2025-11-14T... - POST /api/store-settings/eshop_001/logo
```

### Browser Console:
```
GET http://localhost:4000/api/store-settings/eshop_001 200 OK
POST http://localhost:4000/api/store-settings/eshop_001/logo 200 OK
```

## ✅ TESTE FINAL

1. Abrir `http://localhost:5000/settings`
2. Abrir DevTools (F12)
3. Ir para Network tab
4. Tentar fazer upload
5. Ver requests:
   - GET /api/store-settings/eshop_001
   - POST /api/store-settings/eshop_001/logo
6. Verificar status: 200 OK

Se tudo estiver OK, o upload deve funcionar! 🎉

---

**Próximo passo**: Me avise qual erro específico está aparecendo no console!
