import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import 'store_config.dart';
import 'store_settings_repository.dart';

/// Provider do repositório de configurações
/// Usa DioClient diretamente para evitar dependência circular
final storeSettingsRepositoryProvider = Provider<StoreSettingsRepository>((ref) {
  // Criar DioClient diretamente com a URL hardcoded para evitar circularidade
  final dioClient = DioClient(baseUrl: 'https://eshop-backend-bfhw.onrender.com/api');
  return StoreSettingsRepository(dioClient, storeId: 'eshop_001');
});

/// Provider que carrega e fornece a configuração da loja
final storeConfigProvider = FutureProvider<StoreConfig>((ref) async {
  final repository = ref.watch(storeSettingsRepositoryProvider);
  
  try {
    // Buscar configurações do backend
    return await repository.fetchStoreSettings();
  } catch (e) {
    print('Erro ao carregar configurações: $e');
    // Em caso de erro, usar configuração padrão
    return StoreConfig.defaultConfig;
  }
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
