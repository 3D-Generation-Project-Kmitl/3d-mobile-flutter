import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("คำสั่งซื้อของฉัน",
            style: Theme.of(context).textTheme.headline2),
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
