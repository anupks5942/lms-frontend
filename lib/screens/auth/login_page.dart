import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../utils/toast_service.dart';
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
  final _toastService = ToastService();

  Future<void> _logIn() async {
    if (_formKey.currentState!.validate()) {
      final result = await context.read<AuthProvider>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (!mounted) return;

      if (result.success) {
        _toastService.showSuccess(context, result.message!);
        context.go(AppRoutes.home);
      } else {
        _toastService.showError(context, result.message!);
      }
    }
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
        SizedBox(height: 2.h),
        _buildSignUpOption(),
      ],
    );

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Welcome Back!', style: Theme.of(context).textTheme.titleLarge),
      SizedBox(height: 1.h),
      Text('Sign in to continue your learning journey',
          style: Theme.of(context).textTheme.titleSmall),
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
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(value)) {
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
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          onFieldSubmitted: (value) => _logIn(),
        ),
      ],
    ),
  );

  Widget _buildLoginButton() => Consumer<AuthProvider>(
    builder: (context, provider, child) => SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: provider.isLogging ? null : _logIn,
        child: provider.isLogging
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Login'),
      ),
    ),
  );

  Widget _buildSignUpOption() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account?"),
      TextButton(
        onPressed: () => context.read<AuthProvider>().setShowLogin(false),
        child: const Text('Sign Up'),
      ),
    ],
  );
}