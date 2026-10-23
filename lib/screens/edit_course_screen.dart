import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class EditCourseScreen extends StatefulWidget {
  final Course course; // Menerima data lama untuk pre-fill
  const EditCourseScreen({super.key, required this.course});

  @override
  State<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends State<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _titleController;
  late TextEditingController _creditsController;
  late String _status;

  @override
  void initState() {
    super.initState();
    // Mengisi form dengan data lama (Tahap 7)
    _codeController = TextEditingController(text: widget.course.code);
    _titleController = TextEditingController(text: widget.course.title);
    _creditsController = TextEditingController(
      text: widget.course.credits.toString(),
    );
    _status = widget.course.status;
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseState>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Kode Course'),
                readOnly: true, // Langkah 7: Code dibuat read-only
                enabled: false,
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
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
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
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isSaving
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate() &&
                            widget.course.id != null) {
                          final updatedCourse = Course(
                            code:
                                _codeController.text, // Tetap gunakan code lama
                            title: _titleController.text,
                            credits: int.parse(_creditsController.text),
                            status: _status,
                          );

                          final provider = context.read<CourseState>();
                          final success = await provider.editCourse(
                            widget.course.id!,
                            updatedCourse,
                          );

                          if (!context.mounted) return;
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Berhasil memperbarui materi!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
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
                      )
                    : const Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
