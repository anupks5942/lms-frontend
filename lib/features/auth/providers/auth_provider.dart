import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _showLogin = true;
  String _errorMessage = '';
  AuthModel? _authModel;

  bool get showLogin => _showLogin;
  String get errorMessage => _errorMessage;
  AuthModel? get authModel => _authModel;

  void toggleLoginView() {
    _showLogin = !_showLogin;
    notifyListeners();
  }

  Future<Either<String, AuthModel>> login({required String email, required String password}) async {
    _errorMessage = '';
    notifyListeners();

    final result = await _authService.login(email: email, password: password);

    result.match((err) => _errorMessage = err, (model) => _authModel = model);

    notifyListeners();

    return result;
  }

  Future<Either<String, AuthModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _errorMessage = '';
    notifyListeners();

    final result = await _authService.register(name: name, email: email, password: password);

    result.match((err) => _errorMessage = err, (model) => _authModel = model);

    notifyListeners();

    return result;
  }

  Future<void> logout() async {
    _errorMessage = '';
    notifyListeners();

    final result = await _authService.logout();

    result.match(
      (err) {
        _errorMessage = err;
      },
      (_) {
        _authModel = null;
      },
    );
  }
}
