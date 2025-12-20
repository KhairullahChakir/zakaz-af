// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderRepository)
const orderRepositoryProvider = OrderRepositoryProvider._();

final class OrderRepositoryProvider
    extends
        $FunctionalProvider<OrderRepository, OrderRepository, OrderRepository>
    with $Provider<OrderRepository> {
  const OrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRepository create(Ref ref) {
    return orderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRepository>(value),
    );
  }
}

String _$orderRepositoryHash() => r'5450c352fc9079476f3c12e00d33f37ef5b607c5';

@ProviderFor(orderDetails)
const orderDetailsProvider = OrderDetailsFamily._();

final class OrderDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderModel>,
          OrderModel,
          FutureOr<OrderModel>
        >
    with $FutureModifier<OrderModel>, $FutureProvider<OrderModel> {
  const OrderDetailsProvider._({
    required OrderDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'orderDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderDetailsHash();

  @override
  String toString() {
    return r'orderDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrderModel> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<OrderModel> create(Ref ref) {
    final argument = this.argument as int;
    return orderDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderDetailsHash() => r'3551d5ece1b5d2879ae914c72b44eb26cd498c18';

final class OrderDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrderModel>, int> {
  const OrderDetailsFamily._()
    : super(
        retry: null,
        name: r'orderDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderDetailsProvider call(int orderId) =>
      OrderDetailsProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderDetailsProvider';
}
