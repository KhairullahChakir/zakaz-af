import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/shared_prefs_provider.dart';

/// Theme mode options
enum AppThemeMode {
  system,
  light,
  dark;
  
  String get displayName {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }
  
  IconData get icon {
    switch (this) {
      case AppThemeMode.system:
        return Icons.brightness_auto_rounded;
      case AppThemeMode.light:
        return Icons.light_mode_rounded;
      case AppThemeMode.dark:
        return Icons.dark_mode_rounded;
    }
  }
  
  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }
}

/// Keys for theme storage
const String _themeKey = 'theme_mode';

/// Theme preference notifier
class ThemePreferenceNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final savedMode = prefs.getString(_themeKey);
    debugPrint('Loaded saved theme: $savedMode');
    
    switch (savedMode) {
      case 'system':
        return AppThemeMode.system;
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system; // Default to system
    }
  }
  
  void setTheme(AppThemeMode mode) {
    state = mode;
    ref.read(sharedPrefsProvider).setString(_themeKey, mode.name);
    debugPrint('Theme set to: ${mode.name}');
  }
  
  void toggleDarkMode() {
    if (state == AppThemeMode.dark) {
      setTheme(AppThemeMode.light);
    } else {
      setTheme(AppThemeMode.dark);
    }
  }
}

/// Theme preference provider
final themePreferenceProvider = NotifierProvider<ThemePreferenceNotifier, AppThemeMode>(() {
  return ThemePreferenceNotifier();
});

/// Provides the actual ThemeMode for MaterialApp
final themeProvider = Provider<ThemeMode>((ref) {
  final themePref = ref.watch(themePreferenceProvider);
  return themePref.themeMode;
});
