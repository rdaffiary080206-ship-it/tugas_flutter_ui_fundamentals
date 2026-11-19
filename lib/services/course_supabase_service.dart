import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase.from('courses').select().order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Pengguna belum login.');
    }

    final payload = {...course.toJson(), 'owner_id': user.id};

    try {
      final row = await supabase
          .from('courses')
          .insert(payload)
          .select()
          .single();

      return Course.fromJson(row);
    } on PostgrestException catch (e) {
      throw Exception('Ditolak RLS (${e.code}): ${e.message}');
    }
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    try {
      final rows = await supabase
          .from('courses')
          .update(course.toJson())
          .eq('id', id)
          .select();

      if ((rows as List).isEmpty) {
        throw Exception(
          'Akses ditolak RLS: Anda hanya dapat mengubah course milik Anda sendiri.',
        );
      }
    } on PostgrestException catch (e) {
      throw Exception('Ditolak RLS (${e.code}): ${e.message}');
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    try {
      final rows = await supabase
          .from('courses')
          .delete()
          .eq('id', id)
          .select();

      if ((rows as List).isEmpty) {
        throw Exception(
          'Akses ditolak RLS: Anda hanya dapat menghapus course milik Anda sendiri.',
        );
      }
    } on PostgrestException catch (e) {
      throw Exception('Ditolak RLS (${e.code}): ${e.message}');
    }
  }
}
