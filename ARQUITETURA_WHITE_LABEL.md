# 🏢 Arquitetura White Label - Multi-Cliente

## 🎯 Objetivo

Gerar múltiplos apps (um por lojista) com o mesmo código Flutter, mas cada build terá configurações exclusivas.

---

## 📋 Checklist de Configurações por Cliente

### ✅ Essenciais (Você mencionou)
- [ ] Nome da loja
- [ ] Logo (ícone do app)
- [ ] Cores (tema)
- [ ] URL da API
- [ ] WhatsApp de suporte
- [ ] E-mail de contato

### ✅ Adicionais Recomendados

#### Identidade Visual
- [ ] Splash screen personalizado
- [ ] Cores primária e secundária
- [ ] Fonte customizada (opcional)
- [ ] Ícones personalizados

#### Configurações Técnicas
- [ ] Package name único (com.cliente.app)
- [ ] Bundle ID único (iOS)
- [ ] Firebase project (notificações push)
- [ ] Google Maps API Key
- [ ] Chaves de API de pagamento

#### Informações do Negócio
- [ ] Razão social
- [ ] CNPJ
- [ ] Endereço físico
- [ ] Telefone
- [ ] Redes sociais (Instagram, Facebook)
- [ ] Política de privacidade URL
- [ ] Termos de uso URL

#### Funcionalidades
- [ ] Métodos de pagamento aceitos
- [ ] Frete grátis acima de X
- [ ] Cupons de desconto habilitados
- [ ] Chat de suporte
- [ ] Avaliações de produtos

#### SEO e Marketing
- [ ] Descrição da loja (Play Store/App Store)
- [ ] Screenshots personalizados
- [ ] Palavras-chave
- [ ] Link do site

---

## 🏗️ Estrutura Proposta

### 1. Flavors do Flutter

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart          ← Configuração base
│   │   ├── flavor_config.dart       ← Gerenciador de flavors
│   │   └── flavors/
│   │       ├── cliente1_config.dart
│   │       ├── cliente2_config.dart
│   │       └── cliente3_config.dart
│   └── theme/
│       ├── app_theme.dart           ← Tema base
│       └── theme_config.dart        ← Tema por flavor
```

### 2. Arquivos de Configuração

#### `lib/core/config/app_config.dart`
```dart
class AppConfig {
  // Identidade
  final String appName;
  final String packageName;
  final String storeId;
  
  // API
  final String apiBaseUrl;
  final String apiKey;
  
  // Contato
  final String supportEmail;
  final String supportWhatsApp;
  final String supportPhone;
  
  // Redes Sociais
  final String? instagram;
  final String? facebook;
  final String? website;
  
  // Negócio
  final String companyName;
  final String cnpj;
  final String address;
  
  // URLs
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  
  // Funcionalidades
  final bool enableCoupons;
  final bool enableReviews;
  final bool enableChat;
  final double freeShippingThreshold;
  
  // Pagamento
  final List<String> paymentMethods;
  
  // Firebase
  final String firebaseProjectId;
  
  // Google Maps
  final String googleMapsApiKey;

  const AppConfig({
    required this.appName,
    required this.packageName,
    required this.storeId,
    required this.apiBaseUrl,
    required this.apiKey,
    required this.supportEmail,
    required this.supportWhatsApp,
    required this.supportPhone,
    this.instagram,
    this.facebook,
    this.website,
    required this.companyName,
    required this.cnpj,
    required this.address,
    required this.privacyPolicyUrl,
    required this.termsOfServiceUrl,
    this.enableCoupons = true,
    this.enableReviews = true,
    this.enableChat = false,
    this.freeShippingThreshold = 100.0,
    required this.paymentMethods,
    required this.firebaseProjectId,
    required this.googleMapsApiKey,
  });
}
```

#### `lib/core/config/flavor_config.dart`
```dart
enum Flavor {
  dev,
  cliente1,
  cliente2,
  cliente3,
}

class FlavorConfig {
  static Flavor? _currentFlavor;
  static AppConfig? _config;

  static Flavor get currentFlavor => _currentFlavor ?? Flavor.dev;
  static AppConfig get config => _config!;

  static void setFlavor(Flavor flavor, AppConfig config) {
    _currentFlavor = flavor;
    _config = config;
  }

  static bool get isDev => currentFlavor == Flavor.dev;
  static bool get isProd => currentFlavor != Flavor.dev;
}
```

#### `lib/core/config/flavors/cliente1_config.dart`
```dart
import '../app_config.dart';

const cliente1Config = AppConfig(
  // Identidade
  appName: 'Loja do Cliente 1',
  packageName: 'com.cliente1.eshop',
  storeId: 'store_cliente1',
  
  // API
  apiBaseUrl: 'https://api-cliente1.com',
  apiKey: 'key_cliente1',
  
  // Contato
  supportEmail: 'suporte@cliente1.com',
  supportWhatsApp: '+5511999999999',
  supportPhone: '+5511888888888',
  
  // Redes Sociais
  instagram: '@cliente1',
  facebook: 'cliente1oficial',
  website: 'https://www.cliente1.com',
  
  // Negócio
  companyName: 'Cliente 1 Comércio Ltda',
  cnpj: '00.000.000/0001-00',
  address: 'Rua Exemplo, 123 - São Paulo, SP',
  
  // URLs
  privacyPolicyUrl: 'https://www.cliente1.com/privacidade',
  termsOfServiceUrl: 'https://www.cliente1.com/termos',
  
  // Funcionalidades
  enableCoupons: true,
  enableReviews: true,
  enableChat: true,
  freeShippingThreshold: 150.0,
  
  // Pagamento
  paymentMethods: ['pix', 'credit_card', 'debit_card', 'boleto'],
  
  // Firebase
  firebaseProjectId: 'cliente1-eshop',
  
  // Google Maps
  googleMapsApiKey: 'AIza...',
);
```

### 3. Tema por Flavor

#### `lib/core/theme/theme_config.dart`
```dart
import 'package:flutter/material.dart';

class ThemeConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String? fontFamily;
  
  const ThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.fontFamily,
  });
  
  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
      ),
      fontFamily: fontFamily,
      // ... resto do tema
    );
  }
}

// Temas por cliente
const cliente1Theme = ThemeConfig(
  primaryColor: Color(0xFF1976D2), // Azul
  secondaryColor: Color(0xFFFFC107), // Amarelo
  accentColor: Color(0xFF4CAF50), // Verde
  fontFamily: 'Roboto',
);

const cliente2Theme = ThemeConfig(
  primaryColor: Color(0xFFE91E63), // Rosa
  secondaryColor: Color(0xFF9C27B0), // Roxo
  accentColor: Color(0xFFFF5722), // Laranja
  fontFamily: 'Poppins',
);
```

### 4. Assets por Flavor

```
assets/
├── flavors/
│   ├── cliente1/
│   │   ├── logo.png
│   │   ├── splash.png
│   │   └── icon.png
│   ├── cliente2/
│   │   ├── logo.png
│   │   ├── splash.png
│   │   └── icon.png
│   └── cliente3/
│       ├── logo.png
│       ├── splash.png
│       └── icon.png
```

### 5. Configuração Android

#### `android/app/build.gradle`
```gradle
android {
    flavorDimensions "client"
    
    productFlavors {
        dev {
            dimension "client"
            applicationId "com.eshop.dev"
            resValue "string", "app_name", "EShop Dev"
        }
        
        cliente1 {
            dimension "client"
            applicationId "com.cliente1.eshop"
            resValue "string", "app_name", "Loja Cliente 1"
        }
        
        cliente2 {
            dimension "client"
            applicationId "com.cliente2.eshop"
            resValue "string", "app_name", "Loja Cliente 2"
        }
    }
}
```

### 6. Configuração iOS

#### `ios/Runner/Info.plist`
```xml
<key>CFBundleDisplayName</key>
<string>$(APP_DISPLAY_NAME)</string>
```

#### Scripts de build
```bash
# Cliente 1
flutter build ios --flavor cliente1 --target lib/main_cliente1.dart

# Cliente 2
flutter build ios --flavor cliente2 --target lib/main_cliente2.dart
```

---

## 🚀 Como Usar

### 1. Criar Novo Cliente

#### Passo 1: Criar arquivo de configuração
```dart
// lib/core/config/flavors/novo_cliente_config.dart
const novoClienteConfig = AppConfig(
  appName: 'Loja do Novo Cliente',
  packageName: 'com.novocliente.eshop',
  storeId: 'store_novocliente',
  apiBaseUrl: 'https://api-novocliente.com',
  // ... resto das configurações
);
```

#### Passo 2: Criar tema
```dart
// lib/core/theme/theme_config.dart
const novoClienteTheme = ThemeConfig(
  primaryColor: Color(0xFF...), // Cor do cliente
  secondaryColor: Color(0xFF...),
  accentColor: Color(0xFF...),
);
```

#### Passo 3: Criar main
```dart
// lib/main_novocliente.dart
import 'core/config/flavor_config.dart';
import 'core/config/flavors/novo_cliente_config.dart';

void main() {
  FlavorConfig.setFlavor(
    Flavor.novoCliente,
    novoClienteConfig,
  );
  
  runApp(MyApp(theme: novoClienteTheme));
}
```

#### Passo 4: Adicionar flavor no build.gradle
```gradle
novoCliente {
    dimension "client"
    applicationId "com.novocliente.eshop"
    resValue "string", "app_name", "Loja Novo Cliente"
}
```

#### Passo 5: Adicionar assets
```
assets/flavors/novocliente/
├── logo.png
├── splash.png
└── icon.png
```

### 2. Buildar App do Cliente

```bash
# Android
flutter build apk --flavor novocliente --target lib/main_novocliente.dart

# iOS
flutter build ios --flavor novocliente --target lib/main_novocliente.dart

# Release
flutter build appbundle --flavor novocliente --target lib/main_novocliente.dart --release
```

---

## 📦 Estrutura de Pastas Completa

```
ecommerce_app/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   ├── flavor_config.dart
│   │   │   └── flavors/
│   │   │       ├── dev_config.dart
│   │   │       ├── cliente1_config.dart
│   │   │       ├── cliente2_config.dart
│   │   │       └── cliente3_config.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── theme_config.dart
│   │   └── constants/
│   │       └── strings.dart (removido URLs hardcoded)
│   ├── main_dev.dart
│   ├── main_cliente1.dart
│   ├── main_cliente2.dart
│   └── main_cliente3.dart
├── assets/
│   └── flavors/
│       ├── dev/
│       ├── cliente1/
│       ├── cliente2/
│       └── cliente3/
├── android/
│   └── app/
│       ├── build.gradle (com flavors)
│       └── src/
│           ├── dev/
│           ├── cliente1/
│           ├── cliente2/
│           └── cliente3/
└── ios/
    └── Runner/
        └── Configurations/
            ├── Dev.xcconfig
            ├── Cliente1.xcconfig
            ├── Cliente2.xcconfig
            └── Cliente3.xcconfig
```

---

## 🎨 Customizações por Cliente

### Logo e Ícones
```dart
// Carregar logo baseado no flavor
Image.asset(
  'assets/flavors/${FlavorConfig.currentFlavor.name}/logo.png',
)
```

### Cores
```dart
// Usar cores do tema do cliente
Container(
  color: Theme.of(context).primaryColor,
)
```

### Textos
```dart
// Usar nome da loja
Text(FlavorConfig.config.appName)
```

### API
```dart
// URL da API do cliente
final response = await http.get(
  Uri.parse('${FlavorConfig.config.apiBaseUrl}/products'),
);
```

---

## 🔐 Segurança

### Variáveis de Ambiente
```dart
// .env.cliente1
API_KEY=key_cliente1_secret
FIREBASE_KEY=firebase_key_cliente1
GOOGLE_MAPS_KEY=maps_key_cliente1
```

### Ofuscação
```bash
flutter build apk --obfuscate --split-debug-info=build/debug-info
```

---

## 📱 Publicação

### Play Store
```
1. Package name único: com.cliente1.eshop
2. Nome do app: Loja Cliente 1
3. Ícone personalizado
4. Screenshots personalizados
5. Descrição personalizada
```

### App Store
```
1. Bundle ID único: com.cliente1.eshop
2. Display name: Loja Cliente 1
3. Ícone personalizado
4. Screenshots personalizados
5. Descrição personalizada
```

---

## 🎯 Benefícios

### Para Você (Desenvolvedor)
- ✅ Um código, múltiplos apps
- ✅ Manutenção centralizada
- ✅ Fácil adicionar novos clientes
- ✅ Builds automatizados

### Para os Clientes
- ✅ App exclusivo com sua marca
- ✅ Identidade visual própria
- ✅ Configurações personalizadas
- ✅ Publicação independente

---

## 🚀 Próximos Passos

1. ✅ Implementar estrutura de flavors
2. ✅ Criar configurações base
3. ✅ Configurar build.gradle
4. ✅ Criar scripts de build
5. ✅ Documentar processo
6. ✅ Testar com cliente piloto

---

**Desenvolvido com ❤️ para EShop White Label**

✅ **ARQUITETURA PREPARADA PARA MÚLTIPLOS CLIENTES!**
