// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopkeeper_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shopkeeperRepository)
const shopkeeperRepositoryProvider = ShopkeeperRepositoryProvider._();

final class ShopkeeperRepositoryProvider
    extends
        $FunctionalProvider<
          ShopkeeperRepository,
          ShopkeeperRepository,
          ShopkeeperRepository
        >
    with $Provider<ShopkeeperRepository> {
  const ShopkeeperRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopkeeperRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopkeeperRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShopkeeperRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShopkeeperRepository create(Ref ref) {
    return shopkeeperRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShopkeeperRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShopkeeperRepository>(value),
    );
  }
}

String _$shopkeeperRepositoryHash() =>
    r'181626163084509a99ba3a27d980f28970248530';

@ProviderFor(shopkeeperDashboard)
const shopkeeperDashboardProvider = ShopkeeperDashboardProvider._();

final class ShopkeeperDashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShopkeeperDashboard>,
          ShopkeeperDashboard,
          FutureOr<ShopkeeperDashboard>
        >
    with
        $FutureModifier<ShopkeeperDashboard>,
        $FutureProvider<ShopkeeperDashboard> {
  const ShopkeeperDashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopkeeperDashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopkeeperDashboardHash();

  @$internal
  @override
  $FutureProviderElement<ShopkeeperDashboard> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ShopkeeperDashboard> create(Ref ref) {
    return shopkeeperDashboard(ref);
  }
}

String _$shopkeeperDashboardHash() =>
    r'bc930e09220dea1521e5221dcd7cae9d21da92c7';

@ProviderFor(shopkeeperProducts)
const shopkeeperProductsProvider = ShopkeeperProductsProvider._();

final class ShopkeeperProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ShopkeeperProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopkeeperProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopkeeperProductsHash();

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    return shopkeeperProducts(ref);
  }
}

String _$shopkeeperProductsHash() =>
    r'068088e5ff163ae8b24cc86918cbde464b709833';

@ProviderFor(shopkeeperOrders)
const shopkeeperOrdersProvider = ShopkeeperOrdersProvider._();

final class ShopkeeperOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderModel>>,
          List<OrderModel>,
          FutureOr<List<OrderModel>>
        >
    with $FutureModifier<List<OrderModel>>, $FutureProvider<List<OrderModel>> {
  const ShopkeeperOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopkeeperOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopkeeperOrdersHash();

  @$internal
  @override
  $FutureProviderElement<List<OrderModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrderModel>> create(Ref ref) {
    return shopkeeperOrders(ref);
  }
}

String _$shopkeeperOrdersHash() => r'df9f9a214fd5aac413c49c4be71951838aad6f78';
