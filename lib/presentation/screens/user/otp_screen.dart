import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:flutter/material.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';

import '../../../configs/size_config.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isFull = false;
  String otp = "";
  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    SizeConfig().init(context);
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is CheckOTPLoadingState) {
          //showLoadingDialog(context);
        } else if (state is CheckOTPSuccessState) {
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            resetPasswordRoute,
            arguments: state.token,
          );
        } else if (state is CheckOTPFailureState) {}
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "ยืนยันตัวตน",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Text(
                  "ระบบได้ส่งรหัส OTP ให้คุณผ่านทางอีเมล",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  widget.email,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: borderColor,
                  focusedBorderColor: primaryColor,
                  fieldWidth: 45,
                  textStyle: Theme.of(context).textTheme.headline5,
                  showFieldAsBox: true,
                  onCodeChanged: (code) => {
                    setState(() {
                      isFull = false;
                    })
                  },
                  onSubmit: (String verificationCode) {
                    setState(() {
                      isFull = true;
                      otp = verificationCode;
                    });
                  }, // end onSubmit
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.05),
                SizedBox(
                  width: double.infinity,
                  height: getProportionateScreenHeight(50),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isFull) {
                        authCubit.checkOTP(widget.email, otp);
                      }
                    },
                    child: const Text(
                      "ดำเนินการต่อ",
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
