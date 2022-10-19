import 'package:flutter/material.dart';
import 'package:ar_ecommerce_flutter/constants/colors.dart';
import 'package:ar_ecommerce_flutter/constants/styles.dart';
import 'package:ar_ecommerce_flutter/configs/size_config.dart';

import './form.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "ยินดีต้อนรับ",
                style: headingStyle,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.02),
              Text(
                "กรุณาเข้าสู่ระบบด้วยอีเมลและรหัสผ่านของคุณ",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              LoginForm(),
              SizedBox(height: SizeConfig.screenHeight * 0.08),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "ยังไม่มีบัญชีผู้ใช้งาน?",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "สมัครสมาชิก",
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
