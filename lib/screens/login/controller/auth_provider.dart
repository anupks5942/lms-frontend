import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lms1/network/constants/app_constants.dart';
import 'package:lms1/utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_page.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLogging = false;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLogging => _isLogging;

  void setLogging(bool value) {
    _isLogging = value;
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userData = prefs.getString('user');
    if (_token != null && userData != null) {
      _user = jsonDecode(userData);
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    String baseUrl = AppConstants.baseUrl;
    final url = Uri.parse('$baseUrl/auth/login');

    setLogging(true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _user = data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user', jsonEncode(_user));

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e, s) {
      log("Login error: $e $s");
      return false;
    } finally {
      setLogging(false);
    }
  }

  Future<void> logout(BuildContext context) async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    if (context.mounted) {
      Navigation.pushReplacementCupertino(context, const LoginPage());
    }
    notifyListeners();
  }
}
