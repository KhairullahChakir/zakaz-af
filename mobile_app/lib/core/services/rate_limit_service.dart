import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rate_limit_service.g.dart';

/// Rate limit state
class RateLimitState {
  final int attemptsRemaining;
  final int maxAttempts;
  final DateTime? lockedUntil;
  final bool isLocked;

  RateLimitState({
    this.attemptsRemaining = 5,
    this.maxAttempts = 5,
    this.lockedUntil,
    this.isLocked = false,
  });

  /// Seconds remaining until unlock
  int get secondsRemaining {
    if (lockedUntil == null) return 0;
    final diff = lockedUntil!.difference(DateTime.now()).inSeconds;
    return diff > 0 ? diff : 0;
  }

  RateLimitState copyWith({
    int? attemptsRemaining,
    int? maxAttempts,
    DateTime? lockedUntil,
    bool? isLocked,
  }) {
    return RateLimitState(
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      lockedUntil: lockedUntil ?? this.lockedUntil,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

/// Rate limiting service for login attempts
@Riverpod(keepAlive: true)
class RateLimitNotifier extends _$RateLimitNotifier {
  Timer? _unlockTimer;

  @override
  RateLimitState build() {
    ref.onDispose(() {
      _unlockTimer?.cancel();
    });
    return RateLimitState();
  }

  /// Record a failed attempt
  void recordFailedAttempt() {
    final newAttempts = state.attemptsRemaining - 1;
    
    if (newAttempts <= 0) {
      // Lock for 60 seconds
      final lockUntil = DateTime.now().add(const Duration(seconds: 60));
      state = state.copyWith(
        attemptsRemaining: 0,
        isLocked: true,
        lockedUntil: lockUntil,
      );
      _startUnlockTimer();
    } else {
      state = state.copyWith(attemptsRemaining: newAttempts);
    }
  }

  /// Record a successful attempt (reset)
  void recordSuccess() {
    _unlockTimer?.cancel();
    state = RateLimitState();
  }

  /// Start timer to auto-unlock
  void _startUnlockTimer() {
    _unlockTimer?.cancel();
    _unlockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.secondsRemaining <= 0) {
        _unlockTimer?.cancel();
        state = RateLimitState();
      } else {
        // Just trigger rebuild for countdown
        state = state.copyWith();
      }
    });
  }

  /// Check if can attempt login
  bool get canAttempt => !state.isLocked;
}

/// Widget to show rate limit warning
class RateLimitWarning extends StatelessWidget {
  final int attemptsRemaining;
  final int maxAttempts;
  final int secondsRemaining;
  final bool isLocked;

  const RateLimitWarning({
    super.key,
    required this.attemptsRemaining,
    required this.maxAttempts,
    required this.secondsRemaining,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocked) {
      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock_clock, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Too many failed attempts',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Try again in $secondsRemaining seconds',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (attemptsRemaining < maxAttempts && attemptsRemaining > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
            const SizedBox(width: 8),
            Text(
              '$attemptsRemaining attempts remaining',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
