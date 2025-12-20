import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/review.dart';

part 'review_repository.g.dart';

@riverpod
ReviewRepository reviewRepository(Ref ref) {
  return ReviewRepository(ref.watch(dioProvider));
}

class ReviewRepository {
  final Dio _dio;

  ReviewRepository(this._dio);

  Future<List<Review>> getProductReviews(int productId) async {
    try {
      final response = await _dio.get('/products/$productId/reviews');
      final List data = response.data;
      return data.map((json) => Review.fromJson(json)).toList();
    } on DioException catch (e) {
       throw Exception(e.response?.data['message'] ?? 'Failed to load reviews');
    }
  }

  Future<Review> postReview({
    required int productId,
    required int rating,
    String? comment,
  }) async {
    try {
      final response = await _dio.post('/reviews', data: {
        'product_id': productId,
        'rating': rating,
        'comment': comment,
      });
      return Review.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to submit review');
    }
  }
}
