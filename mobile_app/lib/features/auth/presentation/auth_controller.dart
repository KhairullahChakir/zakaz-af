import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile_app/core/storage/storage_provider.dart';
import 'package:mobile_app/features/auth/data/auth_repository.dart';
import 'package:mobile_app/features/auth/domain/user.dart';
import 'package:mobile_app/features/cart/presentation/cart_provider.dart';

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
      
      // Clear cart for new login session
      await ref.read(cartProvider.notifier).clearCart();
      
      state = AsyncValue.data(result.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> googleLogin() async {
    state = const AsyncValue.loading();
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        state = AsyncValue.data(state.value);
        return;
      }

      final repo = ref.read(authRepositoryProvider);
      final result = await repo.googleLogin(
        email: googleUser.email,
        name: googleUser.displayName ?? 'Google User',
        googleId: googleUser.id,
        avatar: googleUser.photoUrl,
      );

      // Save token
      await ref.read(secureStorageProvider).write(key: 'auth_token', value: result.token);

      // Clear cart for new login session
      await ref.read(cartProvider.notifier).clearCart();

      state = AsyncValue.data(result.user);
    } catch (e, st) {
      // Log the full error for debugging
      // print('Google Login Error: $e');
      // print('Google Login StackTrace: $st');
      
      String message = 'Google login failed';
      if (e.toString().contains('10')) {
        message = 'Google Login Configuration Error (Code 10). Please ensure SHA-1 is added to Firebase Console.';
      } else if (e.toString().contains('12500')) {
        message = 'Google Login Cancelled or Play Services Error (12500)';
      } else if (e.toString().contains('canceled')) {
        message = 'Sign in was canceled';
      }
      
      state = AsyncValue.error(message, st);
    }
  }

  Future<void> register({
    required String name,
    required String password,
    String? email,
    String? phone,
    String? role,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.register(
        name: name,
        password: password,
        email: email,
        phone: phone,
        role: role,
      );

      // Save token
      await ref.read(secureStorageProvider).write(key: 'auth_token', value: result.token);

      // Clear cart for new registration
      await ref.read(cartProvider.notifier).clearCart();

      state = AsyncValue.data(result.user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    // TODO: Call API logout
    await ref.read(secureStorageProvider).delete(key: 'auth_token');
    // Clear cart on logout
    await ref.read(cartProvider.notifier).clearCart();
    state = const AsyncValue.data(null);
  }

  Future<void> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? imagePath,
    String? fcmToken,
  }) async {
    // ignore: invalid_use_of_internal_member
    state = AsyncLoading<User?>().copyWithPrevious(state);
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
    } catch (e) {
      // Don't set state to error as it will log the user out
      if (state.hasValue) {
        state = AsyncValue.data(state.value); // Keep old data
      }
    }
  }

  Future<void> verifyOtp(String otp) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepositoryProvider).verifyOtp(otp);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> resendOtp() async {
    try {
      await ref.read(authRepositoryProvider).resendOtp();
    } catch (e) {
      // debugPrint('Resend OTP failed: $e');
    }
  }

  Future<String> forgotPassword(String email) async {
    return await ref.read(authRepositoryProvider).forgotPassword(email);
  }

  Future<String> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await ref.read(authRepositoryProvider).resetPassword(
          email: email,
          otp: otp,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await ref.read(authRepositoryProvider).changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
  }
}
