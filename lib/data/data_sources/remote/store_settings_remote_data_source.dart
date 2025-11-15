import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/config/flavor_config.dart';
import '../../../domain/entities/store_settings/store_settings.dart';

abstract class StoreSettingsRemoteDataSource {
  Future<StoreSettings> getStoreSettings(String storeId);
}

class StoreSettingsRemoteDataSourceImpl implements StoreSettingsRemoteDataSource {
  final http.Client client;

  StoreSettingsRemoteDataSourceImpl({required this.client});

  @override
  Future<StoreSettings> getStoreSettings(String storeId) async {
    try {
      print('[StoreSettingsDataSource] 🌐 Buscando: ${FlavorConfig.apiBaseUrl}/store-settings/$storeId');
      
      final response = await client.get(
        Uri.parse('${FlavorConfig.apiBaseUrl}/api/store-settings/$storeId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('[StoreSettingsDataSource] 📡 Status: ${response.statusCode}');
      print('[StoreSettingsDataSource] 📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          print('[StoreSettingsDataSource] ✅ Settings carregadas com sucesso');
          return StoreSettings.fromJson(jsonData['data']);
        } else {
          throw Exception('API retornou success: false');
        }
      } else {
        throw Exception('Erro HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('[StoreSettingsDataSource] ❌ Erro: $e');
      throw Exception('Erro ao buscar configurações: $e');
    }
  }
}
