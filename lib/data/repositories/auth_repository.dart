import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class AuthRepository {
  Future<User> validateToken() async {
    try {
      final response = await DioClient().dio.post('/auth/validateToken');
      final data = BaseResponse.fromJson(response.data).data;
      final user = User.fromJson(data);
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
      final user = User.fromJson(data);
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
      final user = User.fromJson(data);
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

  Future<String> forgotPassword(String email) async {
    try {
      final response =
          await DioClient().dio.post('/auth/forgotPassword', data: {
        'email': email,
      });
      final String message = BaseResponse.fromJson(response.data).message;
      return message;
    } catch (e) {
      if (e is DioError) {
        throw e.response!.data;
      } else {
        throw e as Exception;
      }
    }
  }

  Future<String> resendOTP(String email) async {
    try {
      final response = await DioClient().dio.post('/auth/resendOTP', data: {
        'email': email,
      });
      final String message = BaseResponse.fromJson(response.data).message;
      return message;
    } catch (e) {
      if (e is DioError) {
        throw e.response!.data;
      } else {
        throw e as Exception;
      }
    }
  }

  Future<String> checkOTP(String email, String otp) async {
    try {
      final response = await DioClient().dio.post('/auth/checkOTP', data: {
        'email': email,
        'otp': otp,
      });
      final data = BaseResponse.fromJson(response.data).data;
      final token = Token.fromJson(data).token;
      return token;
    } catch (e) {
      if (e is DioError) {
        throw e.response!.data;
      } else {
        throw e as Exception;
      }
    }
  }

  Future<String> verifyUser(String token) async {
    try {
      final response = await DioClient().dio.post('/auth/verifyUser', data: {
        'token': token,
      });
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

  Future<String> forceUpdatePassword(String newPassword, String token) async {
    try {
      final response =
          await DioClient().dio.put('/auth/forceUpdatePassword', data: {
        'newPassword': newPassword,
        'token': token,
      });
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
