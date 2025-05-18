import 'package:flutter/material.dart';
import '../models/lecture_model.dart';
import '../services/lecture_service.dart';

class LectureProvider with ChangeNotifier {
  final LectureService _lectureService = LectureService();

  bool _isLoading = false;
  List<Lecture> _lectures = [];
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  List<Lecture> get lectures => _lectures;
  String get errorMessage => _errorMessage;

  Future<void> getLectures(String courseId) async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    final response = await _lectureService.getLectures(courseId);

    response.match(
          (err) => _errorMessage = err,
          (lectures) => _lectures = lectures,
    );

    _isLoading = false;
    notifyListeners();
  }
}