import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/errors/app_error.dart';
import '../../../../core/network/dio_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/user_model.dart';

part 'auth_notifier.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserModel user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(AppError error) = _Error;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await _repository.isLoggedIn();

    // Verifica se o notifier ainda está montado antes de atualizar o estado
    if (!mounted) return;

    if (isLoggedIn) {
      // TODO: Buscar dados do usuário
      state = const AuthState.unauthenticated();
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    try {
      final user = await _repository.login(email, password);
      state = AuthState.authenticated(user);
    } on AppError catch (e) {
      state = AuthState.error(e);
    } catch (e) {
      state = AuthState.error(AppError.unknown(message: e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = const AuthState.loading();

    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      state = AuthState.authenticated(user);
    } on AppError catch (e) {
      state = AuthState.error(e);
    } catch (e) {
      state = AuthState.error(AppError.unknown(message: e.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState.unauthenticated();
  }
}

// Provider do repositório de autenticação
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository(dioClient);
});

// Provider do notifier de autenticação
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthNotifier(repository);
  },
);
