import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';

import '../../../configs/size_config.dart';
import '../../../routes/screens_routes.dart';

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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 8,
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: 4),
                      onTap: () {
                        Navigator.pushNamed(context, editProfileRoute);
                      },
                      title: Text(
                        "แก้ไขโปรไฟล์ผู้ใช้",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 8,
                    child: ListTile(
                      dense: true,
                      visualDensity: const VisualDensity(vertical: 4),
                      onTap: () {
                        Navigator.pushNamed(context, changePasswordRoute);
                      },
                      title: Text(
                        "เปลี่ยนรหัสผ่าน",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
