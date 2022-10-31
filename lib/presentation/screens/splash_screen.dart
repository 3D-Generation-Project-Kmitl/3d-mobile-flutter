import 'dart:async';

import 'package:e_commerce/routes/screens_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/cubits.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final authCubit = context.read<AuthCubit>();

    //wait initial in main.dart
    Timer(const Duration(milliseconds: 2000), () async {
      authCubit.validateToken();
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is ValidateTokenSuccessState) {
                userCubit.setUser(state.user);
                Navigator.pushNamedAndRemoveUntil(
                    context, navigationRoute, (route) => false);
              } else if (state is ValidateTokenFailureState) {
                Navigator.pushNamedAndRemoveUntil(
                    context, navigationRoute, (route) => false);
              }
            },
            builder: (context, state) {
              return const CircularProgressIndicator();
            },
          ),
        )));
  }
}
