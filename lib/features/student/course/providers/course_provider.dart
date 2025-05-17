import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:lms1/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../services/course_service.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();

  bool _isAllLoading = false;
  bool _isMyLoading = false;
  bool _isEnrolling = false;
  List<Course> _allCourses = [];
  List<Course> _myCourses = [];
  String _errorMessage = '';

  bool get isAllLoading => _isAllLoading;
  bool get isMyLoading => _isMyLoading;
  bool get isEnrolling => _isEnrolling;
  List<Course> get allCourses => _allCourses;
  List<Course> get myCourses => _myCourses;
  String get errorMessage => _errorMessage;

  Future<void> getAllCourses() async {
    _errorMessage = '';
    _isAllLoading = true;
    notifyListeners();

    final response = await _courseService.getAllCourses();

    response.match((err) => _errorMessage = err, (courses) => _allCourses = courses);

    _isAllLoading = false;
    notifyListeners();
  }

  Future<void> getEnrolledCourses(BuildContext context) async {
    _errorMessage = '';
    _isMyLoading = true;
    notifyListeners();

    final user = context.read<AuthProvider>().getUser();

    final response = await _courseService.getEnrolledCourses(user?.id ?? '');

    response.match((err) => _errorMessage = err, (courses) => _myCourses = courses);

    _isMyLoading = false;
    notifyListeners();
  }

  Future<Either<String, String>> enrollIntoCourse(String courseId) async {
    _errorMessage = '';
    _isEnrolling = true;
    notifyListeners();

    final response = await _courseService.enrollIntoCourse(courseId);

    _isEnrolling = false;
    notifyListeners();

    return response;
  }
}
