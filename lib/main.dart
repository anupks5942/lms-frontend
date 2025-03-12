import 'package:flutter/material.dart';
import 'package:lms1/screens/home/home_page.dart';
import 'package:lms1/screens/login/controller/auth_provider.dart';
import 'package:lms1/screens/login/login_page.dart';
import 'package:lms1/utils/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthProvider())],
      builder: (context, pro) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: FutureBuilder(
            future: context.read<AuthProvider>().isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.hasData && snapshot.data!) {
                return const HomePage();
              } else{
                return const LoginPage();

              }
            },
          ),
        );
      },
    );
  }
}
