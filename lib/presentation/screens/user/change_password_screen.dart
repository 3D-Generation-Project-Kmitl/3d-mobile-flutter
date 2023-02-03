import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/size_config.dart';
import '../../../cubits/cubits.dart';
import '../../helpers/helpers.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController _oldPasswordController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  final _keyForm = GlobalKey<FormState>();

  bool isOldPasswordHidden = true;
  bool isHiddenPassword = true;

  void _togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  void _toggleOldPasswordView() {
    setState(() {
      isOldPasswordHidden = !isOldPasswordHidden;
    });
  }

  @override
  void initState() {
    _oldPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _oldPasswordController.dispose();
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
        if (state is ChangePasswordLoadingState) {
          //showLoadingDialog(context);
        } else if (state is ChangePasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("เปลี่ยนรหัสผ่านสำเร็จ"),
            ),
          );
          Navigator.pop(context);
        } else if (state is ChangePasswordFailureState) {
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
          title: Text(
            "เปลี่ยนรหัสผ่าน",
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 40, 25, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildOldPasswordFormField(),
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
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
                          authCubit.changePassword(
                            _oldPasswordController.text,
                            _passwordController.text,
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

  Widget buildOldPasswordFormField() {
    return TextFormField(
      controller: _oldPasswordController,
      validator: passwordValidator,
      style: Theme.of(context).textTheme.headline5,
      obscureText: isOldPasswordHidden,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        labelText: "รหัสผ่านเดิม",
        suffixIcon: InkWell(
          onTap: _toggleOldPasswordView,
          child: Icon(
            isOldPasswordHidden ? Icons.visibility_off : Icons.visibility,
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
