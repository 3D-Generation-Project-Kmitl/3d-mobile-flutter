import 'package:flutter/material.dart';
import 'package:e_commerce/configs/size_config.dart';
import 'package:e_commerce/constants/colors.dart';
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
