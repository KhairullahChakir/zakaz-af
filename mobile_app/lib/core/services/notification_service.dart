import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';

class NotificationService {
  final Ref _ref;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  NotificationService(this._ref);

  Future<void> init() async {
    // Request permissions
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      
      // Get token
      String? token = await _fcm.getToken();
      if (token != null) {
        print('FCM Token: $token');
        _updateToken(token);
      }

      // Listen for token refresh
      _fcm.onTokenRefresh.listen(_updateToken);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _updateToken(String token) {
    _ref.read(authControllerProvider.notifier).updateProfile(
      name: _ref.read(authControllerProvider).value?.name ?? '',
      fcmToken: token,
    );
  }
}

final notificationServiceProvider = Provider((ref) => NotificationService(ref));
