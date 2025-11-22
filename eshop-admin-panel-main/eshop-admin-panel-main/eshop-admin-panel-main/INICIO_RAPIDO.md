# 🚀 Início Rápido - EShop Admin Panel

## ⚡ 3 Passos para Começar

### 1️⃣ Inicie o Backend
```bash
cd backend
npm run dev
```
✅ Backend rodando em: **http://localhost:4000**

---

### 2️⃣ Inicie o Admin Panel
```bash
cd admin-panel
npm run dev
```
✅ Admin Panel rodando em: **http://localhost:3000**

---

### 3️⃣ Faça Login
1. Abra: **http://localhost:3000**
2. Digite o token: `eshop_admin_token_2024`
3. Clique em **"Entrar"**

---

## 🎨 Testando o Sistema de Banners

### Criar um Banner
1. Clique em **"Banners"** no menu lateral
2. Clique em **"+ Novo Banner"**
3. Preencha:
   - **Título:** "Promoção de Verão"
   - **Descrição:** "Até 50% OFF"
   - **URL da Imagem:** `https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Promo+Verao`
   - **Link:** (opcional)
   - **Ordem:** 0
   - **Banner Ativo:** ✅ Marcado
4. Clique em **"Criar"**

### Editar um Banner
1. Encontre o banner na lista
2. Clique em **"✏️ Editar"**
3. Modifique os campos
4. Clique em **"Atualizar"**

### Deletar um Banner
1. Encontre o banner na lista
2. Clique em **"🗑️ Deletar"**
3. Confirme a exclusão

---

## 📱 URLs de Teste para Imagens

Use estas URLs para testar rapidamente:

```
Banner 1 (Vermelho):
https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Banner+1

Banner 2 (Verde):
https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=Banner+2

Banner 3 (Azul):
https://via.placeholder.com/800x400/45B7D1/FFFFFF?text=Banner+3

Banner 4 (Roxo):
https://via.placeholder.com/800x400/9B59B6/FFFFFF?text=Banner+4
```

---

## 🗺️ Navegação no Painel

### Menu Lateral
```
📊 Dashboard      → Visão geral
🎨 Banners        → Gerenciar banners (FUNCIONAL)
📦 Produtos       → Em breve
🛒 Pedidos        → Em breve
👥 Clientes       → Em breve
🔔 Notificações   → Em breve
⭐ Avaliações     → Em breve
⚙️ Configurações  → Interface pronta
```

---

## 🎯 Funcionalidades Principais

### ✅ O Que Funciona Agora
- ✅ Login/Logout
- ✅ Dashboard com estatísticas
- ✅ Criar banners
- ✅ Editar banners
- ✅ Deletar banners
- ✅ Listar banners
- ✅ Preview de imagens
- ✅ Status ativo/inativo
- ✅ Ordenação

### 🚧 Em Desenvolvimento
- 🚧 Produtos
- 🚧 Pedidos
- 🚧 Clientes
- 🚧 Notificações
- 🚧 Avaliações

---

## 🐛 Problemas Comuns

### ❌ Erro: "Cannot connect to backend"
**Solução:** Verifique se o backend está rodando em http://localhost:4000

### ❌ Erro: "Token inválido"
**Solução:** Use o token correto: `eshop_admin_token_2024`

### ❌ Banners não aparecem
**Solução:** 
1. Verifique se o backend está rodando
2. Abra o console do navegador (F12)
3. Verifique se há erros

### ❌ Imagem não carrega
**Solução:** Verifique se a URL da imagem está correta e acessível

---

## 📚 Documentação Completa

Para mais detalhes, consulte:

1. **README.md** - Documentação técnica completa
2. **GUIA_RAPIDO.md** - Guia detalhado de uso
3. **IMPLEMENTACAO_COMPLETA.md** - Detalhes da implementação
4. **STATUS.md** - Status visual do projeto
5. **RESUMO_EXECUTIVO.md** - Resumo executivo

---

## 💡 Dicas Úteis

### Atalhos do Navegador
- **F12** - Abrir DevTools
- **Ctrl + R** - Recarregar página
- **Ctrl + Shift + R** - Recarregar sem cache

### Testando no Flutter
1. Certifique-se que o backend está rodando
2. Crie alguns banners no painel
3. Abra o app Flutter
4. Veja os banners no carrossel da home!

### Limpando o Cache
Se algo não funcionar:
```javascript
// No console do navegador (F12)
localStorage.clear()
location.reload()
```

---

## 🎉 Pronto!

Agora você está pronto para usar o **EShop Admin Panel**!

### Próximos Passos
1. ✅ Criar alguns banners de teste
2. ✅ Testar edição e exclusão
3. ✅ Verificar no app Flutter
4. ✅ Explorar outros módulos

---

## 📞 Precisa de Ajuda?

1. Consulte a documentação completa
2. Verifique o console do navegador (F12)
3. Verifique os logs do backend
4. Revise o GUIA_RAPIDO.md

---

**Desenvolvido com ❤️ para o EShop**

```
╔═══════════════════════════════════════════════════════╗
║                                                       ║
║  🚀 Bem-vindo ao EShop Admin Panel!                  ║
║                                                       ║
║  Comece criando seu primeiro banner agora!           ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝
```
