import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        onPressed: () => context.read<AuthProvider>().logout(context),
        child: const Icon(Icons.logout),
      ),
    );
}
