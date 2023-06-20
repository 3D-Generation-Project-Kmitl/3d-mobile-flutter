part of 'cart_cubit.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Cart> carts;

  CartLoaded(this.carts);
}

class CartFailure extends CartState {
  final String errorMessage;

  CartFailure(this.errorMessage);
}
