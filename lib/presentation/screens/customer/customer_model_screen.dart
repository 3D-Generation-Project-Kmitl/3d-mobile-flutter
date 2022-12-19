import 'package:e_commerce/routes/screens_routes.dart';
import 'package:flutter/material.dart';

import '../../../configs/size_config.dart';

class CustomerModelScreen extends StatelessWidget {
  const CustomerModelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("โมเดล 3 มิติของฉัน",
            style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Text(
            "ไม่มีโมเดล 3 มิติ",
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: getProportionateScreenHeight(50),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, gen3DRoute);
            },
            child: const Text(
              "สร้างโมเดล 3 มิติ",
            ),
          ),
        ),
      ),
    );
  }
}
