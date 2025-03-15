import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_routes.dart';

class AuthService {
  final _baseUrl = ApiRoutes.baseUrl;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl${ApiRoutes.login}');
    try {
      final response = await http
          .post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'email': email, 'password': password}))
          .timeout(const Duration(seconds: 10));
      return response.body as Map<String, dynamic>;
    } catch (e) {
      log('Network error during login: $e');
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final url = Uri.parse('$_baseUrl${ApiRoutes.register}');
    try {
      final response = await http
          .post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({'email': email, 'password': password, 'name': name}))
          .timeout(const Duration(seconds: 10));
      return response.body as Map<String, dynamic>;
    } catch (e) {
      log('Network error during registration: $e');
      throw Exception(e);
    }
  }

  Future<void> saveAuthData(String token, Map<String, dynamic> user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([prefs.setString('token', token), prefs.setString('user', jsonEncode(user))]);
    } catch (e, stackTrace) {
      log('Error saving auth data: $e', stackTrace: stackTrace);
      throw Exception(e);
    }
  }

  Future<void> clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await Future.wait([prefs.remove('token'), prefs.remove('user')]);
    } catch (e, stackTrace) {
      log('Error clearing auth data: $e', stackTrace: stackTrace);
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>?> getAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userData = prefs.getString('user');
      if (token != null && userData != null) {
        return {'token': token, 'user': jsonDecode(userData) as Map<String, dynamic>};
      }
      return null;
    } catch (e, stackTrace) {
      log('Error retrieving auth data: $e', stackTrace: stackTrace);
      return null;
    }
  }
}
