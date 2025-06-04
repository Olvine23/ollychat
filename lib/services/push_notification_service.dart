import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call this method from main() after initializing Firebase
  static Future<void> initialize() async {
    // Background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permissions (especially for Android 13+ and iOS)
    await _requestPermission();

    // Get the token
    await _getDeviceToken();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_onMessage);

    // Handle notification when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  /// Permission request
  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted notification permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      debugPrint('🔄 Provisional permission granted');
    } else {
      debugPrint('❌ Notification permission denied');
    }
  }

  /// Device Token
  static Future<void> _getDeviceToken() async {
    String? token = await _messaging.getToken();
    debugPrint("📱 FCM Token: $token");

    // TODO: Send this token to your backend if needed
  }

  /// Handle foreground messages
  static void _onMessage(RemoteMessage message) {
    debugPrint('📥 Foreground message: ${message.notification?.title}');

    // Optionally show a local notification using flutter_local_notifications
  }

  /// Handle tap on notification
  static void _onMessageOpenedApp(RemoteMessage message) {
    debugPrint('🚀 Notification tapped: ${message.data}');
    // Navigate or trigger specific logic
  }

  /// Background handler (must be top-level)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("🔄 Background message: ${message.messageId}");
  }
}