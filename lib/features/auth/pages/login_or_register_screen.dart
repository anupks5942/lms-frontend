import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.school, size: 8.w),
                    SizedBox(width: 4.w),
                    Text('EduCore', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 3.h),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.showLogin ? const LoginScreen() : const RegisterScreen();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
