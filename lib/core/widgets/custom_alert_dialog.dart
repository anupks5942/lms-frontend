import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String buttonText,
  required VoidCallback onButtonPressed,
  required int seconds,
}) {
  int secondsRemaining = seconds;
  bool isButtonEnabled = false;
  Timer? timer;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder:
        (context) => StatefulBuilder(
          builder: (context, setState) {
            if (secondsRemaining > 0 && timer == null) {
              timer = Timer.periodic(const Duration(seconds: 1), (t) {
                if (context.mounted) {
                  setState(() {
                    secondsRemaining--;
                    if (secondsRemaining == 0) {
                      isButtonEnabled = true;
                      t.cancel();
                    }
                  });
                }
              });
            }

            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: [
                  TextButton(
                    onPressed:
                        isButtonEnabled
                            ? () {
                              context.pop();
                              onButtonPressed();
                            }
                            : null,
                    child: Text(
                      "$buttonText${secondsRemaining > 0 ? " ($secondsRemaining sec)" : ''}",
                      style: TextStyle(color: isButtonEnabled ? Theme.of(context).primaryColor : Colors.grey),
                    ),
                  ),
                ],
                elevation: 4,
              ),
            );
          },
        ),
  ).then((_) => timer?.cancel()); // Clean up timer when dialog is dismissed
}
