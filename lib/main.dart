import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lms1/core/theme/theme_provider.dart';
import 'package:lms1/features/student/content/providers/lecture_provider.dart';
import 'package:lms1/features/student/course/providers/course_provider.dart';
import 'package:lms1/features/student/quiz/providers/quizzes_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_router.dart';
import 'core/services/logger.dart';
import 'core/services/storage_manager.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/home_provider.dart';

// display > headline > title > body > label

void main() async {
  FlutterError.onError = (details) {
    Logger.error('FlutterError: ${details.exception}\nStack: ${details.stack}');
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await StorageManager.initializeSharedPreferences();
      runApp(const MyApp());
    },
    (error, stackTrace) {
      Logger.error('Uncaught Error: $error\nStack Trace: $stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => QuizProvider()),
        ChangeNotifierProvider(create: (context) => LectureProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return Sizer(
            builder: (context, orientation, deviceType) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: MaterialApp.router(
                  routerConfig: appRouter,
                  title: 'EduLearn',
                  themeMode: themeProvider.themeMode,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  debugShowCheckedModeBanner: false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
