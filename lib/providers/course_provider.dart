// ==========================================
// FILE BARU: lib/providers/course_provider.dart (Tahap 5)
// ==========================================
import 'package:flutter/material.dart';

// Class ini memisahkan Logic (State) dari Tampilan (UI)
class CourseState extends ChangeNotifier {
  // Data State: Kumpulan kode course yang di-favorit-kan
  final Set<String> favorites = {};

  // Method untuk mengubah state
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id); // Jika sudah ada, hapus
    } else {
      favorites.add(id); // Jika belum ada, tambahkan
    }

    // SANGAT PENTING: Memberitahu UI bahwa ada data yang berubah
    notifyListeners();
  }
}
