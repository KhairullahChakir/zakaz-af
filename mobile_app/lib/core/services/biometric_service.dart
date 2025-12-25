import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:shared_preferences/shared_preferences.dart';

/// Keys for biometric storage
class BiometricKeys {
  static const String biometricEnabled = 'biometric_enabled';
  static const String biometricEmail = 'biometric_email';
  static const String biometricPassword = 'biometric_password';
}

/// Biometric authentication service provider
final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

/// Provider for biometric enabled state
final biometricEnabledProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(biometricServiceProvider);
  return service.isBiometricEnabled();
});

/// Biometric authentication service
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  /// Check if device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }
  
  /// Check if biometrics are available (enrolled)
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }
  
  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }
  
  /// Check if biometric login is enabled by user
  Future<bool> isBiometricEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(BiometricKeys.biometricEnabled) ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Enable biometric login and store credentials securely
  Future<bool> enableBiometric({
    required String email,
    required String password,
  }) async {
    try {
      // First authenticate to confirm user identity
      final authenticated = await authenticate(
        reason: 'Authenticate to enable biometric login',
      );
      
      if (!authenticated) return false;
      
      // Store credentials securely
      await _secureStorage.write(
        key: BiometricKeys.biometricEmail,
        value: email,
      );
      await _secureStorage.write(
        key: BiometricKeys.biometricPassword,
        value: password,
      );
      
      // Mark biometric as enabled
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(BiometricKeys.biometricEnabled, true);
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Disable biometric login and clear stored credentials
  Future<bool> disableBiometric() async {
    try {
      // Clear stored credentials
      await _secureStorage.delete(key: BiometricKeys.biometricEmail);
      await _secureStorage.delete(key: BiometricKeys.biometricPassword);
      
      // Mark biometric as disabled
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(BiometricKeys.biometricEnabled, false);
      
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Get stored credentials after biometric authentication
  Future<Map<String, String>?> getStoredCredentials() async {
    try {
      final email = await _secureStorage.read(key: BiometricKeys.biometricEmail);
      final password = await _secureStorage.read(key: BiometricKeys.biometricPassword);
      
      if (email != null && password != null) {
        return {'email': email, 'password': password};
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Authenticate using biometrics
  Future<bool> authenticate({
    required String reason,
    bool biometricOnly = false,
  }) async {
    try {
      // Check if device supports biometrics
      final isSupported = await isDeviceSupported();
      if (!isSupported) return false;
      
      // Check if biometrics are available
      final canCheck = await canCheckBiometrics();
      if (!canCheck) return false;
      
      return await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: biometricOnly,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        // No biometrics enrolled
        return false;
      } else if (e.code == auth_error.lockedOut || 
                 e.code == auth_error.permanentlyLockedOut) {
        // Too many attempts
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Perform biometric login - returns credentials if successful
  Future<Map<String, String>?> biometricLogin({
    required String reason,
  }) async {
    try {
      // Check if biometric is enabled
      final isEnabled = await isBiometricEnabled();
      if (!isEnabled) return null;
      
      // Authenticate
      final authenticated = await authenticate(reason: reason);
      if (!authenticated) return null;
      
      // Return stored credentials
      return await getStoredCredentials();
    } catch (e) {
      return null;
    }
  }
  
  /// Get a human-readable name for available biometric type
  Future<String> getBiometricTypeName() async {
    final types = await getAvailableBiometrics();
    if (types.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (types.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (types.contains(BiometricType.iris)) {
      return 'Iris';
    }
    return 'Biometric';
  }
}
