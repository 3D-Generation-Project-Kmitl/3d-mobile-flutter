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

  Future<Model> createModel(FormData formData) async {
    try {
      final response = await DioClient().dio.post('/model', data: formData);
      final data = BaseResponse.fromJson(response.data).data;
      final modelCreated = Model.fromJson(data);
      return modelCreated;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<Model> updateModel(int modelId, FormData formData) async {
    try {
      final response =
          await DioClient().dio.put('/model/$modelId', data: formData);
      final data = BaseResponse.fromJson(response.data).data;
      final modelUpdated = Model.fromJson(data);
      return modelUpdated;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<void> deleteModel(int modelId) async {
    try {
      await DioClient().dio.delete('/model/$modelId');
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
