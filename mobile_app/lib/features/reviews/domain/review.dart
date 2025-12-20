import 'package:freezed_annotation/freezed_annotation.dart';
import '../../auth/domain/user.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'product_id') required int productId,
    required int rating,
    String? comment,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    User? user,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
