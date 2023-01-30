import 'package:marketplace/routes/screens_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:marketplace/cubits/cubits.dart';

import '../../../configs/size_config.dart';
import '../../widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 20,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.storefront,
              size: 27,
            ),
          ),
          title: Text("โปรไฟล์", style: Theme.of(context).textTheme.headline2),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, settingRoute);
              },
              icon: Icon(
                Icons.settings_outlined,
                color: Theme.of(context).primaryColor,
                size: 27,
              ),
            ),
            const CartButton(),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Column(
              children: [
                BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    //final user = state.user;
                    if (state is UserLoaded) {
                      final user = state.user;
                      return Column(
                        children: [
                          Row(
                            children: [
                              ImageCard(imageURL: user.picture ?? ""),
                              SizedBox(width: SizeConfig.screenWidth * 0.05),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  SizedBox(
                                      height: SizeConfig.screenHeight * 0.005),
                                  Text(
                                    user.email,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.01,
                          ),
                          Divider(
                            color: Colors.grey.withOpacity(0.2),
                            thickness: 0.5,
                            height: 20,
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
                                Navigator.pushNamed(context, myOrdersRoute);
                              },
                              title: Text(
                                "รายการสั่งซื้อของฉัน",
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
                                Navigator.pushNamed(
                                    context, customerModelRoute);
                              },
                              title: Text(
                                "โมเดล 3 มิติของฉัน",
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
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                radius: 25.0,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, loginRoute);
                                },
                                child: Text(
                                  "เข้าสู่ระบบ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, registerRoute);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  //outline
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.4,
                                  ),
                                ),
                                child: Text(
                                  "ลงทะเบียน",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        )));
  }
}
