import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'controller/auth_provider.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.school, size: 8.w),
                    SizedBox(width: 4.w),
                    Text('EduLearn', style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                SizedBox(height: 3.h),
                authProvider.showLogin ? const LoginPage() : const RegisterPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
