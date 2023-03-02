import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:marketplace/utils/dio_client.dart';
import 'package:marketplace/.env';

class Gen3DModelRepository {
  Future<String> gen3DModel(
      String filePath, Map<String, dynamic> reconstructionConfigs,List<Map<String,dynamic>?>? cameraParameter) async {
    print('filePath ' + filePath);
    try {
      var formData = FormData.fromMap({
        'raw_data': await MultipartFile.fromFile(filePath),
        'model_id': reconstructionConfigs['modelId'],
        'user_id': reconstructionConfigs['userId'],
        'object_detection': reconstructionConfigs['objectDetection'],
        'quality': reconstructionConfigs['quality'],
        'camera_parameter':json.encode(cameraParameter),

      });

      final response = await Dio()
          .post('http://ssh.opencloudai.com:443/gen3DModel', data: formData);

      return response.data.toString();
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
