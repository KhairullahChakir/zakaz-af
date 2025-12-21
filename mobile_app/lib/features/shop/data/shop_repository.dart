import 'dart:io';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/shop.dart';

part 'shop_repository.g.dart';

@riverpod
ShopRepository shopRepository(Ref ref) {
  return ShopRepository(ref.watch(dioProvider));
}

class ShopRepository {
  final Dio _dio;

  ShopRepository(this._dio);

  /// Check if user has a shop application
  Future<Shop?> getShopStatus() async {
    try {
      final response = await _dio.get('/shop/status');
      if (response.data['has_application'] == true) {
        return Shop.fromJson(response.data['shop']);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to check shop status');
    }
  }

  /// Submit shop application
  Future<Shop> applyForShop({
    required String name,
    required String type,
    String? description,
    required String address,
    required String city,
    required String province,
    double? latitude,
    double? longitude,
    required String phone,
    String? email,
    required List<File> photos,
    required File businessLicense,
    File? ownerNid,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'type': type,
        if (description != null) 'description': description,
        'address': address,
        'city': city,
        'province': province,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        'phone': phone,
        if (email != null) 'email': email,
        'business_license': await MultipartFile.fromFile(
          businessLicense.path,
          filename: 'license.jpg',
        ),
        if (ownerNid != null)
          'owner_nid': await MultipartFile.fromFile(
            ownerNid.path,
            filename: 'nid.jpg',
          ),
      });

      // Add photos
      for (int i = 0; i < photos.length; i++) {
        formData.files.add(MapEntry(
          'photos[$i]',
          await MultipartFile.fromFile(photos[i].path, filename: 'photo_$i.jpg'),
        ));
      }

      final response = await _dio.post('/shop/apply', data: formData);
      return Shop.fromJson(response.data['shop']);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to submit application');
    }
  }
}

/// Provider for shop application status
@riverpod
Future<Shop?> shopApplicationStatus(Ref ref) async {
  return ref.watch(shopRepositoryProvider).getShopStatus();
}
