import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Home Screen",
                style: Theme.of(context).textTheme.headline1,
              ),
            ],
          )),
        )));
  }
}
