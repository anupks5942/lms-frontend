import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/constants/api_routes.dart';
import '../../../core/constants/app_storage_key.dart';
import '../../../core/services/dio_service.dart';
import '../../../core/services/logger.dart';
import '../../../core/services/storage_manager.dart';
import '../models/user.dart';

class AuthService {
  final Dio _dio = DioService.dio;

  Future<Either<String, AuthModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiRoutes.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final authModel = AuthModel.fromJson(response.data);

        final user = jsonEncode(response.data['user']);

        StorageManager.setStringValue(key: AppStorageKey.user, value: user);
        StorageManager.setStringValue(
          key: AppStorageKey.token,
          value: authModel.token,
        );

        return Right(authModel);
      } else {
        final message = DioService.getErrorMessageFromStatusCode(
          response.statusCode,
        );
        return Left(message);
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while login: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Login error: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, String>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiRoutes.register,
        data: {'name': name, 'email': email, 'password': password},
      );

      if (response.statusCode == 201) {
        return Right(response.data['message'] ?? 'Registration successful');
      } else {
        final message = DioService.getErrorMessageFromStatusCode(
          response.statusCode,
        );
        return Left(message);
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while login: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Login error: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, bool>> logout() async {
    try {
      await StorageManager.removeValue(AppStorageKey.token);
      await StorageManager.removeValue(AppStorageKey.user);
      return const Right(true);
    } catch (e) {
      return const Left('Failed to clear authentication data');
    }
  }
}
