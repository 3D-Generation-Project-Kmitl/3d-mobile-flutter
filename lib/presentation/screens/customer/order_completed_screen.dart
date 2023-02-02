import 'package:flutter/material.dart';
import 'package:marketplace/routes/screens_routes.dart';

import '../../../configs/size_config.dart';

class OrderCompletedScreen extends StatelessWidget {
  const OrderCompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "สำเร็จ",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 30),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.005),
                Image.asset(
                  "assets/images/order_completed.png",
                  width: getProportionateScreenWidth(250),
                  height: getProportionateScreenHeight(250),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                Text(
                  "คำสั่งซื้อของคุณสำเร็จแล้ว ",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(50),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, navigationRoute, (route) => false);
                    },
                    child: const Text(
                      "กลับหน้าหลัก",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
