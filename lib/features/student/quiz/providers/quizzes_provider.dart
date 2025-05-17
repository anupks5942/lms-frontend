import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lms1/features/student/quiz/models/quiz.dart';
import '../services/quizzes_service.dart';

class QuizProvider with ChangeNotifier {
  final QuizService _quizService = QuizService();

  bool _isLoading = false;
  List<Quiz> _quizzes = [];
  List<String?> _selectedAnswers = [];
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  List<Quiz> get quizzes => _quizzes;
  List<String?> get selectedAnswers => _selectedAnswers;
  String get errorMessage => _errorMessage;

  void initializeAnswers(int questionCount) {
    _selectedAnswers = questionCount > 0 ? List.filled(questionCount, null) : [];
    notifyListeners();
  }

  void updateAnswer(int index, String? answer) {
    _selectedAnswers[index] = answer;
    notifyListeners();
  }

  Future<void> getAllQuizzes(String courseId) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    final response = await _quizService.getAllQuizzes(courseId);

    response.match((err) => _errorMessage = err, (quizzes) => _quizzes = quizzes);

    _isLoading = false;
    notifyListeners();
  }

  Future<Either<String, String>> submitQuiz(String quizId, List<String?> answers) async {
    _errorMessage = '';
    notifyListeners();

    final response = await _quizService.submitQuiz(quizId, answers);

    response.match((err) => _errorMessage = err, (_) => null);

    return response;
  }

  bool hasUserAttemptedQuiz(Quiz quiz, String userId) {
    return quiz.attemptedBy.contains(userId);
  }
}
