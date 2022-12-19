import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: Text(
            "ไม่มีการแจ้งเตือน",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
