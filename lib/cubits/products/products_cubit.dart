import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(ProductsInitial());

  final ProductRepository productRepository = ProductRepository();

  Future getProducts() async {
    try {
      emit(ProductsLoading());
      final products = await productRepository.getProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsFailure(e.toString()));
    }
  }
}
