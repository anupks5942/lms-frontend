import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/router/app_routes.dart';
import '../auth/controller/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await context.read<AuthProvider>().logout();
        if (result.success && context.mounted) {
          context.go(AppRoutes.login);
        } else {
          
        }
      },
      child: const Icon(Icons.logout),
    ),
  );
}
