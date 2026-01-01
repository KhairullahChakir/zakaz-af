import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../storage/shared_prefs_provider.dart';

part 'haptic_service.g.dart';

/// Haptic feedback service for premium tactile experience
class HapticService {
  /// Light tap feedback (button press)
  static Future<void> lightTap() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium tap feedback (selection)
  static Future<void> mediumTap() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy tap feedback (error, important action)
  static Future<void> heavyTap() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click (checkboxes, toggles)
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Vibrate for success
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
  }

  /// Vibrate for error
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Vibrate for warning
  static Future<void> warning() async {
    await HapticFeedback.mediumImpact();
  }
}

/// Provider to track if haptic feedback is enabled
@Riverpod(keepAlive: true)
class HapticEnabled extends _$HapticEnabled {
  static const _key = 'haptic_feedback_enabled';

  @override
  bool build() {
    final prefs = ref.read(sharedPrefsProvider);
    return prefs.getBool(_key) ?? true; // Enabled by default
  }

  Future<void> toggle() async {
    state = !state;
    await ref.read(sharedPrefsProvider).setBool(_key, state);
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await ref.read(sharedPrefsProvider).setBool(_key, state);
  }
}

/// Extension to make haptic feedback conditional
extension ConditionalHaptic on HapticService {
  static Future<void> tapIf(bool enabled) async {
    if (enabled) await HapticService.lightTap();
  }
}
