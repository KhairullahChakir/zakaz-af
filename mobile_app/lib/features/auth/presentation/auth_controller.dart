import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/core/storage/storage_provider.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/auth/domain/user.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<User?> build() async {
    String? token;
    try {
      token = await ref.read(secureStorageProvider).read(key: 'auth_token');
    } catch (e) {
      // Storage read failed, assume no token
      return null;
    }
    
    if (token == null) return null;

    try {
      final repo = ref.read(authRepositoryProvider);
      return await repo.getUser(token);
    } catch (e) {
      print('DEBUG: AuthController build failed: $e');
      // Token invalid or network error
      await ref.read(secureStorageProvider).delete(key: 'auth_token');
      return null;
    }
  }

  Future<void> login(String login, String password) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.login(login, password);
      
      // Save token
      await ref.read(secureStorageProvider).write(key: 'auth_token', value: result.token);
      
      state = AsyncValue.data(result.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register({
    required String name,
    required String password,
    String? email,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.register(
        name: name,
        password: password,
        email: email,
        phone: phone,
      );

      // Save token
      await ref.read(secureStorageProvider).write(key: 'auth_token', value: result.token);

      state = AsyncValue.data(result.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    // TODO: Call API logout
    await ref.read(secureStorageProvider).delete(key: 'auth_token');
    state = const AsyncValue.data(null);
  }

  Future<void> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? imagePath,
    String? fcmToken,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.updateProfile(
        name: name,
        email: email,
        phone: phone,
        imagePath: imagePath,
        fcmToken: fcmToken,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      // Don't set state to error as it will log the user out
      print('Profile update failed: $e');
      if (state.hasValue) {
        state = AsyncValue.data(state.value); // Keep old data
      }
    }
  }
}
