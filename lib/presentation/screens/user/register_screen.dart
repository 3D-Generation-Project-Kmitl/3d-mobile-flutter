import 'package:marketplace/routes/screens_routes.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/presentation/helpers/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/cubits.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
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
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    _confirmPasswordController.clear();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final authCubit = context.read<AuthCubit>();
    final userCubit = context.read<UserCubit>();
    final identityCubit = context.read<IdentityCubit>();
    final cartCubit = context.read<CartCubit>();
    final favoriteCubit = context.read<FavoriteCubit>();
    final followCubit = context.read<FollowCubit>();
    final notificationCubit = context.read<NotificationCubit>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoadingState) {
          //showLoadingDialog(context);
        } else if (state is RegisterSuccessState) {
          userCubit.setUser(state.user);
          identityCubit.getIdentity();
          cartCubit.getCart();
          favoriteCubit.getFavorite();
          followCubit.getFollow();
          notificationCubit.getNotifications();
          authCubit.resendOTP(state.user.email);
          Navigator.pushNamed(context, otpRoute,
              arguments: [state.user.email, "verify"]);
          // Navigator.pushNamedAndRemoveUntil(
          //     context, navigationRoute, (route) => false);
        } else if (state is RegisterFailureState) {
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
                padding: const EdgeInsets.fromLTRB(25, 5, 25, 25),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สมัครสมาชิก',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    buildNameFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    buildEmailFormField(),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
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
                            authCubit.register(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                            );
                          }
                        },
                        child: const Text(
                          'สมัครสมาชิก',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget buildNameFormField() {
    return TextFormField(
      controller: _nameController,
      validator: nameValidator,
      keyboardType: TextInputType.name,
      style: Theme.of(context).textTheme.headline5,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: const InputDecoration(
        labelText: "ชื่อ",
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

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: _passwordController,
      validator: passwordValidator,
      style: Theme.of(context).textTheme.headline5,
      obscureText: isHiddenPassword,
      textAlignVertical: TextAlignVertical.bottom,
      decoration: InputDecoration(
        labelText: "รหัสผ่าน",
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
