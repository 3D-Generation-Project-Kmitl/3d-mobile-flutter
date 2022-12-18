import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final CartRepository cartRepository = CartRepository();

  Future<void> getCart() async {
    try {
      emit(CartLoading());
      final carts = await cartRepository.getCart();
      emit(CartLoaded(carts));
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<bool> addToCart({required int productId}) async {
    try {
      if (state is CartLoaded) {
        final cart = await cartRepository.addToCart(productId: productId);
        final List<Cart> carts = (state as CartLoaded).carts;
        carts.insert(0, cart);
        emit(CartLoaded(carts));
      }
      return true;
    } catch (e) {
      emit(CartFailure(e.toString()));
      return false;
    }
  }

  Future<bool> removeFromCart({required int productId}) async {
    try {
      if (state is CartLoaded) {
        await cartRepository.removeFromCart(productId: productId);
        final List<Cart> carts = (state as CartLoaded).carts;
        carts.removeWhere((cart) => cart.productId == productId);
        emit(CartLoaded(carts));
      }
      return true;
    } catch (e) {
      emit(CartFailure(e.toString()));
      return false;
    }
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    if (state is CartLoaded) {
      final List<Cart> carts = (state as CartLoaded).carts;
      for (final cart in carts) {
        totalPrice += cart.product.price;
      }
    }
    return totalPrice;
  }
}
