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
    final IdentityCubit identityCubit = context.read<IdentityCubit>();
    final FollowCubit followCubit = context.read<FollowCubit>();

    if (followCubit.state is FollowInitial) {
      followCubit.getFollow();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 20,
          leading: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoaded) {
                return IconButton(
                  onPressed: () {
                    if (identityCubit.state is IdentityLoaded) {
                      final identity =
                          (identityCubit.state as IdentityLoaded).identity;
                      if (identity != null) {
                        if (identity.status == "APPROVED") {
                          Navigator.pushNamed(context, storeRoute);
                        } else {
                          Navigator.pushNamed(context, identityRoute);
                        }
                      } else {
                        Navigator.pushNamed(context, identityRoute);
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.storefront,
                    size: 27,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          title: Text("โปรไฟล์", style: Theme.of(context).textTheme.headline2),
          actions: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, settingRoute);
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 27,
                    ),
                  );
                }
                return const SizedBox();
              },
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
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, editProfileRoute);
                                },
                                child: ImageCard(
                                  imageURL: user.picture ?? "",
                                  radius: 46,
                                ),
                              ),
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
                                  SizedBox(
                                      height: SizeConfig.screenHeight * 0.01),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, followerRoute);
                                        },
                                        child: Text(
                                          "ผู้ติดตาม ${followCubit.state is FollowLoaded ? (followCubit.state as FollowLoaded).followers.length : 0}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                      Text(" | ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                              )),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, followingRoute);
                                        },
                                        child: Text(
                                          "กำลังติดตาม ${followCubit.state is FollowLoaded ? (followCubit.state as FollowLoaded).followings.length : 0}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  )
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
                          ),
                          _buildProfileCard(
                            context,
                            "รายการสั่งซื้อของฉัน",
                            () {
                              Navigator.pushNamed(context, myOrdersRoute);
                            },
                          ),
                          _buildProfileCard(
                            context,
                            "โมเดล 3 มิติของฉัน",
                            () {
                              Navigator.pushNamed(context, customerModelRoute);
                            },
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

  Widget _buildProfileCard(
      BuildContext context, String title, void Function()? onTap) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: 4),
        onTap: onTap,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
