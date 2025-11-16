import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuthenticated = authState is _Authenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // Se não está autenticado e não está na tela de login, redireciona
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      // Se está autenticado e está na tela de login, redireciona para home
      if (isAuthenticated && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Tela de Registro - TODO'),
          ),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Categorias - TODO'),
          ),
        ),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Carrinho - TODO'),
          ),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Perfil - TODO'),
          ),
        ),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return Scaffold(
            body: Center(
              child: Text('Detalhes do Produto $id - TODO'),
            ),
          );
        },
      ),
    ],
  );
});
