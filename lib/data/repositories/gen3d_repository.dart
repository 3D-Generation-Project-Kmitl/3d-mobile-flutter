import 'package:dio/dio.dart';
import 'package:e_commerce/utils/dio_client.dart';

class Gen3DModelRepository {
  Future<String> gen3DModel(String filePath, String fileName) async {
    try {
      var formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await Dio()
          .post('http://161.246.5.159:443/gen3DModel', data: formData);

      return response.data.toString();
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
