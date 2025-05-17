import 'package:dio/dio.dart'; 
import 'package:fpdart/fpdart.dart';
 import '../../../../core/constants/api_routes.dart';
  import '../../../../core/services/dio_service.dart';
   import '../../../../core/services/logger.dart';
    import '../models/quizzes.dart';

class QuizService { final Dio _dio = DioService.dio;

 Future<Either<String, List>> getAllQuizzes(String courseId) async { 
  try { if (courseId.isEmpty) { return const Left('Course ID cannot be empty'); }

  final response = await _dio.get('${ApiRoutes.quizzes}$courseId');

  if (response.statusCode == 200) {
    final quizData = response.data['quizzes'] as List<dynamic>?;
    if (quizData == null) {
      return const Left('No quizzes found');
    }
    final quizzes = quizData
        .map((item) => Quiz.fromJson(item as Map<String, dynamic>))
        .toList();
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

} }