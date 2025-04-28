import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/app_theme.dart';
import 'package:provider/provider.dart';
import 'features/home/home_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        title: 'LMS App',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
      ),
    );
  }
}
