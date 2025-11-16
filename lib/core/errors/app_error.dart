import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
class AppError with _$AppError {
  const factory AppError.network({
    required String message,
    int? statusCode,
  }) = NetworkError;

  const factory AppError.server({
    required String message,
    int? statusCode,
  }) = ServerError;

  const factory AppError.unauthorized({
    @Default('Não autorizado') String message,
  }) = UnauthorizedError;

  const factory AppError.notFound({
    @Default('Recurso não encontrado') String message,
  }) = NotFoundError;

  const factory AppError.validation({
    required String message,
    Map<String, List<String>>? errors,
  }) = ValidationError;

  const factory AppError.unknown({
    required String message,
  }) = UnknownError;

  const factory AppError.cache({
    required String message,
  }) = CacheError;
}

extension AppErrorExtension on AppError {
  String get displayMessage {
    return when(
      network: (message, _) => 'Erro de conexão: $message',
      server: (message, _) => 'Erro no servidor: $message',
      unauthorized: (message) => message,
      notFound: (message) => message,
      validation: (message, _) => message,
      unknown: (message) => message,
      cache: (message) => 'Erro ao acessar cache: $message',
    );
  }
}
