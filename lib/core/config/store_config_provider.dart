import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'store_config.dart';

/// Provider que carrega e fornece a configuração da loja
final storeConfigProvider = FutureProvider<StoreConfig>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final configJson = prefs.getString('store_config');

  if (configJson != null) {
    try {
      final Map<String, dynamic> json = jsonDecode(configJson);
      return StoreConfig.fromJson(json);
    } catch (e) {
      // Se houver erro ao parsear, usa config padrão
      return StoreConfig.defaultConfig;
    }
  }

  // TODO: Buscar configuração da API remota
  // Por enquanto, retorna configuração padrão
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
