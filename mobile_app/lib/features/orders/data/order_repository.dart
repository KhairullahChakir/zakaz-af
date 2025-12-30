import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/dio_provider.dart';
import '../../cart/domain/cart_item.dart';
import '../domain/order.dart';

part 'order_repository.g.dart';

@riverpod
OrderRepository orderRepository(Ref ref) {
  return OrderRepository(ref.watch(dioProvider));
}

class OrderRepository {
  final Dio _dio;

  OrderRepository(this._dio);

  Future<void> placeOrder(
    List<CartItem> items, {
    int? addressId,
    String paymentMethod = 'cash_on_delivery',
  }) async {
    try {
      final itemsData = items.map((item) => {
        'product_id': item.product.id,
        'quantity': item.quantity,
      }).toList();

      await _dio.post('/orders', data: {
        'items': itemsData,
        if (addressId != null) 'address_id': addressId,
        'payment_method': paymentMethod,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to place order');
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _dio.get('/orders');
      final List<dynamic> data = response.data;
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch orders');
    }
  }

  Future<OrderModel> getOrder(int id) async {
    try {
      final response = await _dio.get('/orders/$id');
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch order');
    }
  }
}

@riverpod
Future<OrderModel> orderDetails(Ref ref, int orderId) async {
  return ref.watch(orderRepositoryProvider).getOrder(orderId);
}
