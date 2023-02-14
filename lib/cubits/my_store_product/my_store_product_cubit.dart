import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'my_store_product_state.dart';

class MyStoreProductCubit extends Cubit<MyStoreProductState> {
  MyStoreProductCubit() : super(MyStoreProductInitial());

  final ProductRepository productRepository = ProductRepository();

  Future<void> getMyProducts() async {
    try {
      emit(MyStoreProductLoading());
      final products = await productRepository.getMyProducts();
      emit(MyStoreProductLoaded(products));
    } on String catch (e) {
      emit(MyStoreProductFailure(e));
    }
  }

  List<Product> getProductByStatus(String status) {
    List<Product> products = [];
    if (state is MyStoreProductLoaded) {
      products = (state as MyStoreProductLoaded).products;
      products = products.where((element) => element.status == status).toList();
    }
    return products;
  }

  Future<void> addProductToStore({
    required String name,
    required String details,
    required int price,
    required int categoryId,
    required int modelId,
  }) async {
    try {
      late List<Product> products;
      if (state is MyStoreProductLoaded) {
        products = (state as MyStoreProductLoaded).products;
      } else {
        products = await productRepository.getMyProducts();
      }
      emit(MyStoreProductLoading());
      final product = await productRepository.createProduct(
          name: name,
          details: details,
          price: price,
          categoryId: categoryId,
          modelId: modelId);
      products.insert(0, product);
      emit(MyStoreProductLoaded(products));
    } on String catch (e) {
      emit(MyStoreProductFailure(e));
    }
  }

  Future<void> updateStatusProduct(int productId, String status) async {
    try {
      List<Product> products = [];
      if (state is MyStoreProductLoaded) {
        products = (state as MyStoreProductLoaded).products;
      }
      emit(MyStoreProductLoading());
      final product = await productRepository.updateStatusProduct(
          id: productId, status: status);
      products.firstWhere((element) => element.productId == productId).status =
          product.status;
      emit(MyStoreProductLoaded(products));
    } on String catch (e) {
      emit(MyStoreProductFailure(e));
    }
  }
}
