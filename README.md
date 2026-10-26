# Course Data Manager (Explorer v2)

## Deskripsi Aplikasi

Aplikasi manajemen data mata kuliah (Course) yang mendukung operasi CRUD (Create, Read, Update, Delete) secara penuh. Aplikasi ini merupakan pengembangan dari Course Explorer v2 yang kini telah dilengkapi dengan integrasi RESTful API dan database persisten.

## Cara Menjalankan

1. Pastikan Flutter SDK telah terinstal dengan benar.
2. Buka terminal di direktori proyek dan jalankan `flutter pub get` untuk mengunduh dependencies (seperti `http`, `provider`, dan `supabase_flutter`).
3. Jalankan aplikasi menggunakan emulator atau physical device dengan perintah `flutter run`.

## Arsitektur

Aplikasi ini menggunakan Arsitektur Berlapis (Layered Architecture) berbasis **Repository Pattern** dengan State Management **Provider**. Alur aliran datanya dipisahkan secara bersih:
`UI (Screen)` ➔ `State (Provider)` ➔ `Repository` ➔ `Service/DataSource`.

## Backend

Backend menggunakan **Supabase (PostgreSQL)** yang terintegrasi secara langsung menggunakan SDK `supabase_flutter`. Akses data dilakukan tanpa mengekspos `service_role` key pada client.
