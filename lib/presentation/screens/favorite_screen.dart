import 'package:e_commerce/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Padding(
          padding: const EdgeInsets.only(top: 10),
          child:
              Text("รายการโปรด", style: Theme.of(context).textTheme.headline2),
        ),
        actions: const [
          CartButton(),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
