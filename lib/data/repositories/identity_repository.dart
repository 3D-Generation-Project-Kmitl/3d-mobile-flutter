import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class IdentityRepository {
  Future<Identity?> getIdentity() async {
    try {
      final response = await DioClient().dio.get('/identity');
      final data = BaseResponse.fromJson(response.data).data;
      try {
        final identity = Identity.fromJson(data);
        return identity;
      } catch (e) {
        return null;
      }
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<Identity> createIdentity(FormData formData) async {
    try {
      final response = await DioClient().dio.post('/identity', data: formData);
      final data = BaseResponse.fromJson(response.data).data;
      final identityCreated = Identity.fromJson(data);
      return identityCreated;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<Identity> updateIdentity(FormData formData) async {
    try {
      final response = await DioClient().dio.put('/identity', data: formData);
      final data = BaseResponse.fromJson(response.data).data;
      final identityUpdated = Identity.fromJson(data);
      return identityUpdated;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
