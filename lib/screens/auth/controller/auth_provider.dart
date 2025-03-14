import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../network/constants/app_constants.dart';
import '../../../utils/navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_or_register.dart';

class AuthProvider with ChangeNotifier {
  // setters
  String? _token;
  Map<String, dynamic>? _user;
  bool _isLogging = false;
  bool _showLogin = true;

  // getter
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLogging => _isLogging;
  bool get showLogin => _showLogin;

  // setter functions
  void setLogging(bool value) {
    _isLogging = value;
    notifyListeners();
  }

  void setShowLogin(bool value) {
    _showLogin = value;
    notifyListeners();
  }

  // main functions
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
    var baseUrl = AppConstants.baseUrl;
    final url = Uri.parse('$baseUrl/auth/login');

    setLogging(true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
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
      log('Login error: $e $s');
      return false;
    } finally {
      setLogging(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    var baseUrl = AppConstants.baseUrl;
    final url = Uri.parse('$baseUrl/auth/register'); // Adjust endpoint as needed

    setLogging(true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      log('Registration response: ${response.body}');
      log('Registration response status code: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
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
      log('Registration error: $e $s');
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
      Navigation.pushReplacementCupertino(context, const LoginOrRegister());
    }
    notifyListeners();
  }
}
