# 📖 Guia Rápido - EShop Admin Panel

## 🚀 Iniciando

### 1. Certifique-se que o backend está rodando
```bash
cd backend
npm run dev
```
Backend deve estar em: http://localhost:4000

### 2. Inicie o painel admin
```bash
cd admin-panel
npm run dev
```
Painel estará em: http://localhost:3001

### 3. Faça login
- Acesse: http://localhost:3001
- Token: `eshop_admin_token_2024`

## 🎨 Gerenciando Banners

### Criar Novo Banner

1. Clique em **"+ Novo Banner"**
2. Preencha os campos:
   - **Título**: Ex: "Promoção de Verão"
   - **Descrição**: Ex: "Até 50% de desconto"
   - **URL da Imagem**: Cole o link da imagem
   - **Link**: URL para onde o banner leva (opcional)
   - **Ordem**: 0, 1, 2... (ordem de exibição)
   - **Banner Ativo**: Marque para ativar
3. Clique em **"Criar"**

### Editar Banner

1. Encontre o banner na lista
2. Clique em **"✏️ Editar"**
3. Modifique os campos desejados
4. Clique em **"Atualizar"**

### Deletar Banner

1. Encontre o banner na lista
2. Clique em **"🗑️ Deletar"**
3. Confirme a exclusão

### Ativar/Desativar Banner

1. Edite o banner
2. Marque/desmarque **"Banner Ativo"**
3. Salve as alterações

## 💡 Dicas

### URLs de Imagens de Teste
Você pode usar estas URLs para testar:
- https://via.placeholder.com/800x400/FF6B6B/FFFFFF?text=Banner+1
- https://via.placeholder.com/800x400/4ECDC4/FFFFFF?text=Banner+2
- https://via.placeholder.com/800x400/45B7D1/FFFFFF?text=Banner+3

### Ordem dos Banners
- Banners com ordem menor aparecem primeiro
- Use: 0, 1, 2, 3... para controlar a sequência
- No app Flutter, os banners são exibidos na ordem crescente

### Preview em Tempo Real
- Ao digitar a URL da imagem, o preview aparece automaticamente
- Se a imagem não carregar, verifique se a URL está correta

## 🔄 Sincronização com o App

Os banners criados aqui aparecem automaticamente no app Flutter:
1. Crie/edite banners no painel admin
2. Abra o app Flutter
3. Os banners são carregados automaticamente no carrossel da home

## 🐛 Solução de Problemas

### Erro ao criar banner
- Verifique se o backend está rodando
- Confirme que a URL da imagem é válida
- Verifique o console do navegador (F12)

### Banners não aparecem
- Verifique se há banners ativos
- Confirme a conexão com o backend
- Recarregue a página (F5)

### Erro de autenticação
- Faça logout e login novamente
- Verifique se o token está correto
- Limpe o localStorage do navegador

## 📱 Testando no App Flutter

1. Certifique-se que o backend está rodando
2. Crie alguns banners no painel admin
3. Abra o app Flutter
4. Navegue até a Home
5. Veja o carrossel com seus banners!

## 📱 Módulos Disponíveis

### ✅ Funcionais
- **📊 Dashboard** - Visão geral do sistema
- **🎨 Banners** - Gerenciamento completo (CRUD)

### 🚧 Em Desenvolvimento
- **📦 Produtos** - Em breve
- **🛒 Pedidos** - Em breve
- **👥 Clientes** - Em breve
- **🔔 Notificações** - Em breve
- **⭐ Avaliações** - Em breve
- **⚙️ Configurações** - Interface pronta

## 🎯 Próximos Passos

Após dominar o gerenciamento de banners, você pode:
- Implementar os backends dos outros módulos
- Personalizar o design do painel
- Adicionar upload de imagens
- Implementar filtros e busca
- Adicionar analytics e métricas
