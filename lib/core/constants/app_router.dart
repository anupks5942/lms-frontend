import 'package:go_router/go_router.dart';
import 'package:lms1/features/course/pages/course_details_screen.dart';
import 'package:lms1/features/home/home_screen.dart';
import '../../features/auth/pages/login_or_register_screen.dart';
import '../../features/course/models/course.dart';
import '../services/logger.dart';
import '../services/storage_manager.dart';
import 'app_routes.dart';
import 'app_storage_key.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  redirect: (context, state) {
    try {
      final token = StorageManager.getStringValue(AppStorageKey.token);
      final isAuthenticated = token != null && token.isNotEmpty;
      final isLoginRoute = state.uri.toString() == AppRoutes.login;

      if (!isAuthenticated && !isLoginRoute) {
        Logger.info('Redirecting to login: Not authenticated');
        return AppRoutes.login;
      }
      if (isAuthenticated && isLoginRoute) {
        Logger.info('Redirecting to home: Authenticated');
        return AppRoutes.home;
      }
      return null;
    } catch (e) {
      Logger.error('Error parsing user data: $e');
      return AppRoutes.login;
    }
  },
  routes: [
    GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginOrRegisterScreen()),
    GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: AppRoutes.courseDetails,
      builder: (context, state) {
        final course = state.extra as Course?;
        if (course == null) {
          Logger.error('No course provided for courseDetails route');
          return const HomeScreen();
        }
        Logger.info('Navigating to CourseDetailsScreen: ${course.title}');
        return CourseDetailsScreen(course: course);
      },
    ),
  ],
);
