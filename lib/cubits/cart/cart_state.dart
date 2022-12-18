part of 'cart_cubit.dart';

// class CartState extends Equatable {
//   final List<Cart>? carts;

//   const CartState({
//     this.carts,
//   });

//   CartState copyWith({List<Cart>? carts}) {
//     return CartState(
//       carts: carts ?? this.carts,
//     );
//   }

//   @override
//   List<Object?> get props => [carts];
// }

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
