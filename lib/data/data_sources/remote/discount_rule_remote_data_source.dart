import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/config/flavor_config.dart';
import '../../../core/error/exceptions.dart';
import '../../../domain/entities/product/progressive_discount_rule.dart';

abstract class DiscountRuleRemoteDataSource {
  Future<ProgressiveDiscountRule?> getDiscountRuleByProduct(String productId);
}

class DiscountRuleRemoteDataSourceImpl
    implements DiscountRuleRemoteDataSource {
  final http.Client client;

  DiscountRuleRemoteDataSourceImpl({required this.client});

  @override
  Future<ProgressiveDiscountRule?> getDiscountRuleByProduct(
      String productId) async {
    try {
      final url = '${FlavorConfig.apiBaseUrl}/api/discount-rules/product/$productId';
      print('[DiscountRuleDataSource] 🌐 Buscando: $url');
      
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('[DiscountRuleDataSource] 📡 Status: ${response.statusCode}');
      print('[DiscountRuleDataSource] 📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Se não tem regra, retorna null
        if (data['rule'] == null) {
          print('[DiscountRuleDataSource] ❌ Nenhuma regra encontrada');
          return null;
        }
        
        print('[DiscountRuleDataSource] ✅ Regra encontrada: ${data['rule']['name']}');
        return ProgressiveDiscountRule.fromJson(data['rule']);
      } else {
        print('[DiscountRuleDataSource] ⚠️ Erro HTTP: ${response.statusCode}');
        throw ServerException();
      }
    } catch (e) {
      print('[DiscountRuleDataSource] 💥 EXCEÇÃO: $e');
      // Se der erro, retorna null (sem desconto)
      return null;
    }
  }
}
