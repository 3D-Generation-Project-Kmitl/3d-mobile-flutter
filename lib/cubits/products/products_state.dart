part of 'products_cubit.dart';

class ProductsState extends Equatable {
  final List<Product>? products;

  const ProductsState({
    this.products,
  });

  ProductsState copyWith({List<Product>? products}) {
    return ProductsState(
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [products];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> productList;

  const ProductsLoaded(this.productList);
}

class ProductsFailure extends ProductsState {
  final String errorMessage;

  const ProductsFailure(this.errorMessage);
}
