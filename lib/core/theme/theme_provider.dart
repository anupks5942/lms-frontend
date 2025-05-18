import 'package:flutter/material.dart';
import 'theme_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeOption _themeOption = ThemeOption.system;
  ThemePreferences themePreferences = ThemePreferences();

  ThemeOption get themeOption => _themeOption;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    _themeOption = await themePreferences.getTheme();
    notifyListeners();
  }

  Future<void> setTheme(ThemeOption theme) async {
    _themeOption = theme;
    await themePreferences.setTheme(theme);
    notifyListeners();
  }

  ThemeMode get themeMode {
    switch (_themeOption) {
      case ThemeOption.system:
        return ThemeMode.system;
      case ThemeOption.light:
        return ThemeMode.light;
      case ThemeOption.dark:
        return ThemeMode.dark;
    }
  }
}