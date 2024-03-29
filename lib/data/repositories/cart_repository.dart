import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class CartRepository {
  Future<List<Cart>> getCart() async {
    try {
      final response = await DioClient().dio.get('/cart');
      final data = BaseResponse.fromJson(response.data).data;
      final carts = List<Cart>.from(data.map((x) => Cart.fromJson(x)));
      return carts;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<Cart> addToCart({required int productId}) async {
    try {
      final response = await DioClient().dio.post('/cart', data: {
        'productId': productId,
      });
      final data = BaseResponse.fromJson(response.data).data;
      final cart = Cart.fromJson(data);
      return cart;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<void> removeFromCart({required int productId}) async {
    try {
      await DioClient().dio.delete('/cart', data: {
        'productId': productId,
      });
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
