import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../utils/toast_service.dart';
import 'controller/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _toastService = ToastService(); // Instance of ToastService

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final result = await context.read<AuthProvider>().register(
        _nameController.text.trim(),
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
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildHeader(),
      SizedBox(height: 4.h),
      _buildRegisterForm(),
      SizedBox(height: 3.h),
      _buildRegisterButton(),
      SizedBox(height: 3.h),
      _buildLoginOption(),
    ],
  );

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Create Account', style: Theme.of(context).textTheme.titleLarge),
      SizedBox(height: 1.h),
      Text('Join us to start your learning journey', style: Theme.of(context).textTheme.titleSmall),
    ],
  );

  Widget _buildRegisterForm() => Form(
    key: _formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _nameController,
          hintText: 'Enter your name',
          prefixIcon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            if (value.length < 3) {
              return 'Please enter a valid name';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
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
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),
        Text('Confirm Password', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _confirmPasswordController,
          hintText: 'Confirm your password',
          prefixIcon: Icons.verified_user,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          onFieldSubmitted: (value) => _register(),
        ),
      ],
    ),
  );

  Widget _buildRegisterButton() => Consumer<AuthProvider>(
    builder:
        (context, provider, child) => SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: provider.isLogging ? null : _register,
            child: provider.isLogging ? const CircularProgressIndicator(color: Colors.white) : const Text('Register'),
          ),
        ),
  );

  Widget _buildLoginOption() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('Already have an account?'),
      TextButton(onPressed: () => context.read<AuthProvider>().setShowLogin(true), child: const Text('Login')),
    ],
  );
}
