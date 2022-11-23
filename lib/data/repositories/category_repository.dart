import 'package:dio/dio.dart';
import 'package:e_commerce/data/models/models.dart';
import 'package:e_commerce/utils/dio_client.dart';

class CategoryRepository {
  Future<List<Category>> getCategories() async {
    try {
      final response = await DioClient().dio.get('/category/all');
      final data = BaseResponse.fromJson(response.data).data;
      final categories =
          List<Category>.from(data.map((x) => Category.fromJson(x)));
      return categories;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
