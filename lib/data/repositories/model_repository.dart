import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class ModelRepository {
  Future<List<Model>> getModels() async {
    try {
      final response = await DioClient().dio.get('/model');
      final data = BaseResponse.fromJson(response.data).data;
      final models = List<Model>.from(data.map((x) => Model.fromJson(x)));
      return models;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
