import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/constants/api_routes.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/services/logger.dart';
import '../models/quiz.dart';

class QuizService {
  final Dio _dio = DioService.dio;

  Future<Either<String, List<Quiz>>> getAllQuizzes(String courseId) async {
    try {
      final response = await _dio.get('${ApiRoutes.quizzes}${ApiRoutes.quizzesOfCourse}$courseId');

      Logger.debug("Response: $response");

      if (response.statusCode == 200) {
        final quizData = response.data['quizzes'] as List<dynamic>;
        final quizzes = quizData.map((item) => Quiz.fromJson(item as Map<String, dynamic>)).toList();
        return Right(quizzes);
      } else {
        return Left(response.statusMessage ?? 'Failed fetching quizzes');
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while fetching quizzes: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Catch error while fetching quizzes: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }

  Future<Either<String, String>> submitQuiz(String quizId, List<String?> payload) async {
    try {
      final response = await _dio.post(
        '${ApiRoutes.quizzes}$quizId${ApiRoutes.submitQuiz}',
        data: {'answers': payload},
      );

      Logger.debug("Response: $response");

      if (response.statusCode == 201) {
        return Right(response.data['score'].toString());
      } else {
        return Left(response.data['message'] ?? response.statusMessage ?? 'Failed to submit quiz');
      }
    } on DioException catch (e, s) {
      Logger.debug("DioException while submitting quiz: $e\n\n$s");
      return Left(DioService.handleDioError(e));
    } catch (e, s) {
      Logger.debug("Catch error while submitting quiz: $e\n\n$s");
      return Left('Unexpected error: $e');
    }
  }
}
