import 'package:flutter/cupertino.dart';
import '../models/course.dart';
import '../services/home_service.dart';

class HomeProvider with ChangeNotifier {
  final HomeService _homeService = HomeService();

  bool _isLoading = false;
  List<Course> _courses = [];
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  List<Course> get courses => _courses;
  String get errorMessage => _errorMessage;

  void reset() {
    _courses = [];
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getAllCourses() async {
    _errorMessage = '';
    _isLoading = true;
    notifyListeners();

    final response = await _homeService.getAllCourses();

    response.match(
      (err) => _errorMessage = err,
      (courses) => _courses = courses,
    );

    _isLoading = false;
    notifyListeners();
  }
}
