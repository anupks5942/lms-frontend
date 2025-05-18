import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOption { system, light, dark }

class ThemePreferences {
  static const String _themeKey = 'theme_option';

  Future<void> setTheme(ThemeOption theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.toString());
  }

  Future<ThemeOption> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);
    return themeString != null
        ? ThemeOption.values.firstWhere(
          (e) => e.toString() == themeString,
      orElse: () => ThemeOption.system,
    )
        : ThemeOption.system;
  }
}