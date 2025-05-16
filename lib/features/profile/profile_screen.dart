import 'package:flutter/material.dart';
import 'package:lms1/features/profile/logout_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = context.read<AuthProvider>().getUser();

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15.w,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 20.w, color: theme.colorScheme.primary),
            ),
            SizedBox(height: 2.h),
            Text(
              user?.name ?? '',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                overflow: TextOverflow.ellipsis
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              user?.email ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            SizedBox(height: 2.h),
            const Spacer(),
            const LogoutButton()
          ],
        ),
      ),
    );
  }
}
