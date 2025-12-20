import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';

part 'analytics_repository.g.dart';

@riverpod
AnalyticsRepository analyticsRepository(Ref ref) {
  return AnalyticsRepository(ref.watch(dioProvider));
}

class AnalyticsRepository {
  final Dio _dio;

  AnalyticsRepository(this._dio);

  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await _dio.get('/analytics/stats');
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch analytics');
    }
  }
}
