import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/user.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(dioProvider));
}

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<({User user, String token})> login(String login, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'login': login,
        'password': password,
      });

      final data = response.data;
      final user = User.fromJson(data['user']);
      final token = data['access_token'];

      return (user: user, token: token as String);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      }
      throw Exception('Network error');
    }
  }

  Future<({User user, String token})> register({
    required String name,
    required String password,
    String? email,
    String? phone,
  }) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
      });

      final data = response.data;
      final user = User.fromJson(data['user']);
      final token = data['access_token'];

      return (user: user, token: token as String);
    } on DioException catch (e) {
       if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Registration failed');
      }
      throw Exception('Network error');
    }
  }

  Future<User> getUser(String token) async {
    try {
      final response = await _dio.get('/user');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user');
    }
  }

  Future<User> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? imagePath,
    String? fcmToken,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'phone': phone,
        'fcm_token': fcmToken,
      }..removeWhere((key, value) => value == null);

      if (imagePath != null) {
        data['image'] = await MultipartFile.fromFile(imagePath);
      }

      final response = await _dio.post(
        '/user/profile',
        data: FormData.fromMap(data),
      );
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update profile');
    }
  }
}
