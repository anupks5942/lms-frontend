import 'package:flutter/material.dart';
import 'screens/auth/controller/auth_provider.dart';
import 'screens/auth/login_or_register.dart';
import 'screens/home/home_page.dart';
import 'utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => AuthProvider())],
    builder:
        (context, pro) => Sizer(
          builder:
              (BuildContext context, Orientation orientation, ScreenType screenType) => MaterialApp(
                title: 'EduLearn',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                home: FutureBuilder(
                  future: context.read<AuthProvider>().isLoggedIn(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData && snapshot.data!) {
                      return const HomePage();
                    } else {
                      return const LoginOrRegister();
                    }
                  },
                ),
              ),
        ),
  );
}
