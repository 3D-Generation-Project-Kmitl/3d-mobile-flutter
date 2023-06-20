import 'package:dio/dio.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/dio_client.dart';

class NotificationRepository {
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await DioClient().dio.get('/notification');
      final data = BaseResponse.fromJson(response.data).data;
      final notifications = List<NotificationModel>.from(
          data.map((x) => NotificationModel.fromJson(x)));
      return notifications;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<void> markAsRead({required int notificationId}) async {
    try {
      await DioClient().dio.put('/notification/read/$notificationId');
    } on DioError catch (e) {
      throw e.message;
    }
  }
}
