// ==========================================
// FILE: lib/services/course_supabase_service.dart (Tahap 12)
// ==========================================
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  // Mengambil instance klien Supabase yang sudah diinisialisasi di main.dart
  final _supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    // GET (Membaca semua data dan mengurutkannya berdasarkan ID)
    final response = await _supabase
        .from('courses')
        .select()
        .order('id', ascending: true);
    return response.map((json) => Course.fromJson(json)).toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    // POST (Menambah data baru)
    final Map<String, dynamic> data = course.toJson();
    data.remove(
      'id',
    ); // Hapus ID agar Supabase membuat ID otomatis secara berurutan

    final response = await _supabase
        .from('courses')
        .insert(data)
        .select()
        .single();
    return Course.fromJson(response);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    // PUT/PATCH (Memperbarui data berdasarkan ID)
    final Map<String, dynamic> data = course.toJson();
    data.remove('id');

    await _supabase.from('courses').update(data).eq('id', id);
  }

  @override
  Future<void> deleteCourse(int id) async {
    // DELETE (Menghapus data berdasarkan ID)
    await _supabase.from('courses').delete().eq('id', id);
  }
}
