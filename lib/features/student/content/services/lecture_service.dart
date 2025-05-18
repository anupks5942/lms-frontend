import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/services/logger.dart';
import '../models/lecture_model.dart';

class LectureService {
  final Dio _dio = DioService.dio;

  Future<Either<String, List<Lecture>>> getLectures(String courseId) async {
    try {
      final response = await _dio.get('${ApiRoutes.courses}/$courseId${ApiRoutes.lectures}');

      Logger.debug("Response: $response");

      if (response.statusCode == 200) {
        final lectureData = response.data['lectures'] as List<dynamic>;
        final lectures = lectureData.map((item) => Lecture.fromJson(item as Map<String, dynamic>)).toList();
        return Right(lectures);
      } else {
        return Left(response.statusMessage ?? 'Failed fetching lectures');
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while fetching lectures: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Catch error while fetching lectures: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }
}
