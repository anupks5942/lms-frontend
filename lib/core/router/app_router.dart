// core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_or_register_screen.dart';
import '../../features/auth/presentation/view_model/auth_view_model.dart';
import '../../features/home/home_screen.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final authState = ref.watch(authViewModelProvider);
      final isLoggedIn = authState.value != null;
      final isOnLoginPage = state.uri.toString() == AppRoutes.login;

      if (!isLoggedIn && !isOnLoginPage) return AppRoutes.login;
      if (isLoggedIn && isOnLoginPage) return AppRoutes.home;

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginOrRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});
