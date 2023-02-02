import 'package:flutter/material.dart';

import '../../../configs/size_config.dart';
import '../../helpers/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final authCubit = context.read<AuthCubit>();
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ForgotPasswordLoadingState) {
          //showLoadingDialog(context);
        } else if (state is ForgotPasswordSuccessState) {
          authCubit.resendOTP(_emailController.text);
          Navigator.pop(context);
          Navigator.pushNamed(
            context,
            otpRoute,
            arguments: [_emailController.text, "forgot"],
          );
        } else if (state is ForgotPasswordFailureState) {
          //  print(state.errorMessage);
          //showSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 50,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "ลืมรหัสผ่าน",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  Text(
                    "โปรดระบุบัญชีที่ต้องการเปลี่ยนรหัสผ่าน",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  buildEmailFormField(),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(50),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_keyForm.currentState!.validate()) {
                          authCubit.forgotPassword(_emailController.text);
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
      ),
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: _emailController,
      validator: emailValidator,
      keyboardType: TextInputType.emailAddress,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "อีเมล",
      ),
    );
  }
}
