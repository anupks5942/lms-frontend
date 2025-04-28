import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import '../../core/router/api_routes.dart';
import '../../core/services/local_data_service.dart';
import 'course.dart';

class HomeProvider with ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  List<Course> _courses = [];
  List<Course> get courses => _courses;

  Future<Map<String, String>> _getHeaders() async {
    final token = await LocalDataService.getString('token');
    return {'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'};
  }

  Future<void> getAllCourses() async {
    try {
      final response = await http.get(Uri.parse(ApiRoutes.courses), headers: await _getHeaders());

      if (response.statusCode == 200) {
        final res = json.decode(response.body) as Map<String, dynamic>;
        log(res.toString());
        final List<dynamic> courses = res['courses'] ?? [];
        _courses = courses.map((item) => Course.fromJson(item)).toList();
      }
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _courses = [];
    _isLoading = false;
    notifyListeners();
  }
}
