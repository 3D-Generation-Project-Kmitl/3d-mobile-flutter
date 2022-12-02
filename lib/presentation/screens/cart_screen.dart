import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Text(
            "Cart Screen",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
