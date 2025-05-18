import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import '../../../core/services/validation_service.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // final _emailController = TextEditingController(text: 'anupsoni404@gmail.com');
  // final _passwordController = TextEditingController(text: 'Anup123');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AuthProvider authProvider;

  void _logIn() async {
    if (_formKey.currentState!.validate()) {
      context.showDialog(message: 'Logging in...');

      final result = await context.read<AuthProvider>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) context.hideDialog();

      result.match(
        (err) {
          context.showCustomSnackBar(message: err, type: SnackBarType.error);
        },
        (_) {
          final name = authProvider.authModel?.user.name ?? '';
          context.showCustomSnackBar(message: 'Welcome back, $name', type: SnackBarType.success);
          context.go(AppRoutes.home);
        },
      );
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
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
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
    ),
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
          validator: ValidationService.emailValidation,
        ),
        SizedBox(height: 2.h),
        Text('Password', style: Theme.of(context).textTheme.labelLarge),
        SizedBox(height: 1.h),
        CustomTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          prefixIcon: Icons.lock,
          isPassword: true,
          validator: (value) => ValidationService.passwordValidation(value),
          onFieldSubmitted: (value) => _logIn(),
        ),
      ],
    ),
  );

  Widget _buildLoginButton() {
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder:
          (context, provider, child) => SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _logIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                textStyle: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              child: const Text('Login'),
            ),
          ),
    );
  }

  Widget _buildSignUpOption() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account?"),
      TextButton(onPressed: () => authProvider.toggleLoginView(), child: const Text('Sign up')),
    ],
  );
}
