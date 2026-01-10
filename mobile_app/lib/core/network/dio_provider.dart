import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/storage/storage_provider.dart';

part 'dio_provider.g.dart';

// ===========================================
// 🔧 BACKEND URL CONFIGURATION
// ===========================================
// For LOCAL development: Run backend with: php artisan serve --host=0.0.0.0 --port=8000
// Then use your computer's IP address below.
//
// For PRODUCTION: Use the Railway URL
// ===========================================

// const String baseUrl = 'http://172.20.10.2:8000/api'; // Local development
// const String baseUrl = 'http://185.197.31.25/api'; // VPS IP (HTTP)
const String baseUrl = 'https://api.zakaz-af.store/api'; // Production (HTTPS)

@Riverpod(keepAlive: true)
Dio dio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    sendTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  dio.interceptors.add(AuthInterceptor(ref));
  
  // Only log actual errors for cleaner console
  dio.interceptors.add(InterceptorsWrapper(
    onError: (DioException e, ErrorInterceptorHandler handler) {
      // Only log server errors (not response parsing)
      if (e.response?.statusCode != null && e.response!.statusCode! >= 400) {
        debugPrint('🔴 API Error [${e.response?.statusCode}]: ${e.requestOptions.path}');
        debugPrint('   Message: ${e.message}');
      }
      handler.next(e);
    },
  ));

  return dio;
}

class AuthInterceptor extends Interceptor {
  final Ref _ref;
  bool _isRefreshing = false;

  AuthInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final storage = _ref.read(secureStorageProvider);
      final token = await storage.read(key: 'auth_token');

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // AuthInterceptor error
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - attempt token refresh
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      
      try {
        // Try to refresh the token
        final dio = Dio(BaseOptions(baseUrl: baseUrl));
        final storage = _ref.read(secureStorageProvider);
        final oldToken = await storage.read(key: 'auth_token');
        
        if (oldToken != null) {
          final response = await dio.post(
            '/auth/refresh',
            options: Options(headers: {'Authorization': 'Bearer $oldToken'}),
          );
          
          final newToken = response.data['access_token'];
          if (newToken != null) {
            await storage.write(key: 'auth_token', value: newToken);
            
            // Retry the original request with new token
            err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await dio.fetch(err.requestOptions);
            _isRefreshing = false;
            return handler.resolve(retryResponse);
          }
        }
      } catch (refreshError) {
        // Token refresh failed - user needs to re-login
        debugPrint('Token refresh failed: $refreshError');
      }
      
      _isRefreshing = false;
    }
    
    // Extract validation errors or message from response
    if (err.response?.data != null) {
      final data = err.response!.data;
      if (data is Map) {
        // Check for validation errors
        if (data['errors'] != null) {
          final errors = data['errors'] as Map;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            err = err.copyWith(
              message: firstError.first.toString(),
            );
          }
        } else if (data['message'] != null) {
          err = err.copyWith(message: data['message'].toString());
        }
      }
    }
    handler.next(err);
  }
}
