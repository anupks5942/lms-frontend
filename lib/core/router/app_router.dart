import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_or_register_screen.dart';
import '../../features/auth/presentation/view_model/auth_view_model.dart';
import '../../features/home/home_screen.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => AppRoutes.login,
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) {
          return HomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          return LoginOrRegisterScreen();
        },
      ),
    ],
    redirect: (context, state) {
      return authState.when(
        data: (user) {
          if (user != null && state.uri.toString() == AppRoutes.login) {
            return AppRoutes.home;
          }
          return null;
        },
        error: (error, stack) {
          if (state.uri.toString() != AppRoutes.login) {
            return AppRoutes.login;
          }
          return null;
        },
        loading: () => null,
      );
    },
  );
});
