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
    final cartCubit = context.read<CartCubit>();
    final favoriteCubit = context.read<FavoriteCubit>();

    //wait initial in main.dart
    Timer(const Duration(milliseconds: 1000), () async {
      authCubit.validateToken();
    });

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: MultiBlocListener(listeners: [
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is ValidateTokenSuccessState) {
                    userCubit.setUser(state.user);
                    cartCubit.getCart();
                    favoriteCubit.getFavorite();
                    Navigator.pushNamedAndRemoveUntil(
                        context, navigationRoute, (route) => false);
                  } else if (state is ValidateTokenFailureState) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, navigationRoute, (route) => false);
                  }
                },
              ),
              BlocListener<FavoriteCubit, FavoriteState>(
                listener: (context, state) {
                  if (state is FavoriteLoaded) {
                    favoriteCubit.setFavorite(state.favoriteList);
                  }
                },
              ),
            ], child: const CircularProgressIndicator()),
          ),
        ));
  }
}
