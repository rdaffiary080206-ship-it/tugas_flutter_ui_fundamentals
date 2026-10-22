// ==========================================
// FILE: lib/screens/home_screen.dart (Tahap 2)
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:convert'; // <-- Tambahan untuk JSON

import 'package:http/http.dart' as http; // <-- Tambahan HTTP GET

import '../providers/course_provider.dart';

const String studentId = '2415051020';
const String studentName = 'I Putu Anggara Rega Daffiary';

// URL API Latihan
const String apiUrl = 'https://course-api-pearl.vercel.app/courses';

// Fungsi Fetch sementara untuk Tahap 2
Future<List<dynamic>> fetchCourses() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    return jsonDecode(response.body) as List<dynamic>;
  }
  throw Exception('HTTP ${response.statusCode}');
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau state dari Provider
    final provider = context.watch<CourseState>();
    final totalCourses = provider.courses.length;
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
          ? const Center(
              child: CircularProgressIndicator(),
            ) // Menangani state Loading
          : error != null
          ? Center(
              child: Text(
                'Terjadi Kesalahan: $error',
                style: const TextStyle(color: Colors.red),
              ),
            ) // Menangani state Error
          : SingleChildScrollView(
              // Menangani state Success (Data siap)
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

                  // 2. Row untuk summary Courses dan Favorites
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
                  // TOMBOL PENGUJIAN TAHAP 2
                  // ==========================================
                  ElevatedButton.icon(
                    icon: const Icon(Icons.cloud_download),
                    label: const Text('Test GET API (Tahap 2)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () async {
                      try {
                        final courses = await fetchCourses();
                        debugPrint(
                          'Tahap 2 Sukses: Berhasil mengambil ${courses.length} course dari API',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Tahap 2 Sukses: Ditemukan ${courses.length} course!',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        debugPrint('Tahap 2 Error: $e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // 3. List of topics based on mockup
                  _buildTopicCard('Git & GitHub', 'done', Colors.green),
                  const SizedBox(height: 12),
                  _buildTopicCard('Dart Fundamentals', 'done', Colors.green),
                  const SizedBox(height: 12),
                  _buildTopicCard('State Management', 'active', Colors.green),
                ],
              ),
            ),
    );
  }

  // Fungsi bantuan
  Widget _buildTopicCard(String title, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            status,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
