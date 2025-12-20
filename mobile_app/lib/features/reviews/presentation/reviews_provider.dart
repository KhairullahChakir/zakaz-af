import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/review_repository.dart';
import '../domain/review.dart';

part 'reviews_provider.g.dart';

@riverpod
Future<List<Review>> productReviews(Ref ref, int productId) {
  return ref.watch(reviewRepositoryProvider).getProductReviews(productId);
}
