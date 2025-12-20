import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/order_repository.dart';
import '../domain/order.dart';

part 'orders_provider.g.dart';

@riverpod
Future<List<OrderModel>> orders(Ref ref) {
  return ref.watch(orderRepositoryProvider).getOrders();
}
