import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';

class NotificationService {
  final Ref _ref;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  NotificationService(this._ref);

  Future<void> init() async {
    // 1. Initialize Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _localNotifications.initialize(initializationSettings);

    // 2. Create Notification Channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 3. Request permissions (FCM)
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

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // Show local notification
        if (notification != null && android != null) {
          _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher', // Force default icon
                // or use android.smallIcon if you have multiple
              ),
            ),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _updateToken(String token) {
    final user = _ref.read(authControllerProvider).value;
    if (user == null) return; // Removed null check for name as it's required
    
    _ref.read(authControllerProvider.notifier).updateProfile(
      name: user.name,
      fcmToken: token,
    );
  }
}

final notificationServiceProvider = Provider((ref) => NotificationService(ref));
