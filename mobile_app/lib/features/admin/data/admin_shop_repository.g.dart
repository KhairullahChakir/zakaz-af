// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shop_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminShopRepository)
const adminShopRepositoryProvider = AdminShopRepositoryProvider._();

final class AdminShopRepositoryProvider
    extends
        $FunctionalProvider<
          AdminShopRepository,
          AdminShopRepository,
          AdminShopRepository
        >
    with $Provider<AdminShopRepository> {
  const AdminShopRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminShopRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminShopRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminShopRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AdminShopRepository create(Ref ref) {
    return adminShopRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminShopRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminShopRepository>(value),
    );
  }
}

String _$adminShopRepositoryHash() =>
    r'06b00e3fff85a474682d7a7e4c96453e3c5ff59d';

@ProviderFor(pendingShops)
const pendingShopsProvider = PendingShopsProvider._();

final class PendingShopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Shop>>,
          List<Shop>,
          FutureOr<List<Shop>>
        >
    with $FutureModifier<List<Shop>>, $FutureProvider<List<Shop>> {
  const PendingShopsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingShopsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingShopsHash();

  @$internal
  @override
  $FutureProviderElement<List<Shop>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Shop>> create(Ref ref) {
    return pendingShops(ref);
  }
}

String _$pendingShopsHash() => r'a301506da452bd33a62c7951a05cb317593e6ddc';

@ProviderFor(allShops)
const allShopsProvider = AllShopsFamily._();

final class AllShopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Shop>>,
          List<Shop>,
          FutureOr<List<Shop>>
        >
    with $FutureModifier<List<Shop>>, $FutureProvider<List<Shop>> {
  const AllShopsProvider._({
    required AllShopsFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'allShopsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allShopsHash();

  @override
  String toString() {
    return r'allShopsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Shop>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Shop>> create(Ref ref) {
    final argument = this.argument as String?;
    return allShops(ref, status: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AllShopsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allShopsHash() => r'34fab6f47fb671225df576e69b1db57bda658fef';

final class AllShopsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Shop>>, String?> {
  const AllShopsFamily._()
    : super(
        retry: null,
        name: r'allShopsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AllShopsProvider call({String? status}) =>
      AllShopsProvider._(argument: status, from: this);

  @override
  String toString() => r'allShopsProvider';
}
