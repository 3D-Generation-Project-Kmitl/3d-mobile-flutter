import 'package:flutter/material.dart';

import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/styles.dart';
import 'package:e_commerce/configs/size_config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(children: [
        buildEmailFormField(),
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        buildPasswordFormField(),
        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                "ลืมรหัสผ่าน",
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        SizedBox(
          width: double.infinity,
          height: getProportionateScreenHeight(56),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "เข้าสู่ระบบ",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

Widget buildEmailFormField() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 5, 10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "กรอกอีเมลของคุณ",
          suffixIcon: Icon(
            Icons.email_outlined,
            color: primaryColor,
          ),
        ),
      ),
    ),
  );
}

Widget buildPasswordFormField() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 5, 10),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "กรอกรหัสผ่านของคุณ",
          suffixIcon: Icon(
            Icons.lock_outline,
            color: primaryColor,
          ),
        ),
      ),
    ),
  );
}
