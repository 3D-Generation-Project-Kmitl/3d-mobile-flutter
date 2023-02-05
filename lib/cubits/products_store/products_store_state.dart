part of 'products_store_cubit.dart';

abstract class ProductsStoreState {}

class ProductsStoreInitial extends ProductsStoreState {}

class ProductsStoreLoading extends ProductsStoreState {}

class ProductsStoreLoaded extends ProductsStoreState {
  final ProductsStore productsStore;

  ProductsStoreLoaded(this.productsStore);
}

class ProductsStoreFailure extends ProductsStoreState {
  final String errorMessage;

  ProductsStoreFailure(this.errorMessage);
}
