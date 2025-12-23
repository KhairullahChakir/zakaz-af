class User {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? profileImage;
  final String? profileImageUrl;
  final String? fcmToken;
  final String role;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.profileImage,
    this.profileImageUrl,
    this.fcmToken,
    this.role = 'customer',
    this.isVerified = false,
  });

  bool get isAdmin => role == 'admin';
  bool get isShopkeeper => role == 'shopkeeper';
  bool get isCustomer => role == 'customer';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profile_image'],
      profileImageUrl: json['profile_image_url'],
      fcmToken: json['fcm_token'],
      role: json['role'] ?? 'customer',
      isVerified: _parseBool(json['is_verified']),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image': profileImage,
      'profile_image_url': profileImageUrl,
      'fcm_token': fcmToken,
      'role': role,
      'is_verified': isVerified,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? profileImageUrl,
    String? fcmToken,
    String? role,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
