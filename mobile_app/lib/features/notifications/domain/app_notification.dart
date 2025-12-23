class AppNotification {
  final int id;
  final int? userId;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? data;
  final bool read;
  final String? createdAt;

  AppNotification({
    required this.id,
    this.userId,
    required this.title,
    required this.body,
    this.type = 'general',
    this.data,
    this.read = false,
    this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      data: json['data'],
      read: json['is_read'] ?? false,
      createdAt: json['created_at'],
    );
  }

  AppNotification copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    String? type,
    Map<String, dynamic>? data,
    bool? read,
    String? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      read: read ?? this.read,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
