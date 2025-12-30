import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'storage_provider.g.dart';

@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  // Use encrypted shared preferences for Android to ensure persistence
  const AndroidOptions androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );
  return const FlutterSecureStorage(aOptions: androidOptions);
}
