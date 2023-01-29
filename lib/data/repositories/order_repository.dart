import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class OrderRepository {
  Future<List<Order>> getOrders() async {
    try {
      final response = await DioClient().dio.get('/order/myOrders');
      final data = BaseResponse.fromJson(response.data).data;
      final orders = List<Order>.from(data.map((x) => Order.fromJson(x)));
      return orders;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<OrderDetail> getOrderById(int id) async {
    try {
      final response = await DioClient().dio.get('/order/$id');
      final data = BaseResponse.fromJson(response.data).data;
      final order = OrderDetail.fromJson(data);
      return order;
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
