import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/api_config.dart';
import 'http_service.dart';
import '../../features/banners/domain/models/banner_model.dart';
import '../config/store_config.dart';

/// Provider do HttpService
final httpServiceProvider = Provider<HttpService>((ref) => HttpService());

/// Provider do ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final httpService = ref.read(httpServiceProvider);
  return ApiService(httpService);
});

/// Serviço de API para comunicação com o backend
class ApiService {
  final HttpService _httpService;

  ApiService(this._httpService);

  // ==================== BANNERS ====================

  /// Busca banners ativos de uma loja (público)
  Future<List<BannerModel>> getBanners(String storeId) async {
    try {
      final response = await _httpService.get(
        '${ApiConfig.bannersEndpoint}/$storeId/banners',
      );

      if (response is List) {
        return response
            .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Erro ao buscar banners: $e');
    }
  }

  /// Busca todos os banners (incluindo inativos) - Admin
  Future<List<BannerModel>> getAllBanners(String storeId) async {
    try {
      final response = await _httpService.get(
        '/api/admin${ApiConfig.bannersEndpoint}/$storeId/banners',
        headers: ApiConfig.adminHeaders,
      );

      if (response is List) {
        return response
            .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Erro ao buscar todos os banners: $e');
    }
  }

  /// Cria um novo banner - Admin
  Future<BannerModel> createBanner(
    String storeId,
    Map<String, dynamic> bannerData,
  ) async {
    try {
      final response = await _httpService.post(
        '/api/admin${ApiConfig.bannersEndpoint}/$storeId/banners',
        headers: ApiConfig.adminHeaders,
        body: bannerData,
      );

      if (response != null) {
        return BannerModel.fromJson(response as Map<String, dynamic>);
      }

      throw Exception('Resposta vazia ao criar banner');
    } catch (e) {
      throw Exception('Erro ao criar banner: $e');
    }
  }

  /// Atualiza um banner existente - Admin
  Future<BannerModel> updateBanner(
    String storeId,
    String bannerId,
    Map<String, dynamic> bannerData,
  ) async {
    try {
      final response = await _httpService.put(
        '/api/admin${ApiConfig.bannersEndpoint}/$storeId/banners/$bannerId',
        headers: ApiConfig.adminHeaders,
        body: bannerData,
      );

      if (response != null) {
        return BannerModel.fromJson(response as Map<String, dynamic>);
      }

      throw Exception('Resposta vazia ao atualizar banner');
    } catch (e) {
      throw Exception('Erro ao atualizar banner: $e');
    }
  }

  /// Deleta um banner - Admin
  Future<void> deleteBanner(String storeId, String bannerId) async {
    try {
      await _httpService.delete(
        '/api/admin${ApiConfig.bannersEndpoint}/$storeId/banners/$bannerId',
        headers: ApiConfig.adminHeaders,
      );
    } catch (e) {
      throw Exception('Erro ao deletar banner: $e');
    }
  }

  // ==================== STORE SETTINGS ====================

  /// Busca configurações da loja
  Future<StoreConfig> getStoreSettings(String storeId) async {
    try {
      final response = await _httpService.get(
        '${ApiConfig.storeSettingsEndpoint}/$storeId',
      );

      if (response != null && response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>;
        return StoreConfig.fromJson(data);
      }

      // Retorna configuração padrão se não encontrar
      return StoreConfig.defaultConfig;
    } catch (e) {
      // Em caso de erro, retorna configuração padrão
      return StoreConfig.defaultConfig;
    }
  }

  // ==================== PRODUCTS ====================

  /// Busca todos os produtos com filtro opcional de seção destacada
  /// 
  /// [featuredSection] - Opcional. Filtra produtos por seção destacada:
  ///   - 'highlights': Produtos em destaque
  ///   - 'newArrivals': Lançamentos
  ///   - 'offers': Ofertas
  ///   - 'main': Principal
  Future<List<dynamic>> getProducts({String? featuredSection}) async {
    try {
      // Construir query string se featuredSection for fornecido
      final queryParams = featuredSection != null 
          ? '?featuredSection=$featuredSection' 
          : '';
      
      final response = await _httpService.get(
        '${ApiConfig.productsEndpoint}$queryParams',
      );

      if (response != null && response['data'] is List) {
        return response['data'] as List;
      }

      return [];
    } catch (e) {
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  /// Busca produto por ID
  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      final response = await _httpService.get(
        '${ApiConfig.productsEndpoint}/$productId',
      );

      // O backend retorna os dados diretamente, não dentro de um campo 'data'
      if (response != null) {
        // Se tem um campo 'data', usa ele
        if (response['data'] != null) {
          return response['data'] as Map<String, dynamic>;
        }
        // Senão, retorna a resposta diretamente
        return response as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      throw Exception('Erro ao buscar produto: $e');
    }
  }
}
