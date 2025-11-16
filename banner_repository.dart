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
      final response = await _dioClient.get<Map<String, dynamic>>('/banners');

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
