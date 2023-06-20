part of 'search_product_cubit.dart';

abstract class SearchProductsState {}

class SearchProductsInitial extends SearchProductsState {}

class SearchProductsLoading extends SearchProductsState {}

class SearchProductsLoaded extends SearchProductsState {
  final List<Product> products;

  SearchProductsLoaded(this.products);
}

class SearchProductsFailure extends SearchProductsState {
  final String errorMessage;

  SearchProductsFailure(this.errorMessage);
}
