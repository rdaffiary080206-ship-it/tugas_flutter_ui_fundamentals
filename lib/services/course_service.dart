import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  final String apiUrl = 'https://course-api-pearl.vercel.app/courses';

  Future<List<Course>> loadCourses() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
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

  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Course.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    throw Exception('Gagal membuat course');
  }

  // TAHAP 7: Tambahan Fungsi Update (PUT)
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memperbarui course');
    }
  }
}
