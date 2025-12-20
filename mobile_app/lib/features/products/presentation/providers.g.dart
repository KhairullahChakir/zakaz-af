// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categories)
const categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  const CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'a9dc7f203c0752b6ef049187e7be9d2f99eabef1';

@ProviderFor(products)
const productsProvider = ProductsFamily._();

final class ProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ProductsProvider._({
    required ProductsFamily super.from,
    required ({
      int? categoryId,
      String? search,
      String? sortBy,
      String? sortOrder,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'productsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsHash();

  @override
  String toString() {
    return r'productsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument =
        this.argument
            as ({
              int? categoryId,
              String? search,
              String? sortBy,
              String? sortOrder,
            });
    return products(
      ref,
      categoryId: argument.categoryId,
      search: argument.search,
      sortBy: argument.sortBy,
      sortOrder: argument.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsHash() => r'b5ca6765b3f5dc910995ffd3acb59b1dd9d161fe';

final class ProductsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Product>>,
          ({int? categoryId, String? search, String? sortBy, String? sortOrder})
        > {
  const ProductsFamily._()
    : super(
        retry: null,
        name: r'productsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductsProvider call({
    int? categoryId,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) => ProductsProvider._(
    argument: (
      categoryId: categoryId,
      search: search,
      sortBy: sortBy,
      sortOrder: sortOrder,
    ),
    from: this,
  );

  @override
  String toString() => r'productsProvider';
}

@ProviderFor(productDetails)
const productDetailsProvider = ProductDetailsFamily._();

final class ProductDetailsProvider
    extends $FunctionalProvider<AsyncValue<Product>, Product, FutureOr<Product>>
    with $FutureModifier<Product>, $FutureProvider<Product> {
  const ProductDetailsProvider._({
    required ProductDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'productDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productDetailsHash();

  @override
  String toString() {
    return r'productDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Product> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Product> create(Ref ref) {
    final argument = this.argument as int;
    return productDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productDetailsHash() => r'c269fd27fa060b08bf9fe686d1cf1f2f6d122021';

final class ProductDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Product>, int> {
  const ProductDetailsFamily._()
    : super(
        retry: null,
        name: r'productDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProductDetailsProvider call(int id) =>
      ProductDetailsProvider._(argument: id, from: this);

  @override
  String toString() => r'productDetailsProvider';
}
