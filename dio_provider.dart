import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/store_config_provider.dart';
import 'dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final config = ref.watch(storeConfigProvider).value;
  
  if (config == null) {
    throw Exception('Store config not loaded');
  }

  return DioClient(baseUrl: config.apiBaseUrl);
});
