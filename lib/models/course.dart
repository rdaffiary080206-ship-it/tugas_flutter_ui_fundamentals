// ==========================================
// FILE: lib/models/course.dart (Tahap 3)
// ==========================================

class Course {
  final int? id; // Tambahan: id nullable untuk database
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned', // Nilai default jika status kosong
  });

  // Menerjemahkan dari JSON (Server) ke Objek Dart
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned', // Fallback default
    );
  }

  // Menerjemahkan dari Objek Dart ke JSON (Untuk dikirim ke Server)
  Map<String, dynamic> toJson() => {
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
  };
}
