import 'package:dio/dio.dart';
import 'package:marketplace/utils/dio_client.dart';

class Gen3DModelRepository {
  Future<String> gen3DModel(
      String filePath, Map<String, dynamic> reconstructionConfigs) async {
    try {
      var formData = FormData.fromMap({
        'raw_data': await MultipartFile.fromFile(filePath),
        'model_id': reconstructionConfigs['modelId'],
        'user_id': reconstructionConfigs['userId'],
        'object_detection': reconstructionConfigs['objectDetection'],
        'quality': reconstructionConfigs['quality'],
      });
      print('raw_data '+reconstructionConfigs['raw_data'].toString());
      print('modelId '+reconstructionConfigs['modelId'].toString());
      print('userId '+reconstructionConfigs['userId'].toString());
      print('objectDetection '+reconstructionConfigs['objectDetection'].toString());
      print('quality '+reconstructionConfigs['quality'].toString());

      final response = await Dio()
          .post('http://ssh.opencloudai.com:443/gen3DModel', data: formData);

      return response.data.toString();
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
