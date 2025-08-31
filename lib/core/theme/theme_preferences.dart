import 'package:lms1/core/services/storage_manager.dart';

enum ThemeOption { system, light, dark }

class ThemePreferences {
  static const String _themeKey = 'theme_option';

  void setTheme(ThemeOption theme) {
    StorageManager.setStringValue(key: _themeKey, value: theme.toString());
  }

  ThemeOption getTheme() {
    final themeString = StorageManager.getStringValue(_themeKey);
    return themeString != null
        ? ThemeOption.values.firstWhere(
          (e) => e.toString() == themeString,
          orElse: () => ThemeOption.system,
        )
        : ThemeOption.system;
  }
}
