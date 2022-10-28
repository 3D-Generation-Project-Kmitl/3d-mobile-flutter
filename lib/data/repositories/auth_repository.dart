import 'package:dio/dio.dart';
import 'package:e_commerce/data/models/models.dart';
import 'package:e_commerce/utils/dio_client.dart';

class AuthRepository {
  Future<User> validateToken() async {
    try {
      final response = await DioClient().dio.post('/auth/validateToken');
      final data = BaseResponse.fromJson(response.data).data;
      final user = User.fromMap(data);
      return user;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await DioClient().dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = BaseResponse.fromJson(response.data).data;
      final user = User.fromMap(data);
      return user;
    } catch (e) {
      if (e is DioError) {
        throw e.response!.data;
      } else {
        throw e as Exception;
      }
    }
  }

  Future<User> register(String email, String password, String name) async {
    try {
      final response = await DioClient().dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'name': name,
      });
      final data = BaseResponse.fromJson(response.data).data;
      final user = User.fromMap(data);
      return user;
    } catch (e) {
      if (e is DioError) {
        throw e.response!.data;
      } else {
        throw e as Exception;
      }
    }
  }

  Future<String> logout() async {
    try {
      final response = await DioClient().dio.post('/auth/logout');
      final message = BaseResponse.fromJson(response.data).message;
      return message;
    } catch (e) {
      if (e is DioError) {
        throw e.response!.data;
      } else {
        throw e as Exception;
      }
    }
  }
}
