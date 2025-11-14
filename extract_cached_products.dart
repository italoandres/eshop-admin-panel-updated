import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Script para extrair produtos do cache do SharedPreferences
/// Execute: dart run extract_cached_products.dart
void main() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Buscar produtos em cache
  final cachedProductsJson = prefs.getString('CACHED_PRODUCTS');
  
  if (cachedProductsJson != null) {
    print('=== PRODUTOS ENCONTRADOS NO CACHE ===\n');
    
    // Decodificar e formatar JSON
    final decoded = jsonDecode(cachedProductsJson);
    final prettyJson = JsonEncoder.withIndent('  ').convert(decoded);
    
    print(prettyJson);
    print('\n=== FIM DOS PRODUTOS ===');
  } else {
    print('❌ Nenhum produto encontrado no cache.');
    print('Execute o app Flutter primeiro para popular o cache.');
  }
}
