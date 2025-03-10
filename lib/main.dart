import 'package:flutter/material.dart';
import 'package:lms1/screens/home/home_page.dart';
import 'package:lms1/screens/login/controller/auth_provider.dart';
import 'package:lms1/screens/login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
          home: FutureBuilder(
            future: context.read<AuthProvider>().isLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return const HomePage();
              } else {
                return const LoginPage();
              }
            },
          ),
        );
      },
    );
  }
}
