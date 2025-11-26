import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';

/// Provider for fetching products from the highlights featured section
/// Used for "Produtos Recomendados" section on home page
final highlightsProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProducts(featuredSection: 'highlights');
});

/// Provider for fetching products from the main featured section
/// Used for "Mais Vendidos" section on home page
final mainProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProducts(featuredSection: 'main');
});

/// Provider for fetching products from the new arrivals featured section
final newArrivalsProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProducts(featuredSection: 'newArrivals');
});

/// Provider for fetching products from the offers featured section
final offersProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProducts(featuredSection: 'offers');
});

/// Provider for fetching all products without filtering
final allProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiService = ref.watch(apiServiceProvider);
  return await apiService.getProducts();
});
