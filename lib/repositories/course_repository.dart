// ==========================================
// FILE: lib/repositories/course_repository.dart
// ==========================================
import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;
  CourseRepository(this.service);

  Future<List<Course>> getCourses() async {
    return await service.loadCourses();
  }

  // TAHAP 6: Meneruskan data ke Service
  Future<Course> createCourse(Course course) async {
    return await service.createCourse(course);
  }
}
