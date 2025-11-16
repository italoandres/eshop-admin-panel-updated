# Como Adicionar Novas Features

Este guia mostra como expandir o app seguindo a arquitetura estabelecida.

## 📝 Template de Feature

Toda feature deve seguir esta estrutura:

```
features/
└── nome_feature/
    ├── data/
    │   ├── dtos/
    │   │   └── nome_dto.dart
    │   └── repositories/
    │       └── nome_repository.dart
    │
    ├── domain/
    │   └── models/
    │       └── nome_model.dart
    │
    └── presentation/
        ├── pages/
        │   └── nome_page.dart
        ├── widgets/
        │   └── nome_widget.dart
        ├── notifiers/
        │   └── nome_notifier.dart
        └── providers/
            └── nome_provider.dart
```

## 🎯 Exemplo: Feature de Produtos

Vamos criar a feature de produtos passo a passo.

### 1. Criar Model (Domain Layer)

```dart
// lib/features/products/domain/models/product_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String categoryId,
    required int stock,
    @Default(true) bool active,
    @Default([]) List<String> images,
  }) = _ProductModel;
}
```

### 2. Criar DTO (Data Layer)

```dart
// lib/features/products/data/dtos/product_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/product_model.dart';

part 'product_dto.freezed.dart';
part 'product_dto.g.dart';

@freezed
class ProductDto with _$ProductDto {
  const ProductDto._();

  const factory ProductDto({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String categoryId,
    required int stock,
    @Default(true) bool active,
    @Default([]) List<String> images,
  }) = _ProductDto;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  ProductModel toModel() {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      categoryId: categoryId,
      stock: stock,
      active: active,
      images: images,
    );
  }
}
```

### 3. Criar Repository (Data Layer)

```dart
// lib/features/products/data/repositories/product_repository.dart

import 'package:dio/dio.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/network/dio_client.dart';
import '../dtos/product_dto.dart';
import '../../domain/models/product_model.dart';

class ProductRepository {
  final DioClient _dioClient;

  ProductRepository(this._dioClient);

  Future<List<ProductModel>> fetchProducts({
    String? categoryId,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/products',
        queryParameters: {
          if (categoryId != null) 'categoryId': categoryId,
          if (search != null) 'search': search,
          'page': page,
          'limit': limit,
        },
      );

      if (response.data == null) {
        throw const AppError.server(message: 'Resposta vazia do servidor');
      }

      final List<dynamic> productsJson = response.data!['data'] ?? [];
      
      return productsJson
          .map((json) => ProductDto.fromJson(json as Map<String, dynamic>))
          .where((dto) => dto.active)
          .map((dto) => dto.toModel())
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const AppError.notFound(message: 'Produtos não encontrados');
      } else {
        throw AppError.server(
          message: e.message ?? 'Erro ao buscar produtos',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw AppError.unknown(message: e.toString());
    }
  }

  Future<ProductModel> fetchProductById(String id) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/products/$id',
      );

      if (response.data == null) {
        throw const AppError.server(message: 'Resposta vazia do servidor');
      }

      final productDto = ProductDto.fromJson(response.data!['data']);
      return productDto.toModel();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const AppError.notFound(message: 'Produto não encontrado');
      } else {
        throw AppError.server(
          message: e.message ?? 'Erro ao buscar produto',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw AppError.unknown(message: e.toString());
    }
  }
}
```

### 4. Criar Providers (Presentation Layer)

```dart
// lib/features/products/presentation/providers/product_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';
import '../data/repositories/product_repository.dart';
import '../domain/models/product_model.dart';

// Provider do repositório
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProductRepository(dioClient);
});

// Provider que busca produtos
final fetchProductsProvider = FutureProvider.autoDispose
    .family<List<ProductModel>, ProductsParams>((ref, params) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.fetchProducts(
    categoryId: params.categoryId,
    search: params.search,
    page: params.page,
    limit: params.limit,
  );
});

// Parâmetros para busca de produtos
class ProductsParams {
  final String? categoryId;
  final String? search;
  final int page;
  final int limit;

  ProductsParams({
    this.categoryId,
    this.search,
    this.page = 1,
    this.limit = 20,
  });
}

// Provider para produto específico
final fetchProductByIdProvider = FutureProvider.family<ProductModel, String>(
  (ref, id) async {
    final repository = ref.watch(productRepositoryProvider);
    return await repository.fetchProductById(id);
  },
);
```

### 5. Criar Page (Presentation Layer)

```dart
// lib/features/products/presentation/pages/products_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final String? categoryId;

  const ProductsPage({
    super.key,
    this.categoryId,
  });

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final _searchController = TextEditingController();
  String? _searchQuery;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final params = ProductsParams(
      categoryId: widget.categoryId,
      search: _searchQuery,
    );

    final productsAsync = ref.watch(fetchProductsProvider(params));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar produtos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = null;
                          });
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value.isEmpty ? null : value;
                });
              },
            ),
          ),
        ),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Text('Nenhum produto encontrado'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text('Erro ao carregar produtos'),
              TextButton(
                onPressed: () {
                  ref.invalidate(fetchProductsProvider(params));
                },
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### 6. Criar Widget (Presentation Layer)

```dart
// lib/features/products/presentation/widgets/product_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Navegar para detalhes
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 7. Gerar código

Execute:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 8. Adicionar rota

```dart
// lib/core/router/app_router.dart

GoRoute(
  path: '/products',
  builder: (context, state) {
    final categoryId = state.uri.queryParameters['categoryId'];
    return ProductsPage(categoryId: categoryId);
  },
),
```

## ✅ Checklist para Nova Feature

- [ ] Criar pasta da feature em `lib/features/`
- [ ] Criar Model (domain/models/)
- [ ] Criar DTO (data/dtos/)
- [ ] Criar Repository (data/repositories/)
- [ ] Criar Providers (presentation/providers/)
- [ ] Criar Page (presentation/pages/)
- [ ] Criar Widgets específicos (presentation/widgets/)
- [ ] Adicionar rota no app_router.dart
- [ ] Executar build_runner
- [ ] Testar

## 🎨 Dicas

### Use Snippets

Crie snippets no VS Code para agilizar:

```json
{
  "Freezed Model": {
    "prefix": "fmodel",
    "body": [
      "import 'package:freezed_annotation/freezed_annotation.dart';",
      "",
      "part '${TM_FILENAME_BASE}.freezed.dart';",
      "",
      "@freezed",
      "class ${TM_FILENAME_BASE/(.*)_model/${1:/pascalcase}/} with _\\$${TM_FILENAME_BASE/(.*)_model/${1:/pascalcase}/} {",
      "  const factory ${TM_FILENAME_BASE/(.*)_model/${1:/pascalcase}/}({",
      "    required String id,",
      "    $0",
      "  }) = _${TM_FILENAME_BASE/(.*)_model/${1:/pascalcase}/};",
      "}"
    ]
  }
}
```

### Convenções de Nome

- Model: `product_model.dart` → `ProductModel`
- DTO: `product_dto.dart` → `ProductDto`
- Repository: `product_repository.dart` → `ProductRepository`
- Page: `products_page.dart` → `ProductsPage`
- Provider: `product_provider.dart` → `productProvider`

### Reutilização

Widgets reutilizáveis vão em `lib/shared/widgets/`

```dart
lib/shared/widgets/
├── loading_indicator.dart
├── error_widget.dart
├── empty_state.dart
└── custom_button.dart
```

## 📚 Próximas Features Sugeridas

1. **Categories** - Listagem e filtro de categorias
2. **Cart** - Carrinho de compras
3. **Orders** - Histórico de pedidos
4. **Reviews** - Avaliações de produtos
5. **Favorites** - Produtos favoritos
6. **Notifications** - Push notifications
7. **Profile** - Perfil do usuário
8. **Payment** - Integração de pagamento

Siga este template para cada uma!
