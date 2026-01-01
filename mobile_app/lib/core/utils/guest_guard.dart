import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import 'package:mobile_app/features/auth/presentation/guest_provider.dart';

class GuestGuard {
  /// Checks if the current user is a guest.
  /// If YES: Shows a dialog prompting to login and returns TRUE (blocked).
  /// If NO: Returns FALSE (safe to proceed).
  static bool check(BuildContext context, WidgetRef ref) {
    // 1. Check Guest State
    final isGuest = ref.read(guestModeProvider);

    if (!isGuest) return false; // Not a guest, proceed.

    // 2. Show Dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ref.tr('login_required')),
        content: Text(ref.tr('guest_action_restricted')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(ref.tr('cancel')),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              // Navigate to Login
              // We use push so they can come back if they change their mind
              context.push('/login'); 
            },
            child: Text(ref.tr('login')),
          ),
        ],
      ),
    );

    return true; // Is guest, action blocked.
  }
}
