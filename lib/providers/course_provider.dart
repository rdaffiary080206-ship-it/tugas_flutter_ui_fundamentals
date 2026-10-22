// ==========================================
// FILE: lib/providers/course_provider.dart (Tahap 6)
// ==========================================
import 'package:flutter/material.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseState extends ChangeNotifier {
  final CourseRepository repository;
  CourseState(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  bool isSaving = false; // Flag untuk Loading Simpan (Langkah 37)
  String? error;
  final Set<String> favorites = {};

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // TAHAP 6: Proses Simpan Course Baru
  Future<bool> addCourse(Course course) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await repository.createCourse(course);
      await loadCourses(); // Langkah 40: Refresh list dengan fetch ulang
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isSaving = false;
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
