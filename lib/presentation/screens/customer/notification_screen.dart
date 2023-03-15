import 'package:flutter/material.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/widgets.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationCubit notificationCubit =
        context.read<NotificationCubit>();

    if (notificationCubit.state is NotificationInitial) {
      notificationCubit.getNotifications();
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title:
            Text("การแจ้งเตือน", style: Theme.of(context).textTheme.headline2),
        actions: const [
          CartButton(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            notificationCubit.getNotifications();
          },
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded) {
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Text(
                        'ไม่มีการแจ้งเตือน',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: GestureDetector(
                        onTap: () {
                          context.read<NotificationCubit>().readNotification(
                                notificationId: notification.notificationId,
                              );
                          context.read<NotificationCubit>().gotoScreenRoute(
                              context, notification.notificationId);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: notification.isRead
                                ? Colors.white
                                : primaryLight,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            leading: roundedImageCard(
                              imageURL: notification.picture,
                              radius: 5,
                            ),
                            title: Text(
                              notification.title,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            subtitle: Text(
                              notification.description,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
