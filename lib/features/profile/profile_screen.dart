import 'package:flutter/material.dart';
import 'package:lms1/features/profile/logout_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_selection_dialog.dart';
import '../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final user = context.read<AuthProvider>().getUser();

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15.w,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 20.w, color: colorScheme.primary),
            ),
            SizedBox(height: 2.h),
            Text(
              user?.name ?? '',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(user?.email ?? '', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            SizedBox(height: 0.5.h),
            Text(user?.role.toUpperCase() ?? '', style: textTheme.bodyMedium),
            SizedBox(height: 2.h),
            const Divider(),
            ListTile(
              leading: Icon(Icons.color_lens, color: colorScheme.onSurface),
              title: const Text('Theme'),
              subtitle: Text(
                StringExtension(context.watch<ThemeProvider>().themeOption.toString().split('.').last).capitalize(),
              ),
              onTap: () => showDialog(context: context, builder: (context) => const ThemeSelectionDialog()),
            ),
            const Divider(),
            const LogoutButton(),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
