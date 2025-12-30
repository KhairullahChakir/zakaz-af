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

String _$marketplaceItemsHash() => r'02f7ccf0730cba5570e788b3edd19e88eeab46b0';

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
        isAutoDispose: true,
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
    r'a837f33fc34a2ab6d41795d27b65190b507e106b';

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
         isAutoDispose: true,
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
    r'248cfb98df04c5ba2e062535cca6140e187bc4ad';

final class MarketplaceItemDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MarketplaceItem>, int> {
  const MarketplaceItemDetailsFamily._()
    : super(
        retry: null,
        name: r'marketplaceItemDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MarketplaceItemDetailsProvider call(int id) =>
      MarketplaceItemDetailsProvider._(argument: id, from: this);

  @override
  String toString() => r'marketplaceItemDetailsProvider';
}
