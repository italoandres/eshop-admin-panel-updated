#!/bin/bash

echo "🚀 Iniciando geração de código..."
echo ""

echo "📦 Instalando dependências..."
flutter pub get

echo ""
echo "🔨 Gerando arquivos com build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "✅ Geração de código concluída!"
echo ""
echo "Arquivos gerados:"
echo "  - *.freezed.dart (Freezed)"
echo "  - *.g.dart (JsonSerializable)"
echo ""
echo "Você pode executar o app com: flutter run"
