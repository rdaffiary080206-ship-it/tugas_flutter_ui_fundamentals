// ==========================================
// FILE: lib/providers/course_provider.dart (Tahap 9)
// ==========================================
import 'package:flutter/material.dart';

import '../models/course.dart';

class CourseState extends ChangeNotifier {
  // 1. Data mentah seluruh course
  List<Course> allCourses = [];

  final Set<String> favorites = {};

  // 2. Fungsi untuk memasukkan data dari JSON ke dalam Provider
  void setCourses(List<Course> courses) {
    allCourses = courses;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    notifyListeners();
  }

  // 3. GETTER: Mengambil daftar course yang HANYA difavoritkan
  List<Course> get favoriteCoursesData {
    return allCourses
        .where((course) => favorites.contains(course.code))
        .toList();
  }
}
