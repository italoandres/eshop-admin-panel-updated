import 'package:dio/dio.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/network/dio_client.dart';
import '../dtos/banner_dto.dart';
import '../../domain/models/banner_model.dart';

class BannerRepository {
  final DioClient _dioClient;

  BannerRepository(this._dioClient);

  Future<List<BannerModel>> fetchBanners() async {
    try {
      // Rota correta: /stores/:storeId/banners
      final response = await _dioClient.get<Map<String, dynamic>>('/stores/eshop_001/banners');

      if (response.data == null) {
        throw const AppError.server(message: 'Resposta vazia do servidor');
      }

      // Assumindo que a API retorna: { "data": [...] }
      final List<dynamic> bannersJson = response.data!['data'] ?? [];

      final banners = bannersJson
          .map((json) => BannerDto.fromJson(json as Map<String, dynamic>))
          .where((dto) => dto.active) // Filtra apenas banners ativos
          .map((dto) => dto.toModel())
          .toList();

      // Ordena por ordem
      banners.sort((a, b) => a.order.compareTo(b.order));

      return banners;
    } on DioException catch (e) {
      // NÃO retornar banners mock - mostrar erro real
      // if (e.type == DioExceptionType.connectionError ||
      //     e.type == DioExceptionType.unknown) {
      //   return _getMockBanners();
      // }

      if (e.response?.statusCode == 404) {
        throw const AppError.notFound(message: 'Banners não encontrados');
      } else if (e.response?.statusCode == 401) {
        throw const AppError.unauthorized();
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const AppError.network(
          message: 'Tempo de conexão esgotado',
        );
      } else {
        throw AppError.server(
          message: e.message ?? 'Erro ao buscar banners',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw AppError.unknown(message: e.toString());
    }
  }

  // Banners mock para desenvolvimento/teste
  List<BannerModel> _getMockBanners() {
    return [
      BannerModel(
        id: 'mock-banner-1',
        title: 'Ofertas de Verão',
        imageUrl: 'https://picsum.photos/800/300?random=1',
        targetUrl: null,
        order: 1,
        active: true,
      ),
      BannerModel(
        id: 'mock-banner-2',
        title: 'Novos Produtos',
        imageUrl: 'https://picsum.photos/800/300?random=2',
        targetUrl: null,
        order: 2,
        active: true,
      ),
      BannerModel(
        id: 'mock-banner-3',
        title: 'Promoção Especial',
        imageUrl: 'https://picsum.photos/800/300?random=3',
        targetUrl: null,
        order: 3,
        active: true,
      ),
    ];
  }

  Future<BannerModel> fetchBannerById(String id) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>(
        '/banners/$id',
      );

      if (response.data == null) {
        throw const AppError.server(message: 'Resposta vazia do servidor');
      }

      final bannerDto = BannerDto.fromJson(response.data!['data']);
      return bannerDto.toModel();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const AppError.notFound(message: 'Banner não encontrado');
      } else {
        throw AppError.server(
          message: e.message ?? 'Erro ao buscar banner',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw AppError.unknown(message: e.toString());
    }
  }
}
