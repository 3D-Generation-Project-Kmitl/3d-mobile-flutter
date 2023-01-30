import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class ModelRepository {
  Future<List<Model>> getModelsCustomer() async {
    try {
      final response = await DioClient().dio.get('/model/customer');
      final data = BaseResponse.fromJson(response.data).data;
      final models = List<Model>.from(data.map((x) => Model.fromJson(x)));
      return models;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<Model>> getModelsStore() async {
    try {
      final response =
          await DioClient().dio.get('/model/store?isProduct=false');
      final data = BaseResponse.fromJson(response.data).data;
      final models = List<Model>.from(data.map((x) => Model.fromJson(x)));
      return models;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<List<Model>> getModelsStoreProduct() async {
    try {
      final response = await DioClient().dio.get('/model/store?isProduct=true');
      final data = BaseResponse.fromJson(response.data).data;
      final models = List<Model>.from(data.map((x) => Model.fromJson(x)));
      return models;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
