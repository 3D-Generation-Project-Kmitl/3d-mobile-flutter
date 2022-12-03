part of 'product_detail_cubit.dart';

class ProductDetailState extends Equatable {
  final ProductDetail? productDetail;

  const ProductDetailState({
    this.productDetail,
  });

  ProductDetailState copyWith({ProductDetail? productDetail}) {
    return ProductDetailState(
      productDetail: productDetail ?? this.productDetail,
    );
  }

  @override
  get props => [productDetail];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  const ProductDetailLoaded(ProductDetail productDetail)
      : super(productDetail: productDetail);
}

class ProductDetailFailure extends ProductDetailState {
  final String message;

  const ProductDetailFailure(this.message) : super();
}
