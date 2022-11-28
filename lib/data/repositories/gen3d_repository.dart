import 'package:dio/dio.dart';
import 'package:e_commerce/utils/dio_client.dart';

class Gen3DModelRepository {
  Future<void> gen3DModel(String filePath, String fileName,String userId) async {
    try {
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'userId': userId
      });

      final response =
          await DioClient().dio.post('/gen3DModel', data: formData);

      return;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
