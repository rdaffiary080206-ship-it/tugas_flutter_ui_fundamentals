// ==========================================
// FILE: lib/services/course_service.dart (Tahap 4)
// ==========================================
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  // Pindahkan URL API ke sini
  final String apiUrl = 'https://course-api-pearl.vercel.app/courses';

  Future<List<Course>> loadCourses() async {
    try {
      // Menembak ke REST API internet
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Mengubah JSON mentah menjadi List objek Course
        return data
            .map((json) => Course.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal memuat data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error saat menghubungi server: $e');
    }
  }
}
