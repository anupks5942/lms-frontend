import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../screens/auth/controller/auth_provider.dart';
import '../../screens/auth/login_or_register.dart';
import '../../screens/home/home_page.dart';
import 'app_routes.dart'; 

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.login, 
  redirect: (context, state) async {
    final authProvider = context.read<AuthProvider>();
    final isAuthenticated = await authProvider.isLoggedIn();
    final currentPath = state.uri.toString();

    if (!isAuthenticated && currentPath != AppRoutes.login) return AppRoutes.login;
    if (isAuthenticated && currentPath == AppRoutes.login) return AppRoutes.home;
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginOrRegister(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
  ],
);