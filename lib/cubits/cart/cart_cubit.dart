import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  final CartRepository cartRepository = CartRepository();

  void setCart(List<Cart> carts) {
    emit(state.copyWith(carts: carts));
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    state.carts?.forEach((cart) {
      totalPrice += cart.product.price;
    });
    return totalPrice;
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
      final cart = await cartRepository.addToCart(productId: productId);
      final List<Cart> carts = state.carts ?? [];
      carts.insert(0, cart);
      emit(CartLoaded(carts));
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> removeFromCart({required int productId}) async {
    try {
      await cartRepository.removeFromCart(productId: productId);
      final List<Cart> carts = state.carts ?? [];
      carts.removeWhere((element) => element.productId == productId);
      //emit(CartState(carts: carts));
      emit(CartLoaded(carts));
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }
}
