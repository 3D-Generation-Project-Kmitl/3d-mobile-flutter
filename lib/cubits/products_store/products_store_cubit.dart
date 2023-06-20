import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'products_store_state.dart';

class ProductsStoreCubit extends Cubit<ProductsStoreState> {
  ProductsStoreCubit() : super(ProductsStoreInitial());

  final productRepository = ProductRepository();

  Future<void> getProductsByStoreId(int id) async {
    try {
      emit(ProductsStoreLoading());
      final productsStore = await productRepository.getProductsByStoreId(id);
      emit(ProductsStoreLoaded(productsStore));
    } on String catch (e) {
      emit(ProductsStoreFailure(e));
    }
  }
}
