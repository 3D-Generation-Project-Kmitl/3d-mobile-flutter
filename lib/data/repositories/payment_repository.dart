import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class PaymentRepository {
  Future<Payment> getPaymentIntent() async {
    try {
      final response = await DioClient().dio.post('/payment/getPaymentIntent');
      final data = BaseResponse.fromJson(response.data).data;
      final payment = Payment.fromJson(data);
      return payment;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
