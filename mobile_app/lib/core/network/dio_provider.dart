import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/storage/storage_provider.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://127.0.0.1:8000/api', // Works with `adb reverse tcp:8000 tcp:8000`
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));

  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));

  // Add auth token to requests
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
       final storage = ref.read(secureStorageProvider);
       final token = await storage.read(key: 'auth_token');
       
       if (token != null) {
         options.headers['Authorization'] = 'Bearer $token';
       }
       
       return handler.next(options);
    },
  ));

  return dio;
}
