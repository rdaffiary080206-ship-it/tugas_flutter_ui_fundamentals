// ==========================================
// FILE BARU: lib/services/course_service.dart
// ==========================================
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

class CourseService {
  Future<List<Course>> loadCourses() async {
    // Membaca file JSON dari asset
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final List<dynamic> coursesJson = data['courses'];

    // Mengubah JSON mentah menjadi List objek Course
    return coursesJson
        .map((json) => Course.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
