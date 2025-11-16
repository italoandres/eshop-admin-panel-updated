import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/network/dio_client.dart';
import '../dtos/auth_response_dto.dart';
import '../../domain/models/user_model.dart';

class AuthRepository {
  final DioClient _dioClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRepository(this._dioClient);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data == null) {
        throw const AppError.server(message: 'Resposta vazia do servidor');
      }

      final authResponse = AuthResponseDto.fromJson(response.data!);

      // Salva tokens
      await _secureStorage.write(key: 'auth_token', value: authResponse.token);
      await _secureStorage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );

      return authResponse.user.toModel();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const AppError.unauthorized(
          message: 'Email ou senha incorretos',
        );
      } else if (e.response?.statusCode == 422) {
        throw AppError.validation(
          message: 'Dados inválidos',
          errors: e.response?.data['errors'],
        );
      } else {
        throw AppError.server(
          message: e.message ?? 'Erro ao fazer login',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw AppError.unknown(message: e.toString());
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.read(key: 'auth_token');
    return token != null;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _dioClient.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.data == null) {
        throw const AppError.server(message: 'Resposta vazia do servidor');
      }

      final authResponse = AuthResponseDto.fromJson(response.data!);

      // Salva tokens
      await _secureStorage.write(key: 'auth_token', value: authResponse.token);
      await _secureStorage.write(
        key: 'refresh_token',
        value: authResponse.refreshToken,
      );

      return authResponse.user.toModel();
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw AppError.validation(
          message: 'Dados inválidos',
          errors: e.response?.data['errors'],
        );
      } else {
        throw AppError.server(
          message: e.message ?? 'Erro ao criar conta',
          statusCode: e.response?.statusCode,
        );
      }
    } catch (e) {
      throw AppError.unknown(message: e.toString());
    }
  }
}
