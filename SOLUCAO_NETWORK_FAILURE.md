# 🔥 SOLUÇÃO: NetworkFailure - Celular não acessa backend

## PROBLEMA

```
[GetBannersUseCase] Error: NetworkFailure()
[BannerCubit] Error: NetworkFailure()
```

O celular não consegue acessar `http://192.168.0.103:4000`

## CAUSA

Firewall do Windows está bloqueando a porta 4000.

## SOLUÇÃO RÁPIDA

### 1. Liberar porta 4000 no Firewall

Execute este comando no PowerShell **COMO ADMINISTRADOR**:

```powershell
New-NetFirewallRule -DisplayName "Node Backend 4000" -Direction Inbound -LocalPort 4000 -Protocol TCP -Action Allow
```

### 2. OU Desabilitar Firewall temporariamente

**Painel de Controle** → **Firewall do Windows** → **Ativar ou desativar o Firewall** → Desativar (temporário)

### 3. Verificar se funcionou

No celular, abra o navegador e acesse:
```
http://192.168.0.103:4000/api/products
```

Se aparecer JSON com produtos, funcionou!

## VERIFICAÇÕES

### ✅ Backend está rodando
```
🚀 Servidor na porta 4000
📍 http://localhost:4000/api
```

### ✅ IP está correto
```
192.168.0.103
```

### ✅ Flutter configurado
```dart
apiBaseUrl: 'http://192.168.0.103:4000'
```

### ❌ Firewall bloqueando
Porta 4000 não está acessível externamente

## ALTERNATIVA: Usar ngrok

Se não conseguir liberar o firewall:

```bash
# Instalar ngrok
choco install ngrok

# Expor porta 4000
ngrok http 4000
```

Copie a URL do ngrok (ex: `https://abc123.ngrok.io`) e atualize no Flutter:

```dart
// lib/core/config/flavors/dev_config.dart
apiBaseUrl: 'https://abc123.ngrok.io'
```

## TESTE FINAL

Após liberar o firewall:

1. Hot Restart no Flutter (R maiúsculo)
2. Os produtos devem aparecer
3. Banners devem carregar
