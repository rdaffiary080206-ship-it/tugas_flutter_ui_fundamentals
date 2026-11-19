import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_keys.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background FCM message: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const String _webVapidKey =
      'BOkaIgkoGTCbka8DR9M3SojbtOfSWj1I5bGUHEjXW4ERrBUvcE930tloOkvqQ1kk-vgnvwqTFLOB_1eQvtNzRRE';

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? _fcmToken;

  String? get fcmToken => _fcmToken;

  Future<void> initialize() async {
    try {
      // 1. Minta izin notifikasi (di Chrome akan muncul pop-up Allow/Block)
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      debugPrint('FCM Permission status: ${settings.authorizationStatus}');

      // 2. Ambil FCM Token (Web menyertakan vapidKey)
      _fcmToken = await _messaging.getToken(
        vapidKey: kIsWeb ? _webVapidKey : null,
      );
      debugPrint('========================================');
      debugPrint('FCM TOKEN: $_fcmToken');
      debugPrint('========================================');

      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        debugPrint('FCM TOKEN REFRESHED: $newToken');
      });

      // 3. Handler saat notifikasi diterima ketika tab/aplikasi aktif (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final title = message.notification?.title ?? 'Notifikasi Baru';
        final body = message.notification?.body ?? '';
        debugPrint('Foreground FCM: $title -$body');

        messengerKey.currentState?.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.indigo,
            duration: const Duration(seconds: 5),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (body.isNotEmpty) Text(body),
              ],
            ),
          ),
        );
      });

      // 4. Handler saat notifikasi diklik (Background -> Open)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final title = message.notification?.title ?? 'Notifikasi Dibuka';
        final body = message.notification?.body ?? '';
        messengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Membuka notifikasi: $title —$body'),
            backgroundColor: Colors.teal,
          ),
        );
      });

      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        final title = initialMessage.notification?.title ?? 'Notifikasi Awal';
        debugPrint('Opened from terminated via notification: $title');
      }
    } catch (e) {
      debugPrint('Error inisialisasi FCM: $e');
    }
  }
}
