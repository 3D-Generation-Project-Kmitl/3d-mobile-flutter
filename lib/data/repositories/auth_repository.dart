import 'package:e_commerce/utils/dio.dart';

class AuthRepository {
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      print(response.data);
      return response.data;
    } catch (e) {
      throw e as Exception;
    }
  }
}
