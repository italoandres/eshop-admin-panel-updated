# E-Commerce Flutter White-Label

Aplicativo Flutter moderno, escalável e 100% white-label para e-commerce, consumindo API de painel admin existente.

## 🎯 Objetivo

Criar um aplicativo para o cliente final (consumidor da loja) que consome dados do painel admin React existente.

Cada loja terá seu próprio app com:
- Tema e cores personalizadas
- Logo própria
- Produtos e banners exclusivos
- URLs de API específicas

## 🏗️ Arquitetura

O projeto segue **Clean Architecture + Feature Modular + Riverpod 3**:

```
lib/
├── core/
│   ├── config/        # Configurações white-label
│   ├── theme/         # Temas dinâmicos
│   ├── errors/        # Tratamento de erros
│   ├── network/       # Cliente HTTP (Dio)
│   └── router/        # Rotas (GoRouter)
│
├── features/
│   ├── auth/
│   │   ├── data/      # DTOs, repositórios
│   │   ├── domain/    # Modelos, casos de uso
│   │   └── presentation/ # Páginas, notifiers
│   │
│   ├── banners/
│   ├── products/
│   ├── cart/
│   └── ...
│
├── shared/
│   └── widgets/       # Widgets reutilizáveis
│
├── app.dart
└── main.dart
```

### Camadas por Feature

Cada feature possui 3 camadas:

- **data**: DTOs, serviços de API, repositórios
- **domain**: Entidades, modelos puros, casos de uso
- **presentation**: Páginas, viewmodels, providers do Riverpod

## 🛠️ Tecnologias

- **State Management**: Riverpod 3
- **HTTP Client**: Dio 5 com interceptors, retry e logs
- **Models**: Freezed + JsonSerializable
- **Navegação**: GoRouter com deep links
- **Persistência**: SharedPreferences + FlutterSecureStorage
- **UI**: Google Fonts, CachedNetworkImage, CarouselSlider

## 🚀 Começando

### 1. Instalar dependências

```bash
flutter pub get
```

### 2. Gerar código (Freezed, JsonSerializable)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Executar o app

```bash
flutter run
```

## 🎨 White-Label

### Configuração da Loja

A configuração white-label está em `lib/core/config/store_config.dart`:

```dart
class StoreConfig {
  final String storeId;
  final String apiBaseUrl;
  final String storeName;
  final String logoUrl;
  final Color primaryColor;
  final Color secondaryColor;
  final String currency;
}
```

### Como personalizar para uma nova loja:

1. Modificar `StoreConfig.defaultConfig` em `store_config.dart`
2. Ou carregar de JSON/API através do `storeConfigProvider`

O app inteiro se adapta automaticamente:
- Cores do tema
- Nome da loja
- Logo
- Endpoints da API

## 📡 Integração com o Painel React

O app Flutter **consome** os dados que o painel React gerencia:

- **Banners**: GET `/banners`
- **Produtos**: GET `/products`
- **Categorias**: GET `/categories`
- **Pedidos**: POST `/orders`
- **Auth**: POST `/auth/login`, `/auth/register`

### Exemplo de resposta da API (Banners):

```json
{
  "data": [
    {
      "id": "123",
      "title": "Promoção",
      "imageUrl": "https://...",
      "order": 1,
      "active": true,
      "targetUrl": "https://..."
    }
  ]
}
```

## 📱 Funcionalidades Implementadas

### ✅ Primeira Entrega

- [x] Setup inicial completo
- [x] Estrutura de pastas modular
- [x] Riverpod configurado
- [x] GoRouter funcional
- [x] StoreConfig carregando dinamicamente
- [x] Tema dinâmico baseado no StoreConfig
- [x] Feature de Banners completa (DTO, Model, Repository, Provider)
- [x] Carrossel de banners na Home
- [x] Tela de Login funcional
- [x] Autenticação com JWT
- [x] Tratamento de erros centralizado

### 🚧 Próximos Passos

- [ ] Feature de Produtos completa
- [ ] Feature de Carrinho
- [ ] Feature de Pedidos
- [ ] Tela de Detalhes do Produto
- [ ] Tela de Categorias
- [ ] Tela de Perfil
- [ ] Sistema de pagamento
- [ ] Push notifications

## 🔐 Autenticação

O sistema de autenticação usa JWT tokens:

- **Access Token**: Armazenado em `FlutterSecureStorage`
- **Refresh Token**: Renovação automática via interceptor do Dio
- **Logout**: Limpa tokens do storage

### Fluxo de autenticação:

1. Usuário faz login → Recebe tokens
2. Tokens são salvos no SecureStorage
3. Todas as requests incluem o token no header
4. Se token expirar (401), tenta refresh automático
5. Se refresh falhar, redireciona para login

## 📦 Dependências Principais

```yaml
dependencies:
  flutter_riverpod: ^2.5.1      # State management
  dio: ^5.4.0                   # HTTP client
  go_router: ^14.0.2            # Navegação
  freezed_annotation: ^2.4.1    # Imutabilidade
  json_annotation: ^4.8.1       # Serialização
  shared_preferences: ^2.2.2    # Cache local
  flutter_secure_storage: ^9.0.0 # Tokens seguros
  google_fonts: ^6.1.0          # Tipografia
  cached_network_image: ^3.3.1  # Cache de imagens
  carousel_slider: ^4.2.1       # Carrossel
```

## 🧪 Testes

Para executar testes:

```bash
flutter test
```

## 📝 Convenções de Código

- Use `const` sempre que possível
- Nomeie providers com sufixo `Provider`
- DTOs sempre na camada `data`
- Models sempre na camada `domain`
- Widgets reutilizáveis em `shared/widgets`
- Use Freezed para imutabilidade
- Sempre trate erros com `AppError`

## 🐛 Debug

### Ativar logs do Dio:

Os logs já estão configurados. Para desativar em produção:

```dart
// Em dio_client.dart, comentar:
// _dio.interceptors.add(LogInterceptor(...));
```

### Ver estado do Riverpod:

Use o Riverpod DevTools no Flutter Inspector.

## 📄 Licença

Proprietário - Todos os direitos reservados.

---

**Desenvolvido com ❤️ usando Flutter**
