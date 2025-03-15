import 'dart:developer';

import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class AuthResult {
  AuthResult({required this.success, this.message});
  final bool success;
  final String? message;
}

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();

  String? _token;
  Map<String, dynamic>? _user;
  bool _isLogging = false;
  bool _showLogin = true;

  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  bool get isLogging => _isLogging;
  bool get showLogin => _showLogin;

  void setLogging(bool value) {
    _isLogging = value;
    notifyListeners();
  }

  void setShowLogin(bool value) {
    _showLogin = value;
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    final authData = await _authService.getAuthData();
    if (authData != null) {
      _token = authData['token'];
      _user = authData['user'];
      return true;
    }
    return false;
  }

  Future<AuthResult> login(String email, String password) async {
    setLogging(true);
    try {
      final data = await _authService.login(email, password);
      _token = data['token'];
      _user = data['user'];
      await _authService.saveAuthData(_token!, _user!);
      notifyListeners();
      return AuthResult(success: true, message: 'Logged in successfully');
    } catch (e) {
      log('Error during login: $e');
      return AuthResult(success: false, message: e.toString());
    } finally {
      setLogging(false);
    }
  }

  Future<AuthResult> register(String name, String email, String password) async {
    setLogging(true);
    try {
      final data = await _authService.register(name, email, password);
      _token = data['token'];
      _user = data['user'];
      await _authService.saveAuthData(_token!, _user!);
      notifyListeners();
      return AuthResult(success: true, message: 'Registered successfully');
    } catch (e) {
      log('Error during registration: $e');
      return AuthResult(success: false, message: e.toString());
    } finally {
      setLogging(false);
    }
  }

  Future<AuthResult> logout() async {
    try {
      await _authService.clearAuthData();
      _token = null;
      _user = null;
      notifyListeners();
      return AuthResult(success: true, message: 'Logged out successfully');
    }  catch (e) {
      return AuthResult(success: false, message: e.toString());
    }
  }
}
