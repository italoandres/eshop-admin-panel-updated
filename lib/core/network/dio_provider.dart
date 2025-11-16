import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/store_config.dart';
import '../config/store_config_provider.dart';
import 'dio_client.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final config = ref.watch(storeConfigProvider).value ?? StoreConfig.defaultConfig;

  return DioClient(baseUrl: config.apiBaseUrl);
});
