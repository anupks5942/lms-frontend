import 'package:flutter/cupertino.dart';
import '../services/quizzes_service.dart';

class QuizProvider with ChangeNotifier {
   final QuizService _quizService = QuizService();

bool _isLoading = false;
 List _quizzes = []; 
 String _errorMessage = '';

bool get isLoading => _isLoading; 
List get quizzes => _quizzes;
 String get errorMessage => _errorMessage;

Future getAllQuizzes(String courseId) async {
   _errorMessage = '';
    _isLoading = true; notifyListeners();

final response = await _quizService.getAllQuizzes(courseId);

response.match(
  (err) => _errorMessage = err,
  (quizzes) => _quizzes = quizzes,
);

_isLoading = false;
notifyListeners();

} }