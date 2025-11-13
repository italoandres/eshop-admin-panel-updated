# 🌐 Como Descobrir Seu IP Local

## ❌ Problema

O app Flutter não está mostrando os banners porque está tentando acessar `http://192.168.0.103:4000`, mas esse pode não ser o IP correto da sua máquina.

---

## ✅ Solução: Descobrir Seu IP

### Windows

1. **Abra o Prompt de Comando (CMD)**
   - Pressione `Win + R`
   - Digite `cmd`
   - Pressione Enter

2. **Digite o comando:**
   ```cmd
   ipconfig
   ```

3. **Procure por:**
   ```
   Adaptador de Rede sem Fio Wi-Fi:
   
   Endereço IPv4. . . . . . . . . . : 192.168.0.XXX
   ```

4. **Copie o número** (ex: `192.168.0.105`)

### Mac/Linux

1. **Abra o Terminal**

2. **Digite o comando:**
   ```bash
   ifconfig
   ```

3. **Procure por:**
   ```
   inet 192.168.0.XXX
   ```

4. **Copie o número**

---

## 🔧 Configurar no Projeto

### Opção 1: Arquivo de Configuração (Recomendado)

Edite o arquivo: `lib/core/config/flavors/dev_config.dart`

```dart
const devConfig = AppConfig(
  // ...
  bannerApiUrl: 'http://SEU_IP_AQUI:4000', // ← Altere aqui!
  // ...
);
```

**Exemplo:**
```dart
bannerApiUrl: 'http://192.168.0.105:4000',
```

### Opção 2: Arquivo strings.dart (Temporário)

Edite o arquivo: `lib/core/constant/strings.dart`

```dart
const String bannerApiUrl = 'http://SEU_IP_AQUI:4000';
```

---

## 🧪 Testar a Conexão

### 1. Verificar se o Backend está Rodando

```bash
cd backend
npm run dev:simple
```

Deve mostrar:
```
✅ Servidor pronto para uso!
```

### 2. Testar no Navegador

Abra no navegador do seu celular (conectado na mesma rede Wi-Fi):

```
http://SEU_IP:4000/health
```

**Exemplo:**
```
http://192.168.0.105:4000/health
```

**Resposta esperada:**
```json
{
  "status": "OK",
  "timestamp": "2024-11-13T...",
  "database": "In-Memory (Test Mode)"
}
```

### 3. Testar API de Banners

```
http://SEU_IP:4000/api/stores/store_001/banners
```

**Deve retornar:**
```json
[
  {
    "_id": "1",
    "title": "Banner de Teste 1",
    ...
  }
]
```

---

## 📱 Testar no App

### 1. Rebuild do App

```bash
flutter clean
flutter pub get
flutter run
```

### 2. Verificar Logs

Procure por:
```
[BannerRemoteDataSource] Fetching from: http://SEU_IP:4000/api/stores/store_001/banners
[BannerRemoteDataSource] Response status: 200
[BannerRemoteDataSource] Parsed 3 banners
```

### 3. Ver Banners na Home

Os banners devem aparecer no carrossel da home! 🎉

---

## 🔥 Firewall

Se ainda não funcionar, pode ser o firewall bloqueando:

### Windows

1. **Abra o Firewall do Windows**
2. **Configurações Avançadas**
3. **Regras de Entrada**
4. **Nova Regra**
5. **Porta → TCP → 4000**
6. **Permitir conexão**

### Mac

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/local/bin/node
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp /usr/local/bin/node
```

---

## 🌐 Alternativa: Usar ngrok (Produção)

Para não depender de IP local:

### 1. Instalar ngrok

```bash
# Windows (com Chocolatey)
choco install ngrok

# Mac (com Homebrew)
brew install ngrok
```

### 2. Expor o Backend

```bash
ngrok http 4000
```

### 3. Copiar URL

```
Forwarding: https://abc123.ngrok.io -> http://localhost:4000
```

### 4. Usar no App

```dart
bannerApiUrl: 'https://abc123.ngrok.io',
```

**Vantagens:**
- ✅ Funciona de qualquer lugar
- ✅ HTTPS automático
- ✅ Não precisa configurar firewall

**Desvantagens:**
- ⚠️ URL muda toda vez que reinicia
- ⚠️ Versão grátis tem limitações

---

## 📋 Checklist de Troubleshooting

- [ ] Backend está rodando?
- [ ] IP está correto?
- [ ] Celular e computador na mesma rede Wi-Fi?
- [ ] Firewall não está bloqueando?
- [ ] URL no código está atualizada?
- [ ] App foi rebuilded após mudança?
- [ ] Teste no navegador do celular funciona?

---

## 🎯 Resumo Rápido

```bash
# 1. Descobrir IP
ipconfig  # Windows
ifconfig  # Mac/Linux

# 2. Atualizar código
# Editar: lib/core/config/flavors/dev_config.dart
bannerApiUrl: 'http://SEU_IP:4000'

# 3. Rebuild app
flutter clean
flutter run

# 4. Testar
# Abrir no navegador do celular:
http://SEU_IP:4000/health
```

---

**Desenvolvido com ❤️ para o EShop**

✅ **SIGA ESTES PASSOS E OS BANNERS VÃO APARECER!**
