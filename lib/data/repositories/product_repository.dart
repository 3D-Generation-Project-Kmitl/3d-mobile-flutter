import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

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

  Future<ProductDetail> getProductById(int id) async {
    try {
      final response = await DioClient().dio.get('/product/$id');
      final data = BaseResponse.fromJson(response.data).data;
      final product = ProductDetail.fromJson(data);
      return product;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<Product>> searchProducts(String keyword) async {
    try {
      final response =
          await DioClient().dio.get('/product/search?keyword=$keyword');
      final data = BaseResponse.fromJson(response.data).data;
      final products = List<Product>.from(data.map((x) => Product.fromJson(x)));
      return products;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<ProductsStore> getProductsByStoreId(int id) async {
    try {
      final response = await DioClient().dio.get('/product/store/$id');
      final data = BaseResponse.fromJson(response.data).data;
      final productsStore = ProductsStore.fromJson(data);
      return productsStore;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
