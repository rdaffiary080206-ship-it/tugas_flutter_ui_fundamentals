// ==========================================
// FILE: lib/main.dart (Tahap 13)
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'services/course_service.dart';
import 'repositories/course_repository.dart';

// Import layar dari folder screens
import 'screens/home_screen.dart';
import 'screens/courses_screen.dart';
import 'screens/favorites_screen.dart'; // <-- Halaman baru ditambahkan
import 'screens/profile_screen.dart';

void main() {
  // 1. Buat Service
  final courseService = CourseService();
  // 2. Buat Repository dan masukkan Service ke dalamnya
  final courseRepository = CourseRepository(courseService);

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        // 3. Buat Provider dan masukkan Repository ke dalamnya
        final provider = CourseState(courseRepository);
        provider.loadCourses(); // Jalankan load data
        return provider;
      },
      child: const CourseExplorerApp(),
    ),
  );
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int currentIndex = 0;

  // DAFTAR HALAMAN: Ditambahkan FavoritesPage di urutan ke-3
  final List<Widget> _pages = [
    const HomePage(),
    const CoursesPage(),
    const FavoritesPage(), // <-- Halaman Favorit
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // TAMPILAN UNTUK LAYAR KECIL (MOBILE) - MENGGUNAKAN BOTTOM NAVIGATION BAR
        if (constraints.maxWidth < 840) {
          return Scaffold(
            body: _pages[currentIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) =>
                  setState(() => currentIndex = index),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                NavigationDestination(
                  icon: Icon(Icons.school),
                  label: 'Courses',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ), // <-- Menu Favorit
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        }
        // TAMPILAN UNTUK LAYAR LEBAR (TABLET/DESKTOP) - MENGGUNAKAN NAVIGATION RAIL
        else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) =>
                      setState(() => currentIndex = index),
                  labelType: NavigationRailLabelType.all,
                  selectedIconTheme: const IconThemeData(
                    color: Colors.blueAccent,
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ), // <-- Menu Favorit
                    NavigationRailDestination(
                      icon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _pages[currentIndex]),
              ],
            ),
          );
        }
      },
    );
  }
}
