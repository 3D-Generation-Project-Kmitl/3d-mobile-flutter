import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Text(
            "Notification Screen",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
