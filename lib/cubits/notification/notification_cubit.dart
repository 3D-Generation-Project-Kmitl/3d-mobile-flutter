import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/routes/screens_routes.dart';
import '../../data/models/models.dart';
import '../../data/repositories/repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final notificationRepository = NotificationRepository();

  Future<void> getNotifications() async {
    try {
      emit(NotificationLoading());
      final notifications = await notificationRepository.getNotifications();
      emit(NotificationLoaded(notifications));
    } on String catch (e) {
      emit(NotificationFailure(e));
    }
  }

  Future<void> readNotification({required int notificationId}) async {
    try {
      if (state is NotificationLoaded) {
        final notifications = (state as NotificationLoaded).notifications;
        await notificationRepository.markAsRead(notificationId: notificationId);
        notifications
            .firstWhere((element) => element.notificationId == notificationId)
            .isRead = true;
        emit(NotificationLoaded(notifications));
      }
    } on String catch (e) {
      emit(NotificationFailure(e));
    }
  }

  void gotoScreenRoute(BuildContext context, int notificationId) {
    if (state is NotificationLoaded) {
      final notifications = (state as NotificationLoaded).notifications;
      final item = notifications
          .firstWhere((element) => element.notificationId == notificationId);
      String screenRoute = item.link.split('/').first;
      if (screenRoute == "product") {
        Navigator.pushNamed(context, productDetailRoute,
            arguments: int.parse(item.link.split('/').last));
      }
    }
  }

  bool isReadAll() {
    if (state is NotificationLoaded) {
      final notifications = (state as NotificationLoaded).notifications;
      return notifications.every((element) => element.isRead);
    }
    return false;
  }
}
