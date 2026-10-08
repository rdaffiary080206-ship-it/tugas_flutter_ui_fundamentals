// ==========================================
// FILE BARU: lib/screens/favorites_screen.dart
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import 'course_detail_screen.dart';

const String studentId = '2415051020';
const String studentName = 'I Putu Anggara Rega Daffiary';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau data favorit secara realtime
    final favoritData = context.watch<CourseState>().favoriteCoursesData;

    return Scaffold(
      appBar: AppBar(title: const Text('Materi Favorit')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.pink[50],
            child: const Text(
              '$studentId - $studentName',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.pink),
            ),
          ),
          Expanded(
            child: favoritData.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.heart_broken, size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada materi favorit.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoritData.length,
                    itemBuilder: (context, index) {
                      final course = favoritData[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.pink,
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            course.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${course.code} • ${course.credits} SKS',
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // Menghapus dari favorit
                              context.read<CourseState>().toggleFavorite(
                                course.code,
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CourseDetailPage(course: course),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
