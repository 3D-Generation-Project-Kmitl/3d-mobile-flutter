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

  List<Product> getLatestProducts() {
    List<Product> products = [];
    if (state is SearchProductsLoaded) {
      products.addAll((state as SearchProductsLoaded).products);
      products.sort((a, b) => b.productId.compareTo(a.productId));
    }
    return products;
  }

  List<Product> getPopularProducts() {
    List<Product> products = [];
    if (state is SearchProductsLoaded) {
      products.addAll((state as SearchProductsLoaded).products);
      products.sort((a, b) => b.views.compareTo(a.views));
    }
    return products;
  }

  List<Product> getBestSellerProducts() {
    List<Product> products = [];
    if (state is SearchProductsLoaded) {
      products.addAll((state as SearchProductsLoaded).products);
      products.sort(
          (a, b) => b.count!.orderProduct.compareTo(a.count!.orderProduct));
    }
    print(products[0].count!.orderProduct);
    return products;
  }
}
