import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onOkPressed;

  const SuccessDialog({super.key, required this.message, this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: colorScheme.surfaceContainer,
      contentPadding: EdgeInsets.all(4.w),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10.w,
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.check_circle_outline,
              size: 10.w,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onOkPressed,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            textStyle: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
