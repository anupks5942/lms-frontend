import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/services/logger.dart';
import '../models/course.dart';

class CourseService {
  final Dio _dio = DioService.dio;

  Future<Either<String, List<Course>>> getAllCourses() async {
    try {
      final response = await _dio.get(ApiRoutes.courses);

      if (response.statusCode == 200) {
        final courseData = response.data['courses'] as List<dynamic>;
        final courses = courseData.map((item) => Course.fromJson(item)).toList();

        return Right(courses);
      } else {
        return Left(response.statusMessage ?? 'Failed fetching courses');
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while fetching courses: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Catch error while fetching courses: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, List<Course>>> getEnrolledCourses(String id) async {
    try {
      final response = await _dio.get('${ApiRoutes.courses}${ApiRoutes.enrolledCourses}$id');

      if (response.statusCode == 200) {
        final courseData = response.data['courses'] as List<dynamic>;
        final courses = courseData.map((item) => Course.fromJson(item)).toList();

        return Right(courses);
      } else {
        return Left(response.statusMessage ?? 'Failed fetching courses');
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while fetching courses: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Catch error while fetching courses: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, String>> enrollIntoCourse(String courseId) async {
    try {
      final response = await _dio.put('${ApiRoutes.courses}/$courseId/${ApiRoutes.enroll}');

      if (response.statusCode == 200) {
        return Right(response.data['message']);
      } else {
        return Left(response.data['message'] ?? 'Failed enrolling into course');
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while enrolling into course: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Catch error while enrolling into course: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }
}
