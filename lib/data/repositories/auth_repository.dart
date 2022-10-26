import 'package:dio/dio.dart';
import 'package:e_commerce/utils/dio_client.dart';

class AuthRepository {
  Future<String> login(String email, String password) async {
    try {
      final response = await DioClient().dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      if (e is DioError) {
        throw e.response!.data;
      } else {
        throw e as Exception;
      }
    }
  }
}
