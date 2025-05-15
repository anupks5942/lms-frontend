import 'package:go_router/go_router.dart';
import '../../features/auth/pages/login_or_register_screen.dart';
import '../../features/home/pages/home_screen.dart';
import '../services/logger.dart';
import '../services/storage_manager.dart';
import 'app_routes.dart';
import 'app_storage_key.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) {
    try {
      final token = StorageManager.getStringValue(AppStorageKey.token);
      if (token != null && token.isNotEmpty) {
        return AppRoutes.home;
      }
    } catch (e) {
      Logger.error('Error parsing user data: $e');
    }
    return AppRoutes.login;
  },
  routes: [
    GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginOrRegisterScreen()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
  ],
);
