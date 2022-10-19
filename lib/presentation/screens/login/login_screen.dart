import 'package:flutter/material.dart';
import 'package:ar_ecommerce_flutter/configs/size_config.dart';
import 'package:ar_ecommerce_flutter/constants/colors.dart';
import 'widgets/body.dart';

class LoginScreen extends StatelessWidget {
  static String routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: Center(child: Body())),
    );
  }
}
