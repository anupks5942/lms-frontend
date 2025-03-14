import 'dart:developer';
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../../utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/global/custom_textfield.dart';
import 'controller/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthProvider authProvider;

  void _logIn() async {
    if (_formKey.currentState!.validate()) {
      final res = await context.read<AuthProvider>().login(_emailController.text.trim(), _passwordController.text.trim());
      if (res == true) {
        if (mounted) {
          Navigation.pushReplacementCupertino(context, const HomePage());
        }
      } else {
        log('Login failed');
      }
    }
  }

  @override
  void initState() {
    authProvider = context.read<AuthProvider>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeader(),
      SizedBox(height: 4.h),
      _buildLoginForm(),
      SizedBox(height: 3.h),
      _buildLoginButton(),
      SizedBox(height: 3.h),
      _buildSignUpOption(),
    ],
  );

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Welcome Back!', style: Theme.of(context).textTheme.titleLarge),
      SizedBox(height: 1.h),
      Text('Sign in to continue your learning journey', style: Theme.of(context).textTheme.titleSmall),
    ],
  );

  Widget _buildLoginForm() => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _emailController,
          hintText: 'Enter your email',
          prefixIcon: Icons.email_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter your email';
            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        Text('Password', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          prefixIcon: Icons.lock,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Please enter your password';
            if (value.length < 6) return 'Password must be at least 6 characters';
            return null;
          },
          onFieldSubmitted: (value) => _logIn(),
        ),
      ],
    ),
  );

  Widget _buildLoginButton() => Consumer<AuthProvider>(
    builder:
        (context, provider, child) => SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _logIn,
            // style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w))),
            child:
                provider.isLogging
                    ? const CircularProgressIndicator()
                    : Text('Login'),
          ),
        ),
  );

  Widget _buildSignUpOption() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text("Don't have an account?"),
      TextButton(
        onPressed: () => authProvider.setShowLogin(false),
        child: Text('Sign Up'),
      ),
    ],
  );
}
