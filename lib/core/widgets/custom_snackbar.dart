import 'package:flutter/material.dart';

enum SnackBarType { success, error, info, warning }

class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    if (message.trim().isEmpty) {
      return;
    }

    final theme = Theme.of(context);

    final defaultBackgroundColor = _getBackgroundColor(type, theme);
    final defaultTextColor = _getTextColor(type, theme);

    final snackBar = SnackBar(
      content: Semantics(
        label: '${type.name} notification: $message',
        child: Text(
          message,
          style:
              textStyle ??
              theme.textTheme.bodyMedium?.copyWith(color: defaultTextColor),
        ),
      ),
      backgroundColor: backgroundColor ?? defaultBackgroundColor,
      duration: duration,
      action:
          actionLabel != null && onActionPressed != null
              ? SnackBarAction(
                label: actionLabel,
                textColor: theme.colorScheme.onPrimaryContainer,
                onPressed: onActionPressed,
              )
              : null,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16.0),
      elevation: theme.snackBarTheme.elevation ?? 6.0,
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Color _getBackgroundColor(SnackBarType type, ThemeData theme) {
    switch (type) {
      case SnackBarType.success:
        return theme.colorScheme.primaryContainer;
      case SnackBarType.error:
        return theme.colorScheme.errorContainer;
      case SnackBarType.warning:
        return theme.colorScheme.tertiaryContainer;
      case SnackBarType.info:
        return theme.colorScheme.surfaceContainerHigh;
    }
  }

  static Color _getTextColor(SnackBarType type, ThemeData theme) {
    switch (type) {
      case SnackBarType.success:
        return theme.colorScheme.onPrimaryContainer;
      case SnackBarType.error:
        return theme.colorScheme.onErrorContainer;
      case SnackBarType.warning:
        return theme.colorScheme.onTertiaryContainer;
      case SnackBarType.info:
        return theme.colorScheme.onSurfaceVariant;
    }
  }
}

extension CustomSnackbarExtension on BuildContext {
  void showCustomSnackBar({
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    CustomSnackBar.show(
      this,
      message: message,
      type: type,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
      backgroundColor: backgroundColor,
      textStyle: textStyle,
    );
  }
}
