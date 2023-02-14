import 'package:dio/dio.dart';
import 'package:marketplace/utils/dio_client.dart';

class Gen3DModelRepository {
  Future<String> gen3DModel(
      String filePath, Map<String, dynamic> configs) async {
    try {
      var formData = FormData.fromMap({
        'images': await MultipartFile.fromFile(filePath),
        'removeBackground': configs['removeBackground'],
        'quality':configs['quality'],
      });

      final response = await Dio()
          .post('http://161.246.5.159:443/gen3DModel', data: formData);

      return response.data.toString();
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
