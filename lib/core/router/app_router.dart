// core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_or_register_screen.dart';
import '../../features/auth/presentation/view_model/auth_view_model.dart';
import '../../features/home/home_screen.dart';
import '../failures/value_failure.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => authState.isAuthenticated
            ? HomeScreen()
            : LoginOrRegisterScreen(),
      ),
      // other routes...
    ],
    redirect: (context, state) {
      if (authState is AuthFailure) {
        // You should return a **string path**, not the AuthFailure object.
        return '/login';
      }
      return null;
    },
  );
});
