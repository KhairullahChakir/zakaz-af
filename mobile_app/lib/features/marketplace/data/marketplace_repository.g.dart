// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(marketplaceRepository)
const marketplaceRepositoryProvider = MarketplaceRepositoryProvider._();

final class MarketplaceRepositoryProvider
    extends
        $FunctionalProvider<
          MarketplaceRepository,
          MarketplaceRepository,
          MarketplaceRepository
        >
    with $Provider<MarketplaceRepository> {
  const MarketplaceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketplaceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketplaceRepositoryHash();

  @$internal
  @override
  $ProviderElement<MarketplaceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarketplaceRepository create(Ref ref) {
    return marketplaceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketplaceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketplaceRepository>(value),
    );
  }
}

String _$marketplaceRepositoryHash() =>
    r'12d424b8aa2977a9d42515b734c7971e7b460f60';

@ProviderFor(MarketplaceItemsCache)
const marketplaceItemsCacheProvider = MarketplaceItemsCacheProvider._();

final class MarketplaceItemsCacheProvider
    extends
        $AsyncNotifierProvider<MarketplaceItemsCache, List<MarketplaceItem>> {
  const MarketplaceItemsCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketplaceItemsCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$marketplaceItemsCacheHash();

  @$internal
  @override
  MarketplaceItemsCache create() => MarketplaceItemsCache();
}

String _$marketplaceItemsCacheHash() =>
    r'54cf99796394a2bb6fffc23f92f9132764f6a60d';

abstract class _$MarketplaceItemsCache
    extends $AsyncNotifier<List<MarketplaceItem>> {
  FutureOr<List<MarketplaceItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<MarketplaceItem>>, List<MarketplaceItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MarketplaceItem>>,
                List<MarketplaceItem>
              >,
              AsyncValue<List<MarketplaceItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(marketplaceItems)
const marketplaceItemsProvider = MarketplaceItemsFamily._();

final class MarketplaceItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MarketplaceItem>>,
          List<MarketplaceItem>,
          FutureOr<List<MarketplaceItem>>
        >
    with
        $FutureModifier<List<MarketplaceItem>>,
        $FutureProvider<List<MarketplaceItem>> {
  const MarketplaceItemsProvider._({
    required MarketplaceItemsFamily super.from,
    required ({
      int? categoryId,
      String? condition,
      double? minPrice,
      double? maxPrice,
      String? search,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'marketplaceItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$marketplaceItemsHash();

  @override
  String toString() {
    return r'marketplaceItemsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<MarketplaceItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MarketplaceItem>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              int? categoryId,
              String? condition,
              double? minPrice,
              double? maxPrice,
              String? search,
            });
    return marketplaceItems(
      ref,
      categoryId: argument.categoryId,
      condition: argument.condition,
      minPrice: argument.minPrice,
      maxPrice: argument.maxPrice,
      search: argument.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MarketplaceItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$marketplaceItemsHash() => r'051f283bd44f77adf0c46dc57739991d8a38c59a';

final class MarketplaceItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<MarketplaceItem>>,
          ({
            int? categoryId,
            String? condition,
            double? minPrice,
            double? maxPrice,
            String? search,
          })
        > {
  const MarketplaceItemsFamily._()
    : super(
        retry: null,
        name: r'marketplaceItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MarketplaceItemsProvider call({
    int? categoryId,
    String? condition,
    double? minPrice,
    double? maxPrice,
    String? search,
  }) => MarketplaceItemsProvider._(
    argument: (
      categoryId: categoryId,
      condition: condition,
      minPrice: minPrice,
      maxPrice: maxPrice,
      search: search,
    ),
    from: this,
  );

  @override
  String toString() => r'marketplaceItemsProvider';
}

@ProviderFor(myMarketplaceItems)
const myMarketplaceItemsProvider = MyMarketplaceItemsProvider._();

final class MyMarketplaceItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MarketplaceItem>>,
          List<MarketplaceItem>,
          FutureOr<List<MarketplaceItem>>
        >
    with
        $FutureModifier<List<MarketplaceItem>>,
        $FutureProvider<List<MarketplaceItem>> {
  const MyMarketplaceItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myMarketplaceItemsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myMarketplaceItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<MarketplaceItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MarketplaceItem>> create(Ref ref) {
    return myMarketplaceItems(ref);
  }
}

String _$myMarketplaceItemsHash() =>
    r'b0a66579d9630d63da2b56a502987b6cb3a1ebcb';

@ProviderFor(marketplaceItemDetails)
const marketplaceItemDetailsProvider = MarketplaceItemDetailsFamily._();

final class MarketplaceItemDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<MarketplaceItem>,
          MarketplaceItem,
          FutureOr<MarketplaceItem>
        >
    with $FutureModifier<MarketplaceItem>, $FutureProvider<MarketplaceItem> {
  const MarketplaceItemDetailsProvider._({
    required MarketplaceItemDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'marketplaceItemDetailsProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$marketplaceItemDetailsHash();

  @override
  String toString() {
    return r'marketplaceItemDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MarketplaceItem> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MarketplaceItem> create(Ref ref) {
    final argument = this.argument as int;
    return marketplaceItemDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketplaceItemDetailsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$marketplaceItemDetailsHash() =>
    r'0aa0d00ec55c04c99cdb0eb001fe5f50876e1f27';

final class MarketplaceItemDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MarketplaceItem>, int> {
  const MarketplaceItemDetailsFamily._()
    : super(
        retry: null,
        name: r'marketplaceItemDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  MarketplaceItemDetailsProvider call(int id) =>
      MarketplaceItemDetailsProvider._(argument: id, from: this);

  @override
  String toString() => r'marketplaceItemDetailsProvider';
}
