import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/storage/shared_prefs_provider.dart';

class GuestModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    // We cannot watch sharedPrefsProvider here because it returns SharedPreferences directly
    // and might trigger rebuilds if prefs object changes (unlikely but possible).
    // Accessing it via read/watch is standard.
    try {
      final prefs = ref.watch(sharedPrefsProvider);
      return prefs.getBool('is_guest_mode') ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> enable() async {
    state = true;
    await ref.read(sharedPrefsProvider).setBool('is_guest_mode', true);
  }

  Future<void> disable() async {
    state = false;
    await ref.read(sharedPrefsProvider).setBool('is_guest_mode', false);
  }
}

final guestModeProvider = NotifierProvider<GuestModeNotifier, bool>(GuestModeNotifier.new);
