# 🔧 Solução: OneDrive Bloqueando Flutter

## ❌ Problema
```
Flutter failed to delete a directory at
"windows\flutter\ephemeral\.plugin_symlinks"
The flutter tool cannot access the file or directory.
```

## 🎯 Causa
O **OneDrive** sincroniza arquivos e bloqueia o acesso, impedindo o Flutter de deletar/modificar arquivos temporários.

---

## ✅ Soluções (em ordem de preferência)

### 1. Rodar com `--no-pub` (Mais Rápido)
```bash
flutter run -d windows --no-pub
```
Pula a verificação de dependências e contorna o bloqueio.

### 2. Parar OneDrive Temporariamente
```powershell
# Parar OneDrive
Stop-Process -Name "OneDrive" -Force

# Limpar Flutter
flutter clean

# Rodar app
flutter run -d windows

# Reiniciar OneDrive depois
Start-Process "$env:LOCALAPPDATA\Microsoft\OneDrive\OneDrive.exe"
```

### 3. Excluir Pastas do OneDrive (Permanente)
1. Clique com botão direito no ícone do OneDrive (bandeja do sistema)
2. Configurações → Conta → Escolher pastas
3. Desmarque a pasta do projeto Flutter
4. Ou adicione estas pastas ao `.gitignore` e exclua da sincronização:
   - `build/`
   - `.dart_tool/`
   - `windows/flutter/ephemeral/`
   - `linux/flutter/ephemeral/`
   - `macos/Flutter/ephemeral/`
   - `ios/Flutter/ephemeral/`

### 4. Mover Projeto para Fora do OneDrive (Melhor Solução)
```bash
# Mover projeto para C:\Dev ou similar
mkdir C:\Dev
cd C:\Dev
git clone <seu-repositorio>
cd <projeto>
flutter run
```

---

## 🚀 Solução Aplicada Hoje
```bash
flutter run -d windows --no-pub
```
✅ Funcionou perfeitamente!

---

## 📝 Notas
- O problema é recorrente em projetos Flutter dentro do OneDrive
- A flag `--no-pub` é segura se você não mudou dependências
- Se mudar `pubspec.yaml`, rode `flutter pub get` antes

---

**Data:** 26/01/2025
**Status:** ✅ Resolvido com `--no-pub`
