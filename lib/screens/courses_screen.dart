// ==========================================
// FILE: lib/screens/courses_screen.dart (Tahap 11)
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_detail_screen.dart';

const String studentId = '2415051020';
const String studentName = 'I Putu Anggara Rega Daffiary';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita baca semua state Async dari Provider
    final provider = context.watch<CourseState>();
    final courses = provider.courses;
    final isLoading = provider.isLoading;
    final error = provider.error;
    final jumlahFavorit = provider.favorites.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Materi (Async)')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '$studentId - $studentName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Favorit Tersimpan: $jumlahFavorit',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
          ),

          // PENANGANAN ASYNC STATE DI SINI
          Expanded(child: _buildBody(isLoading, error, courses)),
        ],
      ),
    );
  }

  // Fungsi bantuan diletakkan DI DALAM class CoursesPage
  Widget _buildBody(bool isLoading, String? error, List<Course> courses) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Text(
          'Terjadi Kesalahan: $error',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (courses.isEmpty) {
      return const Center(child: Text('Tidak ada data courses.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int jumlahKolom = constraints.maxWidth < 600
            ? 1
            : (constraints.maxWidth < 840 ? 2 : 3);
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: jumlahKolom,
            childAspectRatio: jumlahKolom == 1 ? 4.0 : 3.0,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return CourseCard(course: courses[index]);
          },
        );
      },
    );
  }
} // AKHIR DARI CLASS CoursesPage

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final isDone = course.status == 'done';
    final courseCode = course.code;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailPage(course: course),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.schedule,
                color: isDone ? Colors.green : Colors.orange,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$courseCode • ${course.credits} SKS',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              Consumer<CourseState>(
                builder: (context, courseState, child) {
                  final isFavorite = courseState.favorites.contains(courseCode);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.pink : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<CourseState>().toggleFavorite(courseCode);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
