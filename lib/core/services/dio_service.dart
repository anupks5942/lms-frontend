import 'package:dio/dio.dart';
import '../constants/api_routes.dart';
import '../constants/app_storage_key.dart';
import 'storage_manager.dart';

class DioService {
  static final Dio _dio = Dio(
      BaseOptions(
        baseUrl: ApiRoutes.baseUrl,
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = StorageManager.getStringValue(AppStorageKey.token);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

  static Dio get dio => _dio;

  static String handleDioError(DioException e) {
    if (e.response != null) {
      return getErrorMessageFromStatusCode(e.response?.statusCode);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Please check your internet.';
      case DioExceptionType.badCertificate:
        return 'Security certificate error. Please contact support.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  static String getErrorMessageFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Unauthorized. Please check your email or password.';
      case 403:
        return 'You don’t have permission to perform this action.';
      case 404:
        return 'Requested service not found.';
      case 409:
        return 'Conflict detected. This action cannot be completed.';
      case 422:
        return 'Validation failed. Please check the entered information.';
      case 429:
        return 'Too many requests. Please try again shortly.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service is currently unavailable. Please try again soon.';
      default:
        return 'Something went wrong. Error code: $statusCode';
    }
  }
}
