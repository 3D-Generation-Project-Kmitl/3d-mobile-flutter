import 'package:flutter/material.dart';
import 'package:marketplace/configs/size_config.dart';
import 'package:marketplace/constants/colors.dart';
import 'package:marketplace/presentation/helpers/helpers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/routes/screens_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

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

    final authCubit = context.read<AuthCubit>();
    final userCubit = context.read<UserCubit>();
    final identityCubit = context.read<IdentityCubit>();
    final cartCubit = context.read<CartCubit>();
    final favoriteCubit = context.read<FavoriteCubit>();
    final followCubit = context.read<FollowCubit>();
    final notificationCubit = context.read<NotificationCubit>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoadingState) {
          //showLoadingDialog(context);
        } else if (state is LoginSuccessState) {
          userCubit.setUser(state.user);
          identityCubit.getIdentity();
          cartCubit.getCart();
          favoriteCubit.getFavorite();
          followCubit.getFollow();
          notificationCubit.getNotifications();
          if (state.user.isVerified) {
            Navigator.pushNamedAndRemoveUntil(
                context, navigationRoute, (route) => false);
          } else {
            authCubit.resendOTP(state.user.email);
            Navigator.pushNamed(context, otpRoute,
                arguments: [state.user.email, "verify"]);
          }
        } else if (state is LoginFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage == "UNAUTHORIZED"
                  ? "อีเมลหรือรหัสผ่านไม่ถูกต้อง"
                  : state.errorMessage),
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
              padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
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
                  SizedBox(height: SizeConfig.screenHeight * 0.015),
                  buildPasswordFormField(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, forgotPasswordRoute);
                        },
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
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_keyForm.currentState!.validate()) {
                          authCubit.login(
                              _emailController.text, _passwordController.text);
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
                        onPressed: () {
                          Navigator.pushNamed(context, registerRoute);
                        },
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
        ));
  }
}
