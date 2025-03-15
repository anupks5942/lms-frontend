import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

class ToastService {
  factory ToastService() => _instance;
  ToastService._internal();
  static final ToastService _instance = ToastService._internal();

  static const _defaultDuration = Duration(seconds: 3);
  static const _defaultPosition = DelightSnackbarPosition.top;

  void showSuccess(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      iconColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  void showError(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.error_outline,
      iconColor: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  void showInfo(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.info_outline,
      iconColor: Theme.of(context).colorScheme.onSurface,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }

  void showWarning(BuildContext context, String message) {
    _showToast(
      context,
      message: message,
      icon: Icons.warning_amber_outlined,
      iconColor: Theme.of(context).colorScheme.onSecondary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
  }

  void showCustom({
    required BuildContext context,
    required String message,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Duration? duration,
    DelightSnackbarPosition? position,
    bool autoDismiss = true,
  }) {
    _showToast(
      context,
      message: message,
      icon: icon,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      duration: duration,
      position: position,
      autoDismiss: autoDismiss,
    );
  }

  void _showToast(
    BuildContext context, {
    required String message,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Duration? duration,
    DelightSnackbarPosition? position,
    bool autoDismiss = true,
  }) {
    final theme = Theme.of(context);
    DelightToastBar(
      position: position ?? _defaultPosition,
      autoDismiss: autoDismiss,
      snackbarDuration: duration ?? _defaultDuration,
      builder:
          (context) => ToastCard(
            leading: icon != null ? Icon(icon, color: iconColor ?? theme.colorScheme.onSurface) : null,
            title: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(color: iconColor ?? Theme.of(context).colorScheme.onSurface),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          ),
    ).show(context);
  }
}
