import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class UserRepository {
  Future<User> getUser(int id) async {
    try {
      final response = await DioClient().dio.get('/users/$id');
      final data = BaseResponse.fromJson(response.data).data;
      final user = User.fromJson(data);
      return user;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<User> updateUser(FormData formData) async {
    try {
      final response = await DioClient().dio.put('/user', data: formData);
      final data = BaseResponse.fromJson(response.data).data;
      final userUpdated = User.fromJson(data);
      return userUpdated;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
