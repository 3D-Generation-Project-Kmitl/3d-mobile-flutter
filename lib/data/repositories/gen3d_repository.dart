import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:marketplace/.env';

class Gen3DModelRepository {
  Future<String> gen3DModel(
      String filePath,
      Map<String, dynamic> reconstructionConfigs,
      List<Map<String, dynamic>?>? cameraParameterList) async {
    try {
      var formData = FormData.fromMap({
        'raw_data': await MultipartFile.fromFile(filePath),
        'model_id': reconstructionConfigs['modelId'],
        'user_id': reconstructionConfigs['userId'],
        'object_detection': reconstructionConfigs['objectDetection'],
        'quality': reconstructionConfigs['quality'],
        'google_ARCore': reconstructionConfigs['googleARCore'],
        // 'camera_parameter_list':json.encode(cameraParameterList),
        'camera_parameter_list': null,
      });

      final response = await Dio()
          .post('$FLASK_URL/gen3DModel', data: formData);

      return response.data.toString();
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
