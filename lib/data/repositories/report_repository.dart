import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class ReportRepository {
  Future createReportProduct(int productId, String detail) async {
    try {
      final response = await DioClient().dio.post('/report', data: {
        'productId': productId,
        'detail': detail,
      });
      final data = BaseResponse.fromJson(response.data).data;
      return data;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
