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
      return data.map((json) => Address.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch addresses');
    }
  }

  Future<Address> addAddress(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post('/addresses', data: data);
      return Address.fromJson(response.data);
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
      return Address.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update address');
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
