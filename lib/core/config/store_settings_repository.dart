import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import 'store_config.dart';

class StoreSettingsRepository {
  final DioClient _dioClient;
  final String storeId;

  StoreSettingsRepository(this._dioClient, {required this.storeId});

  Future<StoreConfig> fetchStoreSettings() async {
    try {
      final response = await _dioClient.get('/store-settings/$storeId');
      
      if (response.data['success'] == true) {
        final data = response.data['data'];
        
        // Converter os dados da API para StoreConfig
        return StoreConfig(
          storeId: data['storeId'] ?? storeId,
          apiBaseUrl: StoreConfig.defaultConfig.apiBaseUrl,
          storeName: data['storeName'] ?? 'EShop',
          logoUrl: data['logoUrl'] ?? '',
          primaryColor: StoreConfig.defaultConfig.primaryColor,
          secondaryColor: StoreConfig.defaultConfig.secondaryColor,
          currency: StoreConfig.defaultConfig.currency,
        );
      }
      
      return StoreConfig.defaultConfig;
    } catch (e) {
      print('Erro ao buscar configurações da loja: $e');
      return StoreConfig.defaultConfig;
    }
  }
}
