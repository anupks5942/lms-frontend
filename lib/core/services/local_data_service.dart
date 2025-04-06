import 'package:shared_preferences/shared_preferences.dart';

class LocalDataService {
  LocalDataService._();

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<void> storeString(String key, String value) async {
    final prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await _prefs;
    return prefs.getBool(key);
  }

  static Future<void> storeBool(String key, bool value) async {
    final prefs = await _prefs;
    prefs.setBool(key, value);
  }

  static Future<void> removeData(String key) async {
    final prefs = await _prefs;
    prefs.remove(key);
  }

  static Future<void> clearData()  async {
    final prefs = await _prefs;
    prefs.clear();
  }
}