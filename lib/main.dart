import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'core/app_theme.dart';
import 'core/constants/app_router.dart';
import 'core/services/logger.dart';
import 'core/services/storage_manager.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/home_provider.dart';

void main() async {
  FlutterError.onError = (details) {
    Logger.error('FlutterError: ${details.exception}\nStack: ${details.stack}');
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await StorageManager.initializeSharedPreferences();
      runApp(
        const MyApp(),
      );
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
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp.router(
            routerConfig: appRouter,
            title: 'EduLearn',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            debugShowCheckedModeBanner: false,
          );
        }
      ),
    );
  }
}
