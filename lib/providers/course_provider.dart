// ==========================================
// FILE: lib/providers/course_provider.dart (Tahap 11)
// ==========================================
import 'package:flutter/material.dart';

import '../models/course.dart';

// Anggap saja fungsi loadStudentData() (sementara) pindah ke sini
// Di tahap sebelumnya Anda disuruh buat course_service dan course_repository,
// pastikan file tersebut sudah ada. Jika belum, kita satukan sementara di sini untuk Tahap 11.
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class CourseState extends ChangeNotifier {
  // --- STATE ASYNC ---
  List<Course> courses = [];
  bool isLoading = false;
  String? error;

  // --- STATE FAVORIT ---
  final Set<String> favorites = {};

  // Fungsi baru untuk Load Data secara Async (Tahap 11)
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners(); // Memberitahu UI untuk menampilkan loading

    try {
      // (Ini seharusnya memanggil repository, tapi untuk sekarang kita ambil langsung)
      final jsonString = await rootBundle.loadString(
        'assets/data/student_data.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> coursesJson = data['courses'];
      courses = coursesJson.map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      error = e.toString(); // Menangkap error
    } finally {
      isLoading = false; // Mematikan loading
      notifyListeners(); // Memberitahu UI bahwa proses selesai
    }
  }

  // Fungsi Favorit yang lama tetap ada
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
