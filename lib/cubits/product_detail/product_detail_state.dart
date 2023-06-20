part of 'product_detail_cubit.dart';

abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductDetail productDetail;

  ProductDetailLoaded(this.productDetail);
}

class ProductDetailFailure extends ProductDetailState {
  final String message;

  ProductDetailFailure(this.message);
}
