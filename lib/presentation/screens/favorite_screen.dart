import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Text(
            "Favorite Screen",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
    );
  }
}
