import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // LIMPAR CONFIGURAÇÃO ANTIGA DO SHAREDPREFERENCES
  // Isso força o app a usar a configuração correta
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('store_config');
  
  debugPrint('🔄 Configuração antiga removida - usando URL correta do backend');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
