import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Example FCMService that handles:
///   - Requesting permissions (iOS)
///   - Getting the FCM token
///   - Listening for token refresh
///   - Optionally storing token in Supabase, if user is logged in.
class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call this once, e.g. after Firebase.initializeApp(),
  /// maybe in your main() or in a top-level app widget.
  static Future<void> initFCM({
    required Future<void> Function(String fcmToken) onNewToken,
  }) async {
    print('Trying to get token');
    // 1) Request permission on iOS
    await _requestNotificationPermissions();

    print('got permission');
    // 2) Get the token
    final token = await _messaging.getToken();
    if (token != null) {
      debugPrint('FCM Token: $token');
      // Here you can do something like:
      await onNewToken(token);
    }

    // 3) Any time the token refreshes, call [onNewToken].
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      debugPrint('FCM Token refreshed: $newToken');
      await onNewToken(newToken);
    });

    // 4) (Optional) handle foreground messages
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   debugPrint('Got a foreground message: ${message.notification?.title}');
    //   // handle foreground notification...
    // });
  }

  static Future<void> _requestNotificationPermissions() async {
    // On iOS, you must explicitly request permission, which shows a native dialog.
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
    // If the user declines or not determined, you can handle that scenario.
  }
}
