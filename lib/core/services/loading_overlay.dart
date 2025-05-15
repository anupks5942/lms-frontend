import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomLoadingDialog {
  static bool _isDialogShowing = false;

  static void show(
    BuildContext context, {
    String? message,
    Color? backgroundColor,
    TextStyle? textStyle,
    Color? barrierColor,
  }) {
    if (_isDialogShowing) {
      return;
    }

    _isDialogShowing = true;

    final theme = Theme.of(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (BuildContext dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
                if (message != null && message.trim().isNotEmpty) ...[
                  SizedBox(width: 3.w),
                  Text(
                    message,
                    style: textStyle ?? theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    if (_isDialogShowing) {
      Navigator.of(context).pop();
      _isDialogShowing = false;
    }
  }
}

extension CustomLoadingDialogExtension on BuildContext {
  void showDialog({String? message, Color? backgroundColor, TextStyle? textStyle, Color? barrierColor}) {
    CustomLoadingDialog.show(
      this,
      message: message,
      backgroundColor: backgroundColor,
      textStyle: textStyle,
      barrierColor: barrierColor,
    );
  }

  void hideDialog() {
    CustomLoadingDialog.hide(this);
  }
}
