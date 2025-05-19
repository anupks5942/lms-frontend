import 'package:go_router/go_router.dart';
import 'package:lms1/features/student/course/pages/course_details_screen.dart';
import 'package:lms1/features/home/home_screen.dart';
import 'package:lms1/features/student/course/pages/students_screen.dart';
import 'package:lms1/features/student/quiz/models/quiz.dart';
import 'package:lms1/features/student/quiz/pages/attempt_quiz_screen.dart';
import '../../features/auth/pages/login_or_register_screen.dart';
import '../../features/student/content/pages/lecture_screen.dart';
import '../../features/student/content/pages/video_player_screen.dart';
import '../../features/student/course/models/course.dart';
import '../../features/student/quiz/pages/create_quiz_screen.dart';
import '../../features/student/quiz/pages/quizzes_screen.dart';
import '../services/logger.dart';
import '../services/storage_manager.dart';
import 'app_routes.dart';
import 'app_storage_key.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    try {
      final token = StorageManager.getStringValue(AppStorageKey.token);
      final isAuthenticated = token != null && token.isNotEmpty;
      final isLoginRoute = state.uri.toString() == AppRoutes.login;

      if (!isAuthenticated && !isLoginRoute) {
        return AppRoutes.login;
      }
      if (isAuthenticated && isLoginRoute) {
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
          return const HomeScreen();
        }
        return CourseDetailsScreen(course: course);
      },
    ),
    GoRoute(
      path: AppRoutes.quizzes,
      builder: (context, state) {
        final courseId = state.extra as String?;
        if (courseId == null) {
          return const HomeScreen();
        }
        return QuizzesScreen(courseId: courseId);
      },
    ),
    GoRoute(
      path: AppRoutes.quiz,
      builder: (context, state) {
        final quiz = state.extra as Quiz?;
        if (quiz == null) {
          return const HomeScreen();
        }
        return AttemptQuizScreen(quiz: quiz);
      },
    ),
    GoRoute(
      path: AppRoutes.createQuiz,
      builder: (context, state) {
        final courseId = state.extra as String?;
        if (courseId == null) {
          return const HomeScreen();
        }
        return CreateQuizScreen(courseId: courseId);
      },
    ),
    GoRoute(
      path: AppRoutes.lectures,
      builder: (context, state) {
        final courseId = state.extra as String?;
        if (courseId == null) {
          return const HomeScreen();
        }
        return LectureScreen(courseId: courseId);
      },
    ),
    GoRoute(
      path: AppRoutes.video,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return VideoPlayerScreen(youtubeLink: extra['youtubeLink'] as String, title: extra['title'] as String);
      },
    ),
    GoRoute(
      path: AppRoutes.students,
      builder: (context, state) {
        final course = state.extra as Course?;
        if (course == null) {
          return const HomeScreen();
        }
        return EnrolledStudentsScreen(course: course);
      },
    ),
  ],
);
