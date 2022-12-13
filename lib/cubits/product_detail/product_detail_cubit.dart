import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';
part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(const ProductDetailState());

  final productRepository = ProductRepository();

  void setProductDetail(ProductDetail productDetail) {
    emit(state.copyWith(productDetail: productDetail));
  }

  void clearProductDetail() {
    emit(const ProductDetailState());
  }

  Future<void> getProductById(int id) async {
    try {
      //emit(ProductDetailLoading());
      final productDetail = await productRepository.getProductById(id);
      emit(ProductDetailLoaded(productDetail));
    } catch (e) {
      //emit(ProductDetailFailure(e.toString()));
    }
  }
}
