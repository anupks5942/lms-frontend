
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'login_screen.dart';
import 'register_screen.dart';

final showLoginProvider = StateProvider<bool>((ref) => true);

class LoginOrRegisterScreen extends ConsumerWidget {
  const LoginOrRegisterScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showLogin = ref.watch(showLoginProvider);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.school, size: 32),
                  const SizedBox(width: 16),
                  Text('EduLearn', style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 24),
              showLogin ? const LoginScreen() : const RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
