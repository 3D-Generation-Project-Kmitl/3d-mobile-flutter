import 'dart:async';

import 'package:marketplace/routes/screens_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/cubits.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final identityCubit = context.read<IdentityCubit>();
    final authCubit = context.read<AuthCubit>();
    final cartCubit = context.read<CartCubit>();
    final favoriteCubit = context.read<FavoriteCubit>();
    final followCubit = context.read<FollowCubit>();

    //wait initial in main.dart
    Timer(const Duration(milliseconds: 1000), () async {
      authCubit.validateToken();
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is ValidateTokenSuccessState) {
                    userCubit.setUser(state.user);
                    identityCubit.getIdentity();
                    cartCubit.getCart();
                    favoriteCubit.getFavorite();
                    followCubit.getFollow();
                    if (state.user.isVerified) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, navigationRoute, (route) => false);
                    } else {
                      authCubit.resendOTP(state.user.email);
                      Navigator.pushNamed(context, otpRoute,
                          arguments: [state.user.email, "verify"]);
                    }
                  } else if (state is ValidateTokenFailureState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, navigationRoute, (route) => false);
                  }
                },
                child: const CircularProgressIndicator()),
          ),
        ));
  }
}
