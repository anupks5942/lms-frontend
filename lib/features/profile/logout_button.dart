import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lms1/core/constants/app_routes.dart';
import 'package:lms1/core/widgets/custom_snackbar.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();

    if (!context.mounted) return;

    if (authProvider.errorMessage.isNotEmpty) {
      context.showCustomSnackBar(message: authProvider.errorMessage, type: SnackBarType.error);
    } else if (authProvider.authModel == null) {
      context.showCustomSnackBar(message: 'Logout successful', type: SnackBarType.success);
      context.go(AppRoutes.login);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(onPressed: dialogContext.pop, child: const Text('Cancel')),
            TextButton(
              onPressed: () async {
                dialogContext.pop();
                await _handleLogout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(Icons.logout, color: theme.colorScheme.error),
      title: const Text('Logout'),
      onTap: () => _showLogoutDialog(context),
    );
  }
}
