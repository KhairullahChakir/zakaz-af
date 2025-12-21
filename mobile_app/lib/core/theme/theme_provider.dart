import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/shared_prefs_provider.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final savedMode = prefs.getString(_key);
    
    debugPrint('Saved theme mode: $savedMode');
    if (savedMode == 'light') return ThemeMode.light;
    if (savedMode == 'dark') return ThemeMode.dark;
    return ThemeMode.light; // Force default to Light instead of System
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref.read(sharedPrefsProvider).setString(_key, mode.name);
  }
}
