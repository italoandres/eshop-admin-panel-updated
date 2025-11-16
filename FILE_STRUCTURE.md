# Estrutura de Arquivos do Projeto

## 📂 Árvore Completa

```
ecommerce_app/
│
├── 📄 pubspec.yaml                    # Dependências do projeto
├── 📄 .gitignore                      # Arquivos ignorados pelo Git
├── 📄 README.md                       # Visão geral do projeto
├── 📄 BUILD_INSTRUCTIONS.md           # Instruções de build
├── 📄 ARCHITECTURE.md                 # Documentação da arquitetura
├── 📄 ADDING_FEATURES.md              # Como adicionar features
├── 📄 INTEGRATION_WITH_PANEL.md       # Integração com API
├── 📄 EXECUTIVE_SUMMARY.md            # Resumo executivo
├── 📄 store_config_example.json       # Exemplo de configuração
├── 🔧 generate.sh                     # Script para gerar código
│
└── lib/
    │
    ├── 📄 main.dart                   # Entry point do app
    ├── 📄 app.dart                    # Configuração do MaterialApp
    │
    ├── 📁 core/                       # Funcionalidades compartilhadas
    │   │
    │   ├── 📁 config/                 # Configurações globais
    │   │   ├── 📄 store_config.dart           # Config white-label
    │   │   └── 📄 store_config_provider.dart  # Provider do config
    │   │
    │   ├── 📁 theme/                  # Temas
    │   │   └── 📄 app_theme.dart              # Tema dinâmico
    │   │
    │   ├── 📁 network/                # HTTP Client
    │   │   ├── 📄 dio_client.dart             # Cliente Dio configurado
    │   │   └── 📄 dio_provider.dart           # Provider do Dio
    │   │
    │   ├── 📁 router/                 # Navegação
    │   │   └── 📄 app_router.dart             # Rotas com GoRouter
    │   │
    │   └── 📁 errors/                 # Tratamento de erros
    │       └── 📄 app_error.dart              # Tipos de erro
    │
    └── 📁 features/                   # Features do app
        │
        ├── 📁 auth/                   # ✅ Autenticação
        │   │
        │   ├── 📁 data/
        │   │   ├── 📁 dtos/
        │   │   │   ├── 📄 auth_response_dto.dart
        │   │   │   └── 📄 user_dto.dart
        │   │   └── 📁 repositories/
        │   │       └── 📄 auth_repository.dart
        │   │
        │   ├── 📁 domain/
        │   │   └── 📁 models/
        │   │       └── 📄 user_model.dart
        │   │
        │   └── 📁 presentation/
        │       ├── 📁 pages/
        │       │   └── 📄 login_page.dart
        │       └── 📁 notifiers/
        │           └── 📄 auth_notifier.dart
        │
        ├── 📁 banners/                # ✅ Banners
        │   │
        │   ├── 📁 data/
        │   │   ├── 📁 dtos/
        │   │   │   └── 📄 banner_dto.dart
        │   │   └── 📁 repositories/
        │   │       └── 📄 banner_repository.dart
        │   │
        │   ├── 📁 domain/
        │   │   └── 📁 models/
        │   │       └── 📄 banner_model.dart
        │   │
        │   └── 📁 presentation/
        │       ├── 📁 providers/
        │       │   └── 📄 banner_provider.dart
        │       └── 📁 widgets/
        │           └── 📄 banner_carousel.dart
        │
        ├── 📁 home/                   # ✅ Home
        │   └── 📁 presentation/
        │       └── 📁 pages/
        │           └── 📄 home_page.dart
        │
        ├── 📁 products/               # 🚧 TODO
        │   ├── 📁 data/
        │   ├── 📁 domain/
        │   └── 📁 presentation/
        │
        ├── 📁 cart/                   # 🚧 TODO
        │   ├── 📁 data/
        │   ├── 📁 domain/
        │   └── 📁 presentation/
        │
        ├── 📁 orders/                 # 🚧 TODO
        │   ├── 📁 data/
        │   ├── 📁 domain/
        │   └── 📁 presentation/
        │
        ├── 📁 customers/              # 🚧 TODO
        │   ├── 📁 data/
        │   ├── 📁 domain/
        │   └── 📁 presentation/
        │
        ├── 📁 settings/               # 🚧 TODO
        │   └── 📁 presentation/
        │
        └── 📁 reviews/                # 🚧 TODO
            ├── 📁 data/
            ├── 📁 domain/
            └── 📁 presentation/
```

## 📊 Estatísticas

### Arquivos Criados
- **Código Dart**: 21 arquivos
- **Documentação**: 8 arquivos
- **Configuração**: 3 arquivos
- **Total**: 32 arquivos

### Features
- ✅ **Implementadas**: 3 (Auth, Banners, Home)
- 🚧 **Pendentes**: 6 (Products, Cart, Orders, Customers, Settings, Reviews)

## 🗂️ Organização por Camada

### Core (6 arquivos)
```
core/
├── config/store_config.dart              # White-label config
├── config/store_config_provider.dart     # Config provider
├── theme/app_theme.dart                  # Tema dinâmico
├── network/dio_client.dart               # HTTP client
├── network/dio_provider.dart             # Dio provider
├── router/app_router.dart                # Rotas
└── errors/app_error.dart                 # Errors
```

### Feature: Auth (7 arquivos)
```
auth/
├── data/
│   ├── dtos/auth_response_dto.dart       # DTO de resposta
│   ├── dtos/user_dto.dart                # DTO do usuário
│   └── repositories/auth_repository.dart # Repositório
├── domain/
│   └── models/user_model.dart            # Model do usuário
└── presentation/
    ├── pages/login_page.dart             # Tela de login
    └── notifiers/auth_notifier.dart      # State management
```

### Feature: Banners (5 arquivos)
```
banners/
├── data/
│   ├── dtos/banner_dto.dart              # DTO de banner
│   └── repositories/banner_repository.dart # Repositório
├── domain/
│   └── models/banner_model.dart          # Model de banner
└── presentation/
    ├── providers/banner_provider.dart    # Providers
    └── widgets/banner_carousel.dart      # Carrossel
```

### Feature: Home (1 arquivo)
```
home/
└── presentation/
    └── pages/home_page.dart              # Tela home
```

## 📋 Arquivos Gerados (build_runner)

Após executar `flutter pub run build_runner build`, serão gerados:

```
*.freezed.dart    # Classes imutáveis (Freezed)
*.g.dart          # Serialização JSON (JsonSerializable)
```

### Exemplo:
```
banner_model.dart       → banner_model.freezed.dart
banner_dto.dart         → banner_dto.freezed.dart + banner_dto.g.dart
store_config.dart       → store_config.freezed.dart + store_config.g.dart
auth_response_dto.dart  → auth_response_dto.freezed.dart + auth_response_dto.g.dart
```

## 🎨 Convenções de Nomenclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Model | `*_model.dart` | `user_model.dart` |
| DTO | `*_dto.dart` | `user_dto.dart` |
| Repository | `*_repository.dart` | `auth_repository.dart` |
| Provider | `*_provider.dart` | `banner_provider.dart` |
| Notifier | `*_notifier.dart` | `auth_notifier.dart` |
| Page | `*_page.dart` | `login_page.dart` |
| Widget | `*_widget.dart` ou nome descritivo | `banner_carousel.dart` |

## 🔍 Onde Encontrar...

### Configuração White-Label
📍 `lib/core/config/store_config.dart`

### Tema Dinâmico
📍 `lib/core/theme/app_theme.dart`

### Cliente HTTP
📍 `lib/core/network/dio_client.dart`

### Rotas
📍 `lib/core/router/app_router.dart`

### Login
📍 `lib/features/auth/presentation/pages/login_page.dart`

### Home
📍 `lib/features/home/presentation/pages/home_page.dart`

### Carrossel de Banners
📍 `lib/features/banners/presentation/widgets/banner_carousel.dart`

## 📝 Assets (a serem criados)

```
assets/
├── images/
│   ├── logo.png
│   ├── placeholder.png
│   └── splash.png
└── icons/
    └── app_icon.png
```

## 🚀 Como Navegar

1. **Entender arquitetura**: `ARCHITECTURE.md`
2. **Ver código**: `lib/features/`
3. **Adicionar feature**: Seguir template em `ADDING_FEATURES.md`
4. **Compilar**: Seguir `BUILD_INSTRUCTIONS.md`

---

**Estrutura criada seguindo Clean Architecture + Feature Modular**
