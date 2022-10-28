import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/cubits.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = "/";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = BlocProvider.of<UserCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);

    //wait initial in main.dart
    Timer(const Duration(milliseconds: 4000), () async {
      authCubit.validateToken();
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is ValidateTokenSuccessState) {
                userCubit.getUser(state.user);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              } else if (state is ValidateTokenFailureState) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false);
              }
            },
            builder: (context, state) {
              return const CircularProgressIndicator();
            },
          ),
        )));
  }
}
