part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<Cart>? carts;

  const CartState({
    this.carts,
  });

  CartState copyWith({List<Cart>? carts}) {
    return CartState(
      carts: carts ?? this.carts,
    );
  }

  @override
  List<Object?> get props => [carts];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Cart> cartList;

  const CartLoaded(this.cartList);
}

class CartFailure extends CartState {
  final String errorMessage;

  const CartFailure(this.errorMessage);
}
