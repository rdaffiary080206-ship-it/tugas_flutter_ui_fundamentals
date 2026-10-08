import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';
import 'models/course.dart';

// IDENTITAS MAHASISWA
const String studentId = '2415051020';
const String studentName = 'I Putu Anggara Rega Daffiary';

Future<List<Course>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );
  final Map<String, dynamic> data = jsonDecode(jsonString);
  final List<dynamic> coursesJson = data['courses'];
  return coursesJson.map((json) => Course.fromJson(json)).toList();
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CourseState(),
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
      title: 'Course Explorer',
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
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    // Memuat data saat aplikasi pertama kali jalan dan memasukkannya ke Provider
    _initData();
  }

  Future<void> _initData() async {
    final courses = await loadStudentData();
    if (mounted) {
      context.read<CourseState>().setCourses(courses);
      setState(() {
        _isDataLoaded = true;
      });
    }
  }

  final List<Widget> _pages = [
    const HomePage(), // Telah dirombak di Tahap 9
    const CoursesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
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
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        } else {
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

// ==========================================
// 1. HOME PAGE (Tahap 9 - Menampilkan Data Gabungan)
// ==========================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau getter dari Provider
    final favoritData = context.watch<CourseState>().favoriteCoursesData;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$studentId - $studentName',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Mata Kuliah Favorit Anda:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: favoritData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              context.read<CourseState>().toggleFavorite(
                                course.code,
                              );
                            },
                          ),
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

// ==========================================
// 2. COURSES PAGE
// ==========================================
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Karena data sudah ada di Provider, kita tidak butuh FutureBuilder lagi!
    final courses = context.watch<CourseState>().allCourses;
    final jumlahFavorit = context.watch<CourseState>().favorites.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Materi (Model)')),
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
          Expanded(
            child: courses.isEmpty
                ? const Center(child: Text('Tidak ada data courses.'))
                : LayoutBuilder(
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
                  ),
          ),
        ],
      ),
    );
  }
}

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

// ==========================================
// 3. PROFILE PAGE
// ==========================================
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final ValueNotifier<int> _klikCounter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil (ValueNotifier)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              '$studentName',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'NIM: $studentId',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Divider(height: 40, thickness: 1),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                children: [
                  const Text(
                    'Eksperimen ValueNotifier (Tahap 4)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<int>(
                    valueListenable: _klikCounter,
                    builder: (context, value, child) {
                      return Text(
                        'Tombol ditekan: $value kali',
                        style: const TextStyle(fontSize: 20),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _klikCounter.value++;
                    },
                    child: const Text('Tambah Klik (Tanpa setState)'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Berikan Ulasan Anda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const FeedbackFormWidget(),
          ],
        ),
      ),
    );
  }
}

class FeedbackFormWidget extends StatefulWidget {
  const FeedbackFormWidget({super.key});
  @override
  State<FeedbackFormWidget> createState() => _FeedbackFormWidgetState();
}

class _FeedbackFormWidgetState extends State<FeedbackFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Komentar Singkat',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.comment),
            ),
            maxLines: 3,
            validator: (value) => value == null || value.trim().length < 5
                ? 'Minimal 5 karakter!'
                : null,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        await Future.delayed(const Duration(seconds: 2));
                        if (context.mounted) {
                          setState(() => _isLoading = false);
                          _commentController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feedback terkirim!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Kirim Feedback'),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// COURSE DETAIL PAGE
// ==========================================
class CourseDetailPage extends StatefulWidget {
  final Course course;
  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kursus')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            const Divider(height: 30, thickness: 1),
            Text(
              widget.course.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Kode: ${widget.course.code}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'SKS: ${widget.course.credits}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 24),
            OutlinedButton.icon(
              icon: Icon(
                _showDetails ? Icons.visibility_off : Icons.visibility,
              ),
              label: Text(
                _showDetails ? 'Sembunyikan Info' : 'Tampilkan Info Tambahan',
              ),
              onPressed: () {
                setState(() {
                  _showDetails = !_showDetails;
                });
              },
            ),

            if (_showDetails)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Ini info tambahan yang dikontrol oleh Local State (setState).',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),

            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.favorite),
                    label: const Text('Favorite'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      context.read<CourseState>().toggleFavorite(
                        widget.course.code,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Status Favorite Diubah!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
