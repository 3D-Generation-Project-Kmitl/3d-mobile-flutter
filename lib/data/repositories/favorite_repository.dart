import 'package:dio/dio.dart';
import 'package:e_commerce/data/models/models.dart';
import 'package:e_commerce/utils/dio_client.dart';

class FavoriteRepository {
  Future<List<Favorite>> getFavorite() async {
    try {
      final response = await DioClient().dio.get('/favorite');
      final data = BaseResponse.fromJson(response.data).data;
      final favorites =
          List<Favorite>.from(data.map((x) => Favorite.fromJson(x)));
      return favorites;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<Favorite> addToFavorite({required int productId}) async {
    try {
      final response = await DioClient().dio.post('/favorite', data: {
        'productId': productId,
      });
      final data = BaseResponse.fromJson(response.data).data;
      final favorite = Favorite.fromJson(data);
      return favorite;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<void> removeFromFavorite({required int productId}) async {
    try {
      await DioClient().dio.delete('/favorite', data: {
        'productId': productId,
      });
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
