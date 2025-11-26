import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';

/// Provider para buscar detalhes de um produto específico por ID
final productDetailProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, productId) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProductById(productId);
});
