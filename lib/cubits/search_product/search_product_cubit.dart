import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'search_product_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  SearchProductsCubit() : super(SearchProductsInitial());

  final ProductRepository productRepository = ProductRepository();

  Future searchProducts(String keyword) async {
    try {
      emit(SearchProductsLoading());
      final products = await productRepository.searchProducts(keyword);
      emit(SearchProductsLoaded(products));
    } on String catch (e) {
      emit(SearchProductsFailure(e));
    }
  }
}
