import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import '../services/quizzes_service.dart';
import '../models/quiz.dart';

class QuestionFormData {
  final TextEditingController questionController;
  final List<TextEditingController> optionControllers;
  String? correctAnswer;

  QuestionFormData()
    : questionController = TextEditingController(),
      optionControllers = [TextEditingController(), TextEditingController()];

  void dispose() {
    questionController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
  }
}

class QuizProvider with ChangeNotifier {
  final QuizService _quizService = QuizService();

  bool _isLoading = false;
  List<Quiz> _quizzes = [];
  List<String?> _selectedAnswers = [];
  String _errorMessage = '';
  String _quizTitle = '';
  List<QuestionFormData> _quizQuestions = [QuestionFormData()];

  bool get isLoading => _isLoading;
  List<Quiz> get quizzes => _quizzes;
  List<String?> get selectedAnswers => _selectedAnswers;
  String get errorMessage => _errorMessage;
  String get quizTitle => _quizTitle;
  List<QuestionFormData> get quizQuestions => _quizQuestions;

  void initializeQuizCreation() {
    _quizTitle = '';
    _quizQuestions = [QuestionFormData()];
    notifyListeners();
  }

  void resetQuizCreation() {
    for (var question in _quizQuestions) {
      question.dispose();
    }
    _quizTitle = '';
    _quizQuestions = [];
    notifyListeners();
  }

  void updateQuizTitle(String title) {
    _quizTitle = title;
    notifyListeners();
  }

  void addQuestion() {
    _quizQuestions.add(QuestionFormData());
    notifyListeners();
  }

  void removeQuestion(int index) {
    if (index >= 0 && index < _quizQuestions.length) {
      _quizQuestions[index].dispose();
      _quizQuestions.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuestionText(int questionIndex, String text) {
    if (questionIndex >= 0 && questionIndex < _quizQuestions.length) {
      _quizQuestions[questionIndex].questionController.text = text;
      notifyListeners();
    }
  }

  void addOption(int questionIndex) {
    if (questionIndex >= 0 && questionIndex < _quizQuestions.length) {
      _quizQuestions[questionIndex].optionControllers.add(
        TextEditingController(),
      );
      notifyListeners();
    }
  }

  void removeOption(int questionIndex, int optionIndex) {
    if (questionIndex >= 0 && questionIndex < _quizQuestions.length) {
      final question = _quizQuestions[questionIndex];
      if (optionIndex >= 0 && optionIndex < question.optionControllers.length) {
        if (question.optionControllers[optionIndex].text.trim() ==
            question.correctAnswer) {
          question.correctAnswer = null;
        }
        question.optionControllers[optionIndex].dispose();
        question.optionControllers.removeAt(optionIndex);
        notifyListeners();
      }
    }
  }

  void updateOption(int questionIndex, int optionIndex, String text) {
    if (questionIndex >= 0 && questionIndex < _quizQuestions.length) {
      final question = _quizQuestions[questionIndex];
      if (optionIndex >= 0 && optionIndex < question.optionControllers.length) {
        question.optionControllers[optionIndex].text = text;
        if (question.correctAnswer ==
                question.optionControllers[optionIndex].text &&
            text.isEmpty) {
          question.correctAnswer = null;
        }
        notifyListeners();
      }
    }
  }

  void updateCorrectAnswer(int questionIndex, String? value) {
    if (questionIndex >= 0 && questionIndex < _quizQuestions.length) {
      _quizQuestions[questionIndex].correctAnswer = value;
      notifyListeners();
    }
  }

  bool validateQuiz() {
    if (_quizQuestions.isEmpty) return false;
    for (var question in _quizQuestions) {
      if (question.optionControllers.length < 2) return false;
      if (question.optionControllers.any((c) => c.text.trim().isEmpty)) {
        return false;
      }
      if (question.correctAnswer == null || question.correctAnswer!.isEmpty) {
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> getQuizData() {
    return {
      'title': _quizTitle.trim(),
      'questions':
          _quizQuestions.map((q) {
            return {
              'questionText': q.questionController.text.trim(),
              'type': 'multiple-choice',
              'options': q.optionControllers.map((c) => c.text.trim()).toList(),
              'correctAnswer': q.correctAnswer,
            };
          }).toList(),
    };
  }

  void initializeAnswers(int questionCount) {
    _selectedAnswers =
        questionCount > 0 ? List.filled(questionCount, null) : [];
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

    response.match(
      (err) => _errorMessage = err,
      (quizzes) => _quizzes = quizzes,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<Either<String, String>> submitQuiz(
    String quizId,
    List<String?> answers,
  ) async {
    _errorMessage = '';
    notifyListeners();

    final response = await _quizService.submitQuiz(quizId, answers);

    response.match((err) => _errorMessage = err, (_) => null);

    return response;
  }

  Future<Either<String, Unit>> createQuiz(
    String courseId,
    Map<String, dynamic> quizData,
  ) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    final response = await _quizService.createQuiz(courseId, quizData);

    response.match((err) => _errorMessage = err, (_) => null);

    _isLoading = false;
    notifyListeners();

    return response;
  }

  bool hasUserAttemptedQuiz(Quiz quiz, String userId) {
    return quiz.attemptedBy.contains(userId);
  }
}
