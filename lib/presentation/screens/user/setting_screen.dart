import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';

import '../../../configs/size_config.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final userCubit = context.read<UserCubit>();
    final authCubit = context.read<AuthCubit>();
    final cartCubit = context.read<CartCubit>();
    final favoriteCubit = context.read<FavoriteCubit>();
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 20,
          title: Text("ตั้งค่าบัญชี",
              style: Theme.of(context).textTheme.headline2),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(child: Container()),
        bottomNavigationBar:
            BlocBuilder<UserCubit, UserState>(builder: (context, state) {
          if (state is UserLoaded) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: getProportionateScreenHeight(50),
                child: ElevatedButton(
                  onPressed: () {
                    authCubit.logout();
                    userCubit.clearUser();
                    cartCubit.clearCart();
                    favoriteCubit.clearFavorite();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ออกจากระบบ",
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        }));
  }
}
