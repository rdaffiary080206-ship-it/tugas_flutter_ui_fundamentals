// ==========================================
// FILE BARU: lib/repositories/course_repository.dart
// ==========================================
import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  // Menerima Service lewat constructor (Dependency Injection)
  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    // Repository memanggil method dari Service
    return service.loadCourses();
  }
}
