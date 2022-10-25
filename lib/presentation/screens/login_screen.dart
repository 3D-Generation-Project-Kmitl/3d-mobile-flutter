import 'package:flutter/material.dart';
import 'package:e_commerce/configs/size_config.dart';
import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/presentation/helpers/helpers.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Widget buildEmailFormField() {
      return TextFormField(
        controller: _emailController,
        validator: emailValidator,
        keyboardType: TextInputType.emailAddress,
        style: Theme.of(context).textTheme.headline5,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          hintText: "อีเมล",
          prefixIcon:
              Icon(Icons.email_outlined, color: Theme.of(context).primaryColor),
        ),
      );
    }

    Widget buildPasswordFormField() {
      return TextFormField(
        controller: _passwordController,
        validator: passwordValidator,
        style: Theme.of(context).textTheme.headline5,
        obscureText: true,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          hintText: "รหัสผ่าน",
          prefixIcon:
              Icon(Icons.lock_outline, color: Theme.of(context).primaryColor),
          //suffixIcon: const Icon(Icons.visibility_off),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _keyForm,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "ยินดีต้อนรับกลับ",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  "กรุณาเข้าสู่ระบบด้วยอีเมลและรหัสผ่านของคุณ",
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                buildEmailFormField(),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                buildPasswordFormField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "ลืมรหัสผ่าน?",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: primaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.01),
                SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(50),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                    ),
                    onPressed: () {
                      if (_keyForm.currentState!.validate()) {
                        print(_emailController.text);
                      }
                    },
                    child: const Text(
                      "เข้าสู่ระบบ",
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ยังไม่มีบัญชีผู้ใช้งาน?",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "สมัครสมาชิก",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
