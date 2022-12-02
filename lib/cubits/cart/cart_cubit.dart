import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  final CartRepository cartRepository = CartRepository();

  void setCarts(List<Cart> carts) {
    emit(state.copyWith(carts: carts));
  }

  void clearCarts() {
    emit(const CartState());
  }

  Future<void> getCart() async {
    try {
      emit(CartLoading());
      final carts = await cartRepository.getCart();
      emit(CartLoaded(carts));
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> addToCart({required int productId}) async {
    try {
      emit(CartLoading());
      final cart = await cartRepository.addToCart(productId: productId);
      final carts = state.carts!..add(cart);
      emit(CartLoaded(carts));
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> removeFromCart({required int productId}) async {
    try {
      emit(CartLoading());
      final cart = await cartRepository.removeFromCart(productId: productId);
      final carts = state.carts!..remove(cart);
      emit(CartLoaded(carts));
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }
}
