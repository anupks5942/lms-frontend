import 'package:flutter/foundation.dart';

class Logger {
  static void info(String message) {
    _log('INFO', message, color: '\x1B[34m');
  }

  static void warning(String message) {
    _log('WARNING', message, color: '\x1B[33m');
  }

  static void error(String message) {
    _log('ERROR', message, color: '\x1B[31m');
  }

  static void success(String message) {
    _log('SUCCESS', message, color: '\x1B[32m');
  }

  static void debug(String message) {
    if (kDebugMode) {
      _log('DEBUG', message, color: '\x1B[35m');
    }
  }

  static void _log(String level, String message, {String color = ''}) {
    const resetColor = '\x1B[0m';
    final time = DateTime.now().toLocal();

    final trace = StackTrace.current.toString().split('\n');
    final callerLine = trace.length > 2 ? trace[2] : trace[0];
    final fileInfoMatch = RegExp(
      r'#2\s+.* \((.*?):(\d+):\d+\)',
    ).firstMatch(callerLine);

    var location = '';
    if (fileInfoMatch != null) {
      final filePath = fileInfoMatch.group(1);
      final lineNumber = fileInfoMatch.group(2);
      location = '$filePath:$lineNumber';
    }

    debugPrint('$color[$level] $time [$location]: $message$resetColor');
  }
}
