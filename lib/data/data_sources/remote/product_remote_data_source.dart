import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../core/config/flavor_config.dart';
import '../../../domain/usecases/product/get_product_usecase.dart';
import '../../models/product/product_response_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseModel> getProducts(FilterProductParams params);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<ProductResponseModel> getProducts(params) => _getProductFromUrl(
      '${FlavorConfig.apiBaseUrl}/api/products?keyword=${params.keyword}&pageSize=${params.pageSize}&page=${params.limit}&categories=${jsonEncode(params.categories.map((e) => e.id).toList())}');

  Future<ProductResponseModel> _getProductFromUrl(String url) async {
    print('[ProductRemoteDataSource] Fetching from: $url');
    final response = await client.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print('[ProductRemoteDataSource] Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('[ProductRemoteDataSource] Response body length: ${response.body.length}');
      try {
        final result = productResponseModelFromJson(response.body);
        print('[ProductRemoteDataSource] Parsed ${result.products.length} products');
        return result;
      } catch (e, stackTrace) {
        print('[ProductRemoteDataSource] Parse error: $e');
        print('[ProductRemoteDataSource] StackTrace: $stackTrace');
        print('[ProductRemoteDataSource] Response body (first 500 chars): ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}');
        rethrow;
      }
    } else {
      throw ServerException();
    }
  }
}
