import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

/// Connectivity status
enum ConnectivityStatus {
  online,
  offline,
  checking,
}

/// Connectivity service for offline mode detection
@Riverpod(keepAlive: true)
class ConnectivityNotifier extends _$ConnectivityNotifier {
  Timer? _periodicCheck;

  @override
  ConnectivityStatus build() {
    // Start periodic connectivity check
    _startPeriodicCheck();
    
    // Initial check
    _checkConnectivity();
    
    ref.onDispose(() {
      _periodicCheck?.cancel();
    });
    
    return ConnectivityStatus.checking;
  }

  void _startPeriodicCheck() {
    _periodicCheck = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        state = ConnectivityStatus.online;
      } else {
        state = ConnectivityStatus.offline;
      }
    } on SocketException catch (_) {
      state = ConnectivityStatus.offline;
    }
  }

  /// Force a connectivity check
  Future<void> checkNow() async {
    state = ConnectivityStatus.checking;
    await _checkConnectivity();
  }

  /// Check if currently online
  bool get isOnline => state == ConnectivityStatus.online;
  
  /// Check if currently offline
  bool get isOffline => state == ConnectivityStatus.offline;
}

/// Widget to show offline banner
class OfflineBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const OfflineBanner({
    super.key,
    this.message = 'No internet connection',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.shade800,
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            const Icon(Icons.wifi_off, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}
