import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../domain/address.dart';

part 'address_repository.g.dart';

@riverpod
AddressRepository addressRepository(Ref ref) {
  return AddressRepository(ref.watch(dioProvider));
}

class AddressRepository {
  final Dio _dio;

  AddressRepository(this._dio);

  Future<List<Address>> getAddresses() async {
    try {
      final response = await _dio.get('/addresses');
      final List data = response.data;
      return data.map((json) {
        if (json is Map<String, dynamic>) {
          _fixLocationTypes(json);
        }
        return Address.fromJson(json);
      }).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch addresses');
    }
  }

  Future<Address> addAddress(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/addresses', data: data);
      final json = response.data;
      _fixLocationTypes(json);
      return Address.fromJson(json);
    } on DioException catch (e) {
      // Get the most specific error message available
      String message = 'Failed to add address';
      
      if (e.response?.data != null) {
        final responseData = e.response!.data;
        if (responseData is Map) {
          // Check for validation errors
          if (responseData['errors'] != null) {
            final errors = responseData['errors'] as Map;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              message = firstError.first.toString();
            }
          } else if (responseData['message'] != null) {
            message = responseData['message'].toString();
          }
        }
      } else if (e.message != null) {
        message = e.message!;
      }
      
      throw Exception(message);
    }
  }

  Future<Address> updateAddress(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/addresses/$id', data: data);
      final json = response.data;
      _fixLocationTypes(json);
      return Address.fromJson(json);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update address');
    }
  }

  void _fixLocationTypes(Map<String, dynamic> json) {
    if (json['latitude'] != null) {
      if (json['latitude'] is String) {
        json['latitude'] = double.tryParse(json['latitude']);
      } else if (json['latitude'] is int) {
        json['latitude'] = (json['latitude'] as int).toDouble();
      }
    }
    if (json['longitude'] != null) {
      if (json['longitude'] is String) {
        json['longitude'] = double.tryParse(json['longitude']);
      } else if (json['longitude'] is int) {
        json['longitude'] = (json['longitude'] as int).toDouble();
      }
    }
  }

  Future<void> deleteAddress(int id) async {
    try {
      await _dio.delete('/addresses/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete address');
    }
  }
}
