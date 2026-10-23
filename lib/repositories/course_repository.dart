import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;
  CourseRepository(this.service);

  Future<List<Course>> getCourses() async => await service.loadCourses();

  Future<Course> createCourse(Course course) async =>
      await service.createCourse(course);

  Future<void> updateCourse(int id, Course course) async =>
      await service.updateCourse(id, course);

  // TAHAP 8: Meneruskan Delete ke Service
  Future<void> deleteCourse(int id) async {
    await service.deleteCourse(id);
  }
}
