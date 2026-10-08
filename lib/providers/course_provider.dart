// ==========================================
// FILE: lib/providers/course_provider.dart (Tahap 12)
// ==========================================
import 'package:flutter/material.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository repository;

  CourseState(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  final Set<String> favorites = {};

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // PERUBAHAN: Sekarang Provider mengambil data dari Repository!
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }

  List<Course> get favoriteCoursesData {
    return courses.where((course) => favorites.contains(course.code)).toList();
  }
}
