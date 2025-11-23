import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'store_config.dart';

/// Provider que carrega e fornece a configuração da loja
final storeConfigProvider = FutureProvider<StoreConfig>((ref) async {
  // SEMPRE usar a configuração padrão (que agora tem a URL correta)
  return StoreConfig.defaultConfig;
});

/// Serviço para salvar configuração da loja
class StoreConfigService {
  static Future<void> saveConfig(StoreConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(config.toJson());
    await prefs.setString('store_config', json);
  }

  static Future<void> clearConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('store_config');
  }
}
