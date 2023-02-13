import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'my_store_product_state.dart';

class MyStoreProductCubit extends Cubit<MyStoreProductState> {
  MyStoreProductCubit() : super(MyStoreProductInitial());

  final ProductRepository productRepository = ProductRepository();

  Future<void> addProductToStore({
    required String name,
    required String details,
    required int price,
    required int categoryId,
    required int modelId,
  }) async {
    try {
      List<Product> products = [];
      if (state is MyStoreProductLoaded) {
        products = (state as MyStoreProductLoaded).products;
      }
      emit(MyStoreProductLoading());
      final product = await productRepository.createProduct(
          name: name,
          details: details,
          price: price,
          categoryId: categoryId,
          modelId: modelId);
      products.add(product);
      emit(MyStoreProductLoaded(products));
    } on String catch (e) {
      emit(MyStoreProductFailure(e));
    }
  }
}
