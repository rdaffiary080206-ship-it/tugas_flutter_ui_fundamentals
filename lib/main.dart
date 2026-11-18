import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'screens/login_page.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dpiztwltfyrfefyrjwfq.supabase.co',
    anonKey: 'sb_publishable_RY9l0nxNGL9H8r_Yi7WkoQ_WTYvFs81',
  );

  final CourseDataSource dataSource = CourseSupabaseService();
  final CourseRepository repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (context) {
        final provider = CourseState(repository);
        provider.loadCourses();
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
      title: 'Course Explorer v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
