// ==========================================
// FILE: lib/screens/home_screen.dart (Tahap 7)
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../models/course.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart'; // <-- Import halaman edit (Tahap 7)

const String studentId = '2415051020';
const String studentName = 'I Putu Anggara Rega Daffiary';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau state dari Provider
    final provider = context.watch<CourseState>();
    final courses = provider.courses; // Ambil list course dari API
    final totalCourses = courses.length;
    final totalFavorites = provider.favorites.length;
    final isLoading = provider.isLoading;
    final error = provider.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Explorer v2',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(
              child: Text(
                'Terjadi Kesalahan: $error',
                style: const TextStyle(color: Colors.red),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Identitas Mahasiswa
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '$studentId\n$studentName',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Row untuk summary
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Courses',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$totalCourses',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Favorites',
                                style: TextStyle(color: Colors.blueGrey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$totalFavorites',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ==========================================
                  // 3. DAFTAR MATERI DINAMIS DARI API
                  // ==========================================
                  const Text(
                    'Daftar Materi:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (courses.isEmpty)
                    const Center(child: Text('Belum ada data course.'))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), // Agar tidak bentrok scroll
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        // TAHAP 7: Menambahkan context ke fungsi agar bisa pindah halaman
                        return _buildTopicCard(context, course);
                      },
                    ),
                ],
              ),
            ),

      // TAHAP 6: TOMBOL TAMBAH COURSE
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCourseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Fungsi bantuan untuk Card Materi (Tahap 7 - Ditambah tombol Edit)
  Widget _buildTopicCard(BuildContext context, Course course) {
    Color statusColor;
    if (course.status == 'done') {
      statusColor = Colors.green;
    } else if (course.status == 'active') {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
              // TOMBOL EDIT TAHAP 7
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.amber),
                onPressed: () {
                  // Navigasi ke halaman form edit dengan membawa data course yang dipilih
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCourseScreen(course: course),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kode: ${course.code}',
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                course.status.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'SKS: ${course.credits}',
            style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
