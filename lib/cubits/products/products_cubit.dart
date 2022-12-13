import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit() : super(const ProductsState());

  final ProductRepository productRepository = ProductRepository();

  void setProducts(List<Product> products) {
    emit(state.copyWith(products: products));
  }

  void clearProducts() {
    emit(const ProductsState());
  }

  Future<void> getProducts() async {
    try {
      emit(ProductsLoading());
      final products = await productRepository.getProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsFailure(e.toString()));
    }
  }
}
