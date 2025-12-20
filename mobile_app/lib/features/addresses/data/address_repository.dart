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
      throw Exception(e.response?.data['message'] ?? 'Failed to add address');
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
