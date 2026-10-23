// ==========================================
// FILE: lib/repositories/course_repository.dart (Tahap 9)
// ==========================================
import '../models/course.dart';
import '../services/course_data_source.dart';

class CourseRepository {
  // Hanya menerima class apa saja yang mematuhi kontrak CourseDataSource
  final CourseDataSource dataSource;

  CourseRepository(this.dataSource);

  Future<List<Course>> getCourses() async => await dataSource.getCourses();
  Future<Course> createCourse(Course course) async =>
      await dataSource.createCourse(course);
  Future<void> updateCourse(int id, Course course) async =>
      await dataSource.updateCourse(id, course);
  Future<void> deleteCourse(int id) async => await dataSource.deleteCourse(id);
}
