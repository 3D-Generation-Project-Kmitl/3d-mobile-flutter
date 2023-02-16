import 'package:flutter/material.dart';

class StoreWalletScreen extends StatelessWidget {
  const StoreWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title:
            Text("รายรับของฉัน", style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Text(
            "รายรับของฉัน",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
