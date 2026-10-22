// ==========================================
// FILE BARU: lib/screens/add_course_screen.dart (Tahap 6)
// ==========================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();
  String _status = 'planned';

  @override
  Widget build(BuildContext context) {
    // Memantau flag isSaving agar form bisa dimatikan saat loading (Langkah 37)
    final isSaving = context.watch<CourseState>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Kode Course'),
                validator: (value) =>
                    value!.isEmpty ? 'Tidak boleh kosong' : null, // Langkah 35
                enabled: !isSaving,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Course'),
                validator: (value) =>
                    value!.isEmpty ? 'Tidak boleh kosong' : null,
                enabled: !isSaving,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _creditsController,
                decoration: const InputDecoration(labelText: 'SKS (Credits)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Tidak boleh kosong';
                  if (int.tryParse(value) == null)
                    return 'Harus berupa angka'; // Langkah 35
                  return null;
                },
                enabled: !isSaving,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'done', child: Text('Done')),
                ],
                onChanged: isSaving
                    ? null
                    : (value) => setState(() => _status = value!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isSaving
                    ? null // Nonaktifkan tombol saat loading (Langkah 37)
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final newCourse = Course(
                            code: _codeController.text,
                            title: _titleController.text,
                            credits: int.parse(_creditsController.text),
                            status: _status,
                          );

                          final provider = context.read<CourseState>();
                          final success = await provider.addCourse(newCourse);

                          // Langkah 39: Validasi context sebelum SnackBar/Pop
                          if (!context.mounted) return;

                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Berhasil menambah materi!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context); // Tutup halaman
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal: ${provider.error}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ) // Indikator Loading
                    : const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
