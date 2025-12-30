import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/storage/shared_prefs_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/language_provider.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set Stripe Publishable Key
  Stripe.publishableKey = "pk_test_51O7v5kSD3p6D5j5zXkYz8x3R2W1v0U9t8s7r6q5p4n3m2l1k0j9i8h7g6f5e4d3c2b1a";
  Stripe.instance.applySettings();
  
  // Initialize Firebase (Try-catch in case config files are missing)
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initNotifications();
    });
  }

  Future<void> _initNotifications() async {
    try {
      await ref.read(notificationServiceProvider).init();
    } catch (e) {
      debugPrint('Notification init error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);
    final language = ref.watch(languageProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Zakaz - AF',
      locale: language.locale,
      supportedLocales: AppLanguage.values.map((e) => e.locale),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: premiumLightTheme(),
      darkTheme: premiumDarkTheme(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
