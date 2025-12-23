import '../../auth/domain/user.dart';

class Review {
  final int id;
  final int userId;
  final int productId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  final User? user;

  Review({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      rating: json['rating'] is String ? int.parse(json['rating']) : json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }
}
