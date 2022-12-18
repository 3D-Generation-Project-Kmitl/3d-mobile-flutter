import 'package:bloc/bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';
part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit() : super(ProductDetailInitial());

  final productRepository = ProductRepository();

  Future getProductById(int id) async {
    try {
      emit(ProductDetailLoading());
      final productDetail = await productRepository.getProductById(id);
      emit(ProductDetailLoaded(productDetail));
    } catch (e) {
      emit(ProductDetailFailure(e.toString()));
    }
  }
}
