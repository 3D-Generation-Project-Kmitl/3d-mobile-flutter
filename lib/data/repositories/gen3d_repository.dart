import 'package:dio/dio.dart';
import 'package:marketplace/utils/dio_client.dart';

class Gen3DModelRepository {
  Future<String> gen3DModel(
      String filePath, Map<String, dynamic> configs,int modelId,int userId) async {
    try {
      var formData = FormData.fromMap({
        'modelId':modelId,
        'userId':userId,
        'images': await MultipartFile.fromFile(filePath),
        'removeBackground': configs['removeBackground'],
        'quality':configs['quality'],
      });

      final response = await Dio()
          .post('http://ssh.opencloudai.com:443/gen3DModel', data: formData);

      return response.data.toString();
    } on DioError catch (e) {
      throw e.message;
    }
  }
} 
