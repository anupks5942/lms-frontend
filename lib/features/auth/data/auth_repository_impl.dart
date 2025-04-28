import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:fpdart/fpdart.dart';
import '../../../core/failures/value_failure.dart';
import '../../../core/router/api_routes.dart';
import '../../../core/services/local_data_service.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final _baseUrl = ApiRoutes.baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    final token = await LocalDataService.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<Either<AuthFailure, User>> login({required String email, required String password}) async {
    final url = Uri.parse(ApiRoutes.login);
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String;
        final userMap = data['user'] as Map<String, dynamic>;
        final user = User.fromJson(userMap, token: token);

        await _saveAuthData(token, userMap);

        return right(user);
      } else {
        final res = jsonDecode(response.body) as Map<String, dynamic>;
        final error = res['message'] is String
            ? res['message']
            : res['message']?.toString() ?? 'Login failed';
        return left(AuthFailure(error));
      }
    } catch (e, stackTrace) {
      log('Login Error: $e', stackTrace: stackTrace);
      return left(AuthFailure('Something went wrong. Try again.'));
    }
  }

  @override
  Future<Either<AuthFailure, User>> register({required String name, required String email, required String password}) async {
    final url = Uri.parse(ApiRoutes.register);
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['token'] as String;
        final userMap = data['user'] as Map<String, dynamic>;
        final user = User.fromJson(userMap, token: token);

        await _saveAuthData(token, userMap);

        return right(user);
      } else {
        final res = jsonDecode(response.body) as Map<String, dynamic>;
        final error = res['message'] is String
            ? res['message']
            : res['message']?.toString() ?? 'Registration failed';
        return left(AuthFailure(error));
      }
    } catch (e, stackTrace) {
      log('Register Error: $e', stackTrace: stackTrace);
      return left(AuthFailure('Something went wrong. Try again.'));
    }
  }

  Future<Option<User>> getStoredUser() async {
    try {
      final token = await LocalDataService.getString('token');
      final userJson = await LocalDataService.getString('user');

      if (token != null && userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = User.fromJson(userMap, token: token);
        return some(user);
      } else {
        return none();
      }
    } catch (e, s) {
      log('Get Stored User Error: $e', stackTrace: s);
      return none();
    }
  }

  Future<void> _saveAuthData(String token, Map<String, dynamic> userMap) async {
    try {
      await Future.wait([
        LocalDataService.storeString('token', token),
        LocalDataService.storeString('user', jsonEncode(userMap)),
      ]);
    } catch (e, s) {
      log('Save Auth Data Error: $e', stackTrace: s);
    }
  }
}