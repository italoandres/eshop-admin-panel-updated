# 🔧 SOLUÇÃO: Logo Retornando 404

## 🐛 Problemas Identificados

### 1. URL Incorreta (404)
```
❌ Estava: http://192.168.0.103:4000/store-settings/store_001
✅ Correto: http://192.168.0.103:4000/api/store-settings/eshop_001
```

**Problemas:**
- Faltava `/api/` na URL
- StoreId errado (`store_001` vs `eshop_001`)

### 2. Erro de Decodificação Base64
```
E/FlutterJNI: Failed to decode image
E/FlutterJNI: android.graphics.ImageDecoder$DecodeException
```

**Causa:** Imagem base64 pode ter espaços ou quebras de linha

## ✅ Correções Aplicadas

### 1. Corrigida URL no DataSource
**Arquivo:** `lib/data/data_sources/remote/store_settings_remote_data_source.dart`

```dart
// ANTES
Uri.parse('${FlavorConfig.apiBaseUrl}/store-settings/$storeId')

// DEPOIS
Uri.parse('${FlavorConfig.apiBaseUrl}/api/store-settings/$storeId')
```

### 2. Corrigido StoreId
**Arquivo:** `lib/core/config/flavors/dev_config.dart`

```dart
// ANTES
storeId: 'store_001',

// DEPOIS
storeId: 'eshop_001',
```

### 3. Melhorada Decodificação Base64
**Arquivo:** `lib/presentation/views/main/home/home_view.dart`

```dart
// Remove espaços e quebras de linha
base64String = base64String.replaceAll(RegExp(r'\s+'), '');

// Decodifica
final bytes = base64Decode(base64String);

// Logs detalhados
print('[HomeView] 🖼️ Tentando decodificar logo (${base64String.length} chars)');
print('[HomeView] ✅ Logo decodificada (${bytes.length} bytes)');
```

## 🧪 Como Testar

### 1. Hot Restart
```bash
# No terminal do Flutter, pressione:
R
```

### 2. Verificar Logs
Procure por:
```
[StoreSettingsDataSource] 🌐 Buscando: http://192.168.0.103:4000/api/store-settings/eshop_001
[StoreSettingsDataSource] 📡 Status: 200
[StoreSettingsDataSource] ✅ Settings carregadas com sucesso
[HomeView] ✅ Settings carregadas: Minha Loja
[HomeView] 🖼️ Logo URL length: 75000
[HomeView] 🖼️ Tentando decodificar logo (75000 chars)
[HomeView] ✅ Logo decodificada (50000 bytes)
```

### 3. Resultado Esperado
- Logo deve aparecer no topo da home
- Se falhar, deve mostrar "Minha Loja"
- Sem erros 404

## 🔍 Verificação Backend

### Testar endpoint:
```bash
curl http://localhost:4000/api/store-settings/eshop_001
```

### Resposta esperada:
```json
{
  "success": true,
  "data": {
    "storeId": "eshop_001",
    "storeName": "Minha Loja",
    "logoUrl": "data:image/png;base64,iVBORw0KG...",
    "logoPosition": "center",
    "primaryColor": "#FF6B6B",
    "secondaryColor": "#4ECDC4"
  }
}
```

## 🐛 Troubleshooting

### Se ainda retornar 404:

#### 1. Verificar backend rodando:
```bash
cd backend
npm start
```

#### 2. Verificar MongoDB:
```bash
# Deve ter documento com storeId: "eshop_001"
```

#### 3. Verificar rota no backend:
**Arquivo:** `backend/server.js`
```javascript
app.use('/api/store-settings', storeSettingsRoutes);
```

### Se logo não aparecer:

#### 1. Verificar logs do Flutter:
```
[HomeView] ❌ Erro ao decodificar logo: ...
```

#### 2. Verificar formato base64:
- Deve começar com `data:image/png;base64,` ou `data:image/jpeg;base64,`
- Não deve ter espaços ou quebras de linha (agora removidos automaticamente)

#### 3. Testar com logo menor:
- Fazer upload de imagem menor no admin
- Backend redimensiona para 400x400px automaticamente

### Se aparecer "Minha Loja":

Isso é o **fallback esperado** quando:
- Logo não foi cadastrada
- Logo falhou ao decodificar
- Erro de rede

## 📊 Fluxo Correto

```
1. HomeView.initState()
   ↓
2. _loadStoreSettings()
   ↓
3. GET http://192.168.0.103:4000/api/store-settings/eshop_001
   ↓
4. Status 200 ✅
   ↓
5. Parse JSON → StoreSettings entity
   ↓
6. setState() → _storeSettings
   ↓
7. _buildLogo()
   ↓
8. Decodifica base64
   ↓
9. Image.memory() renderiza
   ↓
10. Logo aparece! 🎉
```

## 🎯 Próximos Passos

1. ✅ **Corrigir URL** - FEITO
2. ✅ **Corrigir StoreId** - FEITO
3. ✅ **Melhorar decodificação** - FEITO
4. 🔄 **Testar no dispositivo** - PRÓXIMO
5. 📦 **Adicionar cache** (opcional)

## 📝 Notas Técnicas

### Por que o erro de decodificação?

O Android `ImageDecoder` é mais rigoroso que o iOS. Ele falha se:
- Base64 tem espaços
- Base64 tem quebras de linha
- Formato de imagem não suportado
- Imagem corrompida

### Solução aplicada:
```dart
// Remove TODOS os espaços em branco
base64String = base64String.replaceAll(RegExp(r'\s+'), '');
```

Isso garante que o base64 está limpo antes de decodificar.

---

**Status**: ✅ CORREÇÕES APLICADAS  
**Próximo**: Hot Restart e testar  
**Resultado Esperado**: Logo aparecendo na home! 🎉
