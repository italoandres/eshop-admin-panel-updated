# Instruções de Build e Configuração

## 📋 Passos para compilar o projeto

### 1. Instalar Flutter

Certifique-se de ter o Flutter SDK instalado:
- Flutter 3.16.0 ou superior
- Dart 3.2.0 ou superior

Verifique com:
```bash
flutter doctor
```

### 2. Clonar e configurar o projeto

```bash
cd ecommerce_app
flutter pub get
```

### 3. Gerar código (OBRIGATÓRIO)

O projeto usa Freezed e JsonSerializable. Execute:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Este comando vai gerar:
- `*.freezed.dart` - Classes imutáveis
- `*.g.dart` - Serialização JSON

### 4. Executar o app

```bash
flutter run
```

## ⚙️ Configuração White-Label

### Opção 1: Configuração Local (Desenvolvimento)

Edite `lib/core/config/store_config.dart`:

```dart
static StoreConfig get defaultConfig => const StoreConfig(
  storeId: 'sua-loja-id',
  apiBaseUrl: 'https://api.sualoja.com',
  storeName: 'Sua Loja',
  logoUrl: 'https://sualoja.com/logo.png',
  primaryColor: Color(0xFF6200EE), // Sua cor primária
  secondaryColor: Color(0xFF03DAC6), // Sua cor secundária
  currency: 'R\$',
);
```

### Opção 2: Configuração via JSON

1. Crie um arquivo `assets/store_config.json` baseado no `store_config_example.json`
2. Adicione ao `pubspec.yaml`:
```yaml
assets:
  - assets/store_config.json
```
3. Modifique `store_config_provider.dart` para carregar do JSON

### Opção 3: Configuração via API (Produção)

Modifique `store_config_provider.dart` para buscar da API:

```dart
final storeConfigProvider = FutureProvider<StoreConfig>((ref) async {
  final dio = Dio();
  final response = await dio.get('https://api.suaplataforma.com/stores/config');
  return StoreConfig.fromJson(response.data);
});
```

## 🔌 Configurar endpoint da API

### Desenvolvimento Local

Se estiver testando com API local:

```dart
apiBaseUrl: 'http://10.0.2.2:3000' // Android Emulator
apiBaseUrl: 'http://localhost:3000' // iOS Simulator
```

### Produção

```dart
apiBaseUrl: 'https://api.minhaloja.com.br'
```

## 🎨 Personalizar Cores

As cores são configuradas no `StoreConfig`:

```dart
primaryColor: Color(0xFF6200EE),  // #6200EE
secondaryColor: Color(0xFF03DAC6), // #03DAC6
```

Para converter HEX para Color:
- `#6200EE` → `Color(0xFF6200EE)`
- `#03DAC6` → `Color(0xFF03DAC6)`

## 📱 Build para Produção

### Android

```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🧪 Executar testes

```bash
flutter test
```

## 🐛 Problemas Comuns

### Erro: "*.freezed.dart not found"

**Solução**: Execute o build_runner
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Erro: "Could not resolve DioClient"

**Solução**: Verifique se a configuração da loja está carregada corretamente

### Erro: "Null check operator used on a null value"

**Solução**: Certifique-se de que o `storeConfigProvider` está retornando dados válidos

### Erro de CORS na API

**Solução**: Configure CORS no backend para aceitar requests do app móvel

## 📊 Monitoramento e Logs

### Ver logs do Dio

Os logs estão ativados por padrão em modo debug. Para desativar:

```dart
// Em dio_client.dart, comente:
// _dio.interceptors.add(LogInterceptor(...));
```

### Logger personalizado

O app usa o pacote `logger`. Para ajustar nível de log:

```dart
final Logger _logger = Logger(
  level: Level.debug, // debug, info, warning, error
);
```

## 🔒 Segurança

- Tokens JWT armazenados em `FlutterSecureStorage`
- NUNCA commitar chaves de API no código
- Use variáveis de ambiente para dados sensíveis
- Configure ProGuard para Android (obfuscação)

## 📦 Atualizar dependências

```bash
flutter pub upgrade
flutter pub outdated
```

## 🚀 Deploy

### Preparação

1. Atualizar versão em `pubspec.yaml`:
```yaml
version: 1.0.0+1
```

2. Gerar ícones do app:
```bash
flutter pub run flutter_launcher_icons:main
```

3. Build de produção

### Android - Google Play

```bash
flutter build appbundle --release
```

Arquivo gerado: `build/app/outputs/bundle/release/app-release.aab`

### iOS - App Store

```bash
flutter build ios --release
```

Depois abra o Xcode e faça upload via Archive.

---

**Qualquer dúvida, consulte a documentação oficial do Flutter: https://docs.flutter.dev**
