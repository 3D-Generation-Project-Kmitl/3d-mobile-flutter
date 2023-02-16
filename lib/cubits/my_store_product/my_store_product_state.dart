part of 'my_store_product_cubit.dart';

abstract class MyStoreProductState {}

class MyStoreProductInitial extends MyStoreProductState {}

class MyStoreProductLoading extends MyStoreProductState {}

class MyStoreProductLoaded extends MyStoreProductState {
  final List<Product> products;

  MyStoreProductLoaded(this.products);
}

class MyStoreProductFailure extends MyStoreProductState {
  final String errorMessage;

  MyStoreProductFailure(this.errorMessage);
}
