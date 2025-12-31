import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/features/auth/presentation/auth_controller.dart';
import 'package:mobile_app/core/app_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Clearer handling for background messages
  debugPrint("Handling a background message: ${message.messageId}");
}

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
    
    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationClick(response.payload);
      },
    );

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
      debugPrint('User granted permission');
      
      // Get token
      String? token = await _fcm.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        // Don't update token here - wait for user to login
        // _updateToken will be called when auth state changes from null to logged in
      }

      // Listen for token refresh - only update if user is logged in
      _fcm.onTokenRefresh.listen((newToken) {
        token = newToken; // Update local token
        _updateToken(newToken);
      });

      // Listen for auth changes - only update token on actual login (user ID changed)
      _ref.listen(authControllerProvider, (previous, next) {
        final previousId = previous?.value?.id;
        final newId = next.value?.id;
        
        // Only update token when user logs in (was null, now has value)
        // Don't update on every auth state change to avoid infinite loop
        if (newId != null && previousId == null && token != null) {
          _updateToken(token!);
        }
      });

      // 4. Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        
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
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: message.data['conversation_id'],
          );
        }
      });

      // 5. Handle background clicks (App was in background)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationClick(message.data['conversation_id']);
      });

      // 6. Handle cold start clicks (App was terminated)
      _fcm.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          _handleNotificationClick(message.data['conversation_id']);
        }
      });

    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  void _handleNotificationClick(String? conversationId) {
    if (conversationId != null) {
      final router = _ref.read(appRouterProvider);
      router.push('/chat/$conversationId');
    }
  }

  String? _lastSentToken;
  
  void _updateToken(String token) {
    // Don't send same token twice
    if (_lastSentToken == token) return;
    
    final authState = _ref.read(authControllerProvider);
    if (!authState.hasValue || authState.value == null) return;
    
    _lastSentToken = token;
    final user = authState.value!;
    _ref.read(authControllerProvider.notifier).updateProfile(
      name: user.name,
      fcmToken: token,
    );
  }
}

final notificationServiceProvider = Provider((ref) => NotificationService(ref));
