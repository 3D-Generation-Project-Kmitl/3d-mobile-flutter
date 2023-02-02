import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';

import '../../../configs/size_config.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String type;
  const OtpScreen({
    required this.email,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isFull = false;
  bool isReSendOTP = true;
  String otp = "";
  late Timer timer;
  int start = 60;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start == 0) {
          setState(() {
            timer.cancel();
          });
          isReSendOTP = true;
          start = 60;
        } else {
          setState(() {
            start--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    void reSendOTP() {
      if (isReSendOTP) {
        authCubit.resendOTP(widget.email);
        setState(() {
          isReSendOTP = false;
          startTimer();
        });
      }
    }

    SizeConfig().init(context);
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is CheckOTPLoadingState) {
          //showLoadingDialog(context);
        } else if (state is CheckOTPSuccessState) {
          Navigator.pop(context);
          if (widget.type == "verify") {
            authCubit.verifyUser(state.token);
            Navigator.pushNamedAndRemoveUntil(
              context,
              navigationRoute,
              (route) => false,
            );
          } else if (widget.type == "forgot") {
            Navigator.pushNamed(
              context,
              resetPasswordRoute,
              arguments: state.token,
            );
          }
        } else if (state is CheckOTPFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("รหัส OTP ไม่ถูกต้อง"),
            ),
          );
        }
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
                  fieldWidth: SizeConfig.screenWidth * 0.125,
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
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    String ref = "";
                    if (state is ResendOTPSuccessState) {
                      ref = state.message;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "รหัสอ้างอิง (Ref): $ref",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        isReSendOTP
                            ? TextButton(
                                onPressed: () {
                                  reSendOTP();
                                },
                                child: Text(
                                  "ส่งรหัสอีกครั้ง",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: primaryColor),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 14, 5, 14),
                                child: Text(
                                  "ส่งได้อีกครั้งใน $start วินาที",
                                  style: Theme.of(context).textTheme.subtitle1!,
                                ),
                              ),
                      ],
                    );
                  },
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
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
