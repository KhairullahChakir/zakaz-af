// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shopRepository)
const shopRepositoryProvider = ShopRepositoryProvider._();

final class ShopRepositoryProvider
    extends $FunctionalProvider<ShopRepository, ShopRepository, ShopRepository>
    with $Provider<ShopRepository> {
  const ShopRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShopRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ShopRepository create(Ref ref) {
    return shopRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShopRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShopRepository>(value),
    );
  }
}

String _$shopRepositoryHash() => r'd431619e9ceaa3f99898b1c14bae52f58f5f8cf4';

/// Provider for shop application status

@ProviderFor(shopApplicationStatus)
const shopApplicationStatusProvider = ShopApplicationStatusProvider._();

/// Provider for shop application status

final class ShopApplicationStatusProvider
    extends $FunctionalProvider<AsyncValue<Shop?>, Shop?, FutureOr<Shop?>>
    with $FutureModifier<Shop?>, $FutureProvider<Shop?> {
  /// Provider for shop application status
  const ShopApplicationStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopApplicationStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopApplicationStatusHash();

  @$internal
  @override
  $FutureProviderElement<Shop?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Shop?> create(Ref ref) {
    return shopApplicationStatus(ref);
  }
}

String _$shopApplicationStatusHash() =>
    r'07bae853aec878be34df7f3f581ef42b8721c95d';
