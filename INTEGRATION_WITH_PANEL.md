# Integração com Painel React Admin

Este documento explica como o app Flutter consome os dados do painel React/TypeScript existente.

## 🔄 Visão Geral

```
┌─────────────────┐         ┌─────────────┐         ┌──────────────┐
│  Painel React   │ ───────>│  API REST   │<─────── │  App Flutter │
│  (Lojistas)     │  Manage │             │ Consume │  (Clientes)  │
└─────────────────┘         └─────────────┘         └──────────────┘
```

### O que NÃO fazer

❌ **NÃO migrar** código React para Flutter
❌ **NÃO criar** painel admin no Flutter
❌ **NÃO duplicar** funcionalidades do painel

### O que fazer

✅ **Consumir** endpoints da mesma API
✅ **Respeitar** estrutura de dados existente
✅ **Sincronizar** modelos com a API

## 📡 Endpoints Compartilhados

Baseado nos arquivos do painel React, aqui estão os endpoints esperados:

### Banners

```typescript
// Painel React consome:
GET /banners
POST /banners
PUT /banners/:id
DELETE /banners/:id
```

```dart
// App Flutter consome:
GET /banners  // Lista banners ativos
```

**Estrutura de dados (baseada em Banners.jsx)**:

```json
{
  "data": [
    {
      "id": "123",
      "title": "Promoção de Verão",
      "imageUrl": "https://cdn.example.com/banner1.jpg",
      "order": 1,
      "active": true,
      "targetUrl": "https://loja.com/promo/verao",
      "description": "Até 50% OFF"
    }
  ]
}
```

### Produtos

```typescript
// Painel React gerencia:
GET /products
POST /products
PUT /products/:id
DELETE /products/:id
```

```dart
// App Flutter consome:
GET /products?page=1&limit=20&categoryId=abc&search=termo
GET /products/:id
```

**Estrutura esperada**:

```json
{
  "data": [
    {
      "id": "prod-001",
      "name": "Camiseta Básica",
      "description": "Camiseta 100% algodão",
      "price": 49.90,
      "imageUrl": "https://cdn.example.com/prod1.jpg",
      "images": [
        "https://cdn.example.com/prod1-1.jpg",
        "https://cdn.example.com/prod1-2.jpg"
      ],
      "categoryId": "cat-001",
      "stock": 50,
      "active": true
    }
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20
  }
}
```

### Categorias

```dart
GET /categories
GET /categories/:id/products
```

### Pedidos (Orders)

```dart
GET /orders              // Lista pedidos do usuário
GET /orders/:id          // Detalhes de um pedido
POST /orders             // Criar novo pedido
```

**Criar pedido**:

```json
{
  "items": [
    {
      "productId": "prod-001",
      "quantity": 2,
      "price": 49.90
    }
  ],
  "shippingAddress": {
    "street": "Rua Exemplo",
    "number": "123",
    "city": "São Paulo",
    "state": "SP",
    "zipCode": "01234-567"
  },
  "paymentMethod": "credit_card"
}
```

### Clientes (Customers)

```dart
GET /customers/me        // Dados do cliente atual
PUT /customers/me        // Atualizar perfil
```

### Cupons

```dart
POST /coupons/validate   // Validar cupom de desconto
```

**Request**:
```json
{
  "code": "PROMO10",
  "cartTotal": 100.00
}
```

**Response**:
```json
{
  "valid": true,
  "discountType": "percentage",
  "discountValue": 10,
  "finalTotal": 90.00
}
```

### Avaliações (Reviews)

```dart
GET /products/:id/reviews
POST /products/:id/reviews
```

## 🔐 Autenticação

O app Flutter usa os mesmos endpoints de auth do painel:

```dart
POST /auth/login
POST /auth/register
POST /auth/refresh
POST /auth/logout
```

### Fluxo de autenticação

1. **Login**:
```json
// Request
{
  "email": "cliente@email.com",
  "password": "senha123"
}

// Response
{
  "token": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "user": {
    "id": "user-001",
    "name": "João Silva",
    "email": "cliente@email.com",
    "phone": "11999999999"
  }
}
```

2. **Todas as requests subsequentes**:
```
Authorization: Bearer eyJhbGc...
```

3. **Se token expirar (401)**:
```json
// Request para /auth/refresh
{
  "refreshToken": "eyJhbGc..."
}

// Response
{
  "token": "novo_token...",
  "refreshToken": "novo_refresh..."
}
```

## 🔄 Sincronizando Modelos

### Quando o painel atualiza um modelo

Se o painel React adicionar um novo campo em `Product`:

```typescript
// Painel React
interface Product {
  id: string;
  name: string;
  price: number;
  // NOVO CAMPO:
  promotionalPrice?: number;
}
```

Você deve atualizar no Flutter:

```dart
// App Flutter - ProductDto
@freezed
class ProductDto with _$ProductDto {
  const factory ProductDto({
    required String id,
    required String name,
    required double price,
    // ADICIONAR:
    double? promotionalPrice,
  }) = _ProductDto;
}

// E no ProductModel também
```

Depois execute:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📋 Checklist de Integração

### Antes de Implementar uma Feature:

- [ ] Verificar endpoint no painel React
- [ ] Verificar estrutura de dados (request/response)
- [ ] Verificar campos obrigatórios vs opcionais
- [ ] Verificar paginação
- [ ] Verificar filtros disponíveis
- [ ] Verificar autenticação necessária

### Ao Criar DTOs:

- [ ] Usar mesmos nomes de campos da API
- [ ] Respeitar tipos (String, int, double, bool)
- [ ] Marcar campos opcionais com `?`
- [ ] Adicionar valores default quando apropriado
- [ ] Documentar diferenças se houver

### Ao Testar:

- [ ] Testar com API real (se disponível)
- [ ] Testar com dados mockados
- [ ] Testar paginação
- [ ] Testar filtros
- [ ] Testar casos de erro (404, 401, 500)

## 🧪 Mockando Dados do Painel

Se o backend ainda não está pronto, crie mocks:

```dart
// lib/features/products/data/repositories/product_repository_mock.dart

class ProductRepositoryMock implements ProductRepository {
  @override
  Future<List<ProductModel>> fetchProducts() async {
    await Future.delayed(Duration(seconds: 1)); // Simula latência
    
    return [
      ProductModel(
        id: '1',
        name: 'Produto Mock 1',
        description: 'Descrição do produto',
        price: 99.90,
        imageUrl: 'https://via.placeholder.com/300',
        categoryId: 'cat-1',
        stock: 10,
      ),
      // mais produtos...
    ];
  }
}

// No provider, use o mock:
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  // Em desenvolvimento:
  return ProductRepositoryMock();
  
  // Em produção:
  // final dioClient = ref.watch(dioClientProvider);
  // return ProductRepository(dioClient);
});
```

## 🔧 Configuração de Ambiente

Use diferentes URLs de API para dev/prod:

```dart
// lib/core/config/environment.dart

enum Environment {
  dev,
  staging,
  production,
}

class EnvironmentConfig {
  static const currentEnvironment = Environment.dev;
  
  static String get apiBaseUrl {
    switch (currentEnvironment) {
      case Environment.dev:
        return 'http://localhost:3000';
      case Environment.staging:
        return 'https://api-staging.minhaloja.com';
      case Environment.production:
        return 'https://api.minhaloja.com';
    }
  }
}

// Usar no StoreConfig:
StoreConfig.defaultConfig.copyWith(
  apiBaseUrl: EnvironmentConfig.apiBaseUrl,
)
```

## 📞 Comunicação com Backend

### Boas práticas:

1. **Documente os endpoints** que o app usa
2. **Versione a API** (`/api/v1/products`)
3. **Comunique mudanças** breaking changes
4. **Mantenha backward compatibility** quando possível
5. **Use contratos** (Swagger/OpenAPI)

### Exemplo de documentação para backend:

```markdown
## Endpoints usados pelo App Mobile

### GET /api/v1/banners
Retorna lista de banners ativos

**Response**:
- `data`: Array de banners
  - `id`: string (obrigatório)
  - `title`: string (obrigatório)
  - `imageUrl`: string (obrigatório)
  - `order`: number (obrigatório)
  - `active`: boolean (obrigatório)
  - `targetUrl`: string (opcional)

**Usado em**: HomeScreen - Carrossel de banners
```

## 🚨 Tratamento de Erros

Padronize respostas de erro:

```json
{
  "error": {
    "code": "PRODUCT_NOT_FOUND",
    "message": "Produto não encontrado",
    "details": {}
  }
}
```

No Flutter, mapeie para `AppError`:

```dart
if (error.code == 'PRODUCT_NOT_FOUND') {
  throw AppError.notFound(message: error.message);
}
```

## 📊 Paginação

Padronize paginação:

```dart
GET /products?page=1&limit=20

Response:
{
  "data": [...],
  "meta": {
    "total": 150,
    "page": 1,
    "limit": 20,
    "totalPages": 8
  }
}
```

## ✅ Conclusão

O app Flutter é um **consumidor** da mesma API que o painel React usa. Mantenha:
- Sincronização de modelos
- Mesmos nomes de campos
- Mesma autenticação
- Mesma estrutura de erros

Qualquer mudança na API deve ser refletida em ambos os clientes (painel e app).
