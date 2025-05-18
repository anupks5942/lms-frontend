import 'dart:async';
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
  bool _isCreatedLoading = false;
  List<Course> _allCourses = [];
  List<Course> _myCourses = [];
  List<Course> _createdCourses = [];
  String _errorMessage = '';
  String _selectedCategory = 'All';
  String _searchQuery = '';
  Timer? _debounceTimer;

  bool get isAllLoading => _isAllLoading;
  bool get isMyLoading => _isMyLoading;
  bool get isCreatedLoading => _isCreatedLoading;
  List<Course> get allCourses => _allCourses;
  List<Course> get myCourses => _myCourses;
  List<Course> get createdCourses => _createdCourses;
  String get errorMessage => _errorMessage;
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<String> categories = [
    'Technology',
    'Science & Math',
    'Business',
    'Arts & Humanities',
    'Health & Lifestyle',
    'Education',
    'Language',
    'Other',
  ];

  Future<void> fetchCourses({bool isRefresh = false}) async {
    if (isRefresh) {
      _searchQuery = '';
      _selectedCategory = 'All'; 
    }
    _errorMessage = '';
    _isAllLoading = true;
    notifyListeners();

    final response = await _courseService.fetchCourses(
      category: _selectedCategory != 'All' ? _selectedCategory : null,
      searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
    );

    response.match((err) => _errorMessage = err, (courses) => _allCourses = courses);

    _isAllLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    if (category.isNotEmpty && (categories.contains(category) || category == 'All')) {
      _selectedCategory = category;
      fetchCourses();
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchCourses();
    });
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _selectedCategory = 'All'; 
    fetchCourses();
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

  Future<void> getCreatedCourses(BuildContext context) async {
    _errorMessage = '';
    _isCreatedLoading = true;
    notifyListeners();

    final user = context.read<AuthProvider>().getUser();
    final response = await _courseService.getCreatedCourses(user?.id ?? '');

    response.match((err) => _errorMessage = err, (courses) => _createdCourses = courses);
    _isCreatedLoading = false;
    notifyListeners();
  }

  Future<Either<String, String>> enrollIntoCourse(String courseId) async {
    _errorMessage = '';
    notifyListeners();

    final response = await _courseService.enrollIntoCourse(courseId);

    return response;
  }

  Future<Either<String, String>> createCourse(Map<String, dynamic> courseData) async {
    _errorMessage = '';
    notifyListeners();

    final response = await _courseService.createCourse(courseData);

    return response;
  }
}
