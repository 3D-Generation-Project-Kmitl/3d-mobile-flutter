import 'package:dio/dio.dart';
import 'package:e_commerce/data/models/models.dart';
import 'package:e_commerce/utils/dio_client.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    try {
      final response = await DioClient().dio.get('/product/all');
      final data = BaseResponse.fromJson(response.data).data;
      final products = List<Product>.from(data.map((x) => Product.fromJson(x)));
      return products;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
