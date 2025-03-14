import 'dart:developer';
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../../utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/global/custom_textfield.dart';
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
  late AuthProvider authProvider;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final res = await context.read<AuthProvider>().register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (res == true) {
        log('Registration successful');
        if (mounted) {
          Navigation.pushReplacementCupertino(context, const HomePage());
        }
      } else {
        log('Registration failed');
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
              if (value == null || value.isEmpty) return 'Please enter your name';
              if (value.length < 3) return 'Please enter a valid name';
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
              if (value == null || value.isEmpty) return 'Please confirm your password';
              if (value != _passwordController.text) return 'Passwords do not match';
              return null;
            },
            onFieldSubmitted: (value) => _register(),
          ),
        ],
      ),
    );

  Widget _buildRegisterButton() => Consumer<AuthProvider>(
      builder: (context, provider, child) => SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w))),
            child:
                provider.isLogging
                    ? const CircularProgressIndicator()
                    : Text('Register'),
          ),
        ),
    );

  Widget _buildLoginOption() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account?'),
        TextButton(
          onPressed: () => authProvider.setShowLogin(true),
          child: Text('Login'),
        ),
      ],
    );
}
