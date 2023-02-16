import 'package:flutter/material.dart';

import '../../../configs/size_config.dart';
import '../../helpers/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  final _keyForm = GlobalKey<FormState>();

  bool isHiddenPassword = true;

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _passwordController.clear();
    _confirmPasswordController.clear();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    SizeConfig().init(context);
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordLoadingState) {
          //showLoadingDialog(context);
        } else if (state is ResetPasswordSuccessState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            loginRoute,
            (route) => false,
          );
        } else if (state is ResetPasswordFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
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
          child: Form(
            key: _keyForm,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "เปลี่ยนรหัสผ่าน",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  buildPasswordFormField(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  buildConfirmPasswordFormField(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  SizedBox(
                    width: double.infinity,
                    height: getProportionateScreenHeight(50),
                    child: ElevatedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_keyForm.currentState!.validate()) {
                          authCubit.resetPassword(
                            _passwordController.text,
                            widget.token,
                          );
                        }
                      },
                      child: const Text(
                        "ยืนยัน",
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

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: _passwordController,
      validator: passwordValidator,
      style: Theme.of(context).textTheme.headline5,
      obscureText: isHiddenPassword,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        labelText: "รหัสผ่านใหม่",
        suffixIcon: InkWell(
          onTap: _togglePasswordView,
          child: Icon(
            isHiddenPassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  Widget buildConfirmPasswordFormField() {
    return TextFormField(
      controller: _confirmPasswordController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณากรอกยืนยันรหัสผ่าน';
        }
        if (value != _passwordController.text) {
          return 'รหัสผ่านไม่ตรงกัน';
        }
        return null;
      },
      style: Theme.of(context).textTheme.headline5,
      obscureText: isHiddenPassword,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        labelText: "ยืนยันรหัสผ่าน",
        suffixIcon: InkWell(
          onTap: _togglePasswordView,
          child: Icon(
            isHiddenPassword ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }
}
