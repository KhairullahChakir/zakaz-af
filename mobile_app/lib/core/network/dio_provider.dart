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

const String baseUrl = 'http://172.20.10.2:8000/api';
// const String baseUrl = 'https://zakaz-af-production.up.railway.app/api';

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
  
  // Only log errors for cleaner console
  dio.interceptors.add(LogInterceptor(
    request: false,
    requestHeader: false,
    requestBody: false,
    responseHeader: false,
    responseBody: false,
    error: true,
    logPrint: (o) => print('*** DioException ***:\n$o'),
  ));

  return dio;
}

class AuthInterceptor extends Interceptor {
  final Ref _ref;

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
  void onError(DioException err, ErrorInterceptorHandler handler) {
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
