import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'core/router/app_router.dart';
import 'features/auth/view_model/auth_provider.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => Sizer(
      builder:
          (context, orientation, screenType) => ProviderScope(
            child: MaterialApp.router(
              routerConfig: router,
              title: 'EduLearn',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
            ),
          ),
    )
  ;
}
