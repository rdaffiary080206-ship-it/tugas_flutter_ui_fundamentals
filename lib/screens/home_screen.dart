import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';
import 'add_course_screen.dart';
import 'edit_course_screen.dart';
import 'login_page.dart';

const String studentId = '2415051020';
const String studentName = 'I Putu Anggara Rega Daffiary';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseState>();
    final courses = provider.courses;
    final totalCourses = courses.length;
    final totalFavorites = provider.favorites.length;
    final isLoading = provider.isLoading;
    final error = provider.error;

    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = snap.data;
        if (snap.hasError || profile == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course Explorer v2'),
              actions: [
                IconButton(
                  tooltip: 'Logout',
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
            ),
            body: const Center(
              child: Text('Gagal memuat profil pengguna. Coba login ulang.'),
            ),
          );
        }

        final canManageCourses = profile.isInstructor || profile.isAdmin;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Course Explorer v2 (${profile.displayRole})',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
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
                      const SizedBox(height: 12),

                      // 2. Kartu Profil Pengguna & Role
                      Card(
                        elevation: 0,
                        color: Colors.indigo.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.indigo.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.indigo,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      profile.name.isEmpty ? '-' : profile.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: canManageCourses
                                          ? Colors.indigo
                                          : Colors.teal,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Role: ${profile.displayRole}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    size: 16,
                                    color: Colors.blueGrey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      profile.email,
                                      style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Info hak akses khusus Student
                      RoleGuard(
                        userRole: profile.role,
                        allowedRoles: const ['student'],
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal.shade200),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Colors.teal,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Mode Student (Read-Only): Anda dapat melihat materi dan menandai favorit. Pengelolaan course khusus Instructor.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 3. Row summary
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

                      // 4. Daftar Materi
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return _buildTopicCard(
                              context,
                              course,
                              profile,
                              provider,
                            );
                          },
                        ),
                    ],
                  ),
                ),
          // Tombol Tambah Course hanya tampil untuk Instructor / Admin
          floatingActionButton: canManageCourses
              ? FloatingActionButton(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCourseScreen(),
                      ),
                    );
                  },
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    Course course,
    UserProfile profile,
    CourseState provider,
  ) {
    Color statusColor;
    if (course.status == 'done') {
      statusColor = Colors.green;
    } else if (course.status == 'active') {
      statusColor = Colors.blue;
    } else {
      statusColor = Colors.grey;
    }

    final isFav = provider.favorites.contains(course.code);

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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Semua role bisa menandai favorit
                  IconButton(
                    tooltip: isFav ? 'Hapus Favorit' : 'Tandai Favorit',
                    icon: Icon(
                      isFav ? Icons.star : Icons.star_border,
                      color: isFav ? Colors.orange : Colors.grey,
                    ),
                    onPressed: () => provider.toggleFavorite(course.code),
                  ),
                  // Edit & Delete hanya tampil untuk Instructor / Admin
                  RoleGuard(
                    userRole: profile.role,
                    allowedRoles: const ['instructor', 'admin'],
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit Course',
                          icon: const Icon(Icons.edit, color: Colors.amber),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditCourseScreen(course: course),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          tooltip: 'Hapus Course',
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(context, course);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SKS: ${course.credits}',
                style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
              ),
              if (course.ownerId != null)
                Text(
                  course.ownerId == profile.id
                      ? 'Pemilik: Anda'
                      : 'Pemilik: Instructor lain',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: course.ownerId == profile.id
                        ? Colors.indigo
                        : Colors.orange.shade800,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Course'),
        content: Text('Yakin ingin menghapus ${course.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              if (course.id != null) {
                final provider = context.read<CourseState>();
                final success = await provider.removeCourse(
                  course.id!,
                  course.code,
                );

                if (!context.mounted) return;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Berhasil menghapus materi!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus: ${provider.error}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
