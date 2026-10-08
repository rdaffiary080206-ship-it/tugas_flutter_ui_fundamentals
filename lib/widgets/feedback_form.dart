// ==========================================
// FILE BARU: lib/widgets/feedback_form.dart
// ==========================================
import 'package:flutter/material.dart';

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
