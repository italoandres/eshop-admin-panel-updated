# Arquitetura do Projeto

## 📐 Visão Geral

Este projeto utiliza **Clean Architecture** combinada com **Feature Modular** e **Riverpod** para state management.

## 🏛️ Princípios da Clean Architecture

### Camadas

```
┌─────────────────────────────────────┐
│         PRESENTATION                │  ← UI, Widgets, Pages
│  (Pages, Widgets, Notifiers)        │
├─────────────────────────────────────┤
│         DOMAIN                      │  ← Business Logic
│  (Models, Entities, Use Cases)      │
├─────────────────────────────────────┤
│         DATA                        │  ← Dados Externos
│  (DTOs, Repositories, Data Sources) │
└─────────────────────────────────────┘
```

### Regras de Dependência

- **Presentation** depende de **Domain**
- **Data** depende de **Domain**
- **Domain** NÃO depende de ninguém (núcleo puro)

## 📁 Estrutura Detalhada

### Core

```
core/
├── config/           # Configurações globais (white-label)
├── theme/            # Temas dinâmicos
├── errors/           # Tratamento centralizado de erros
├── network/          # Cliente HTTP (Dio)
├── router/           # Rotas (GoRouter)
└── utils/            # Utilitários gerais
```

**Responsabilidade**: Funcionalidades compartilhadas entre todas as features.

### Features

Cada feature segue a estrutura:

```
feature_name/
├── data/
│   ├── dtos/              # Data Transfer Objects
│   ├── repositories/      # Implementações de repositórios
│   └── data_sources/      # Fontes de dados (API, local)
│
├── domain/
│   ├── models/            # Modelos de negócio
│   ├── repositories/      # Interfaces (contratos)
│   └── use_cases/         # Casos de uso (opcional)
│
└── presentation/
    ├── pages/             # Telas
    ├── widgets/           # Widgets específicos
    ├── notifiers/         # State management (Riverpod)
    └── providers/         # Providers do Riverpod
```

## 🔄 Fluxo de Dados

### Exemplo: Buscar Banners

```
┌──────────┐      ┌───────────┐      ┌──────────────┐      ┌─────┐
│  Widget  │ ───> │ Provider  │ ───> │ Repository   │ ───> │ API │
└──────────┘      └───────────┘      └──────────────┘      └─────┘
     ↑                                         │
     │                                         ↓
     │                                   ┌──────────┐
     └─────────────────────────────────  │   DTO    │
                                          └──────────┘
                                               ↓
                                          ┌──────────┐
                                          │  Model   │
                                          └──────────┘
```

### Passo a passo:

1. **Widget** consome um **Provider**
2. **Provider** chama o **Repository**
3. **Repository** faz request HTTP
4. API retorna JSON
5. JSON é convertido para **DTO** (Data Layer)
6. **DTO** é convertido para **Model** (Domain Layer)
7. **Model** é retornado para o **Provider**
8. **Widget** recebe o **Model** e renderiza

## 📦 Padrões Utilizados

### 1. Repository Pattern

**Interface (Domain)**:
```dart
abstract class BannerRepository {
  Future<List<BannerModel>> fetchBanners();
}
```

**Implementação (Data)**:
```dart
class BannerRepositoryImpl implements BannerRepository {
  final DioClient _dioClient;
  
  @override
  Future<List<BannerModel>> fetchBanners() async {
    // Implementação
  }
}
```

### 2. DTO Pattern

**DTO** (Data Transfer Object) - apenas para transporte de dados:

```dart
@freezed
class BannerDto with _$BannerDto {
  const factory BannerDto({
    required String id,
    required String title,
    // ...
  }) = _BannerDto;

  factory BannerDto.fromJson(Map<String, dynamic> json) =>
      _$BannerDtoFromJson(json);
      
  BannerModel toModel() {
    // Converte DTO → Model
  }
}
```

**Model** (Domain) - representa entidade de negócio:

```dart
@freezed
class BannerModel with _$BannerModel {
  const factory BannerModel({
    required String id,
    required String title,
    // ...
  }) = _BannerModel;
}
```

### 3. Provider Pattern (Riverpod)

```dart
// Provider do repositório
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return BannerRepositoryImpl(dioClient);
});

// Provider de dados
final fetchBannersProvider = FutureProvider<List<BannerModel>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return await repository.fetchBanners();
});
```

## 🎭 State Management com Riverpod

### Tipos de Providers

1. **Provider**: Dados que não mudam
```dart
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(baseUrl: '...');
});
```

2. **FutureProvider**: Dados assíncronos
```dart
final bannersProvider = FutureProvider<List<Banner>>((ref) async {
  return await repository.fetchBanners();
});
```

3. **StateNotifier**: Estado mutável
```dart
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());
  
  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    // ...
  }
}
```

### Consumindo Providers

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(bannersProvider);
    
    return bannersAsync.when(
      data: (banners) => ListView(...),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Erro'),
    );
  }
}
```

## 🌐 Camada de Network

### DioClient

Cliente HTTP centralizado com:
- Interceptors
- Tratamento de token
- Retry automático
- Logs

```dart
class DioClient {
  late final Dio _dio;
  
  DioClient({required String baseUrl}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    // Auth interceptor
    // Retry interceptor
    // Log interceptor
  }
}
```

### Error Handling

Erros são mapeados para tipos específicos:

```dart
@freezed
class AppError with _$AppError {
  const factory AppError.network({...}) = NetworkError;
  const factory AppError.server({...}) = ServerError;
  const factory AppError.unauthorized({...}) = UnauthorizedError;
  // ...
}
```

## 🎨 White-Label Architecture

### Store Config

Configuração centralizada que define:
- Cores
- Logo
- Nome da loja
- URL da API
- Moeda

```dart
class StoreConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final String apiBaseUrl;
  // ...
}
```

### Como o White-Label funciona

1. **App inicia** → Carrega `StoreConfig`
2. **Tema é criado** dinamicamente baseado nas cores do config
3. **DioClient é criado** com a URL da API do config
4. **Todas as features** usam o mesmo config

```dart
final storeConfigProvider = FutureProvider<StoreConfig>((ref) async {
  // Carrega de JSON local, API remota, etc.
});

final dioClientProvider = Provider<DioClient>((ref) {
  final config = ref.watch(storeConfigProvider).value!;
  return DioClient(baseUrl: config.apiBaseUrl);
});
```

## 🔐 Autenticação

### Fluxo JWT

```
1. Login → Recebe token + refresh token
2. Salva em FlutterSecureStorage
3. Todas requests incluem header: Authorization: Bearer {token}
4. Se 401 → Tenta refresh do token
5. Se refresh falha → Logout e redireciona para login
```

### Implementação

```dart
// Auth Repository
Future<UserModel> login(String email, String password) async {
  final response = await _dio.post('/auth/login', data: {...});
  final authResponse = AuthResponseDto.fromJson(response.data);
  
  // Salva tokens
  await _secureStorage.write(key: 'auth_token', value: authResponse.token);
  
  return authResponse.user.toModel();
}

// Dio Interceptor (auto refresh)
onError: (error, handler) async {
  if (error.response?.statusCode == 401) {
    final refreshed = await _refreshToken();
    if (refreshed) {
      return handler.resolve(await _retry(error.requestOptions));
    }
  }
}
```

## 🧩 Vantagens desta Arquitetura

### ✅ Testabilidade
- Camadas isoladas facilitam unit tests
- Mocks fáceis de criar

### ✅ Manutenibilidade
- Código organizado por features
- Separação clara de responsabilidades

### ✅ Escalabilidade
- Adicionar nova feature = copiar estrutura
- Cada feature é independente

### ✅ White-Label
- Uma configuração muda todo o app
- Fácil gerar múltiplos apps

## 📚 Recursos de Estudo

- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Architecture](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)
- [Feature-First vs Layer-First](https://codewithandrea.com/articles/flutter-project-structure/)

## 🎯 Próximos Passos

1. Adicionar Use Cases para lógica complexa
2. Implementar testes unitários
3. Adicionar CI/CD
4. Implementar cache offline
5. Adicionar analytics e crashlytics
