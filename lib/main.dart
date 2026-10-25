// ==========================================
// FILE: lib/main.dart (Tahap 10 - Full Code)
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_api_service.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';

import 'screens/home_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';

Future<void> main() async {
  // 1. Wajib ditambahkan agar Supabase bisa diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================
  // 2. INISIALISASI SUPABASE
  // ==========================================
  // Hapus tulisan TEMPEL_... dan masukkan URL serta Anon Key Anda
  await Supabase.initialize(
    url: 'https://dpiztwltfyrfefyrjwfq.supabase.co',
    anonKey: 'sb_publishable_RY9l0nxNGL9H8r_Yi7WkoQ_WTYvFs81',
  );

  // 3. Perakitan Repository Pattern (Tahap 9)
  final CourseDataSource dataSource = CourseSupabaseService();
  final CourseRepository repository = CourseRepository(dataSource);

  // 4. Jalankan Aplikasi dengan Provider
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final provider = CourseState(repository);
        provider.loadCourses(); // Muat data pertama kali
        return provider;
      },
      child: const CourseExplorerApp(),
    ),
  );
}

// 5. Widget Utama Aplikasi
class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Data Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
