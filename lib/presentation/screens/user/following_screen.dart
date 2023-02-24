import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/presentation/helpers/confirm_dialog.dart';

import '../../../routes/screens_routes.dart';
import '../../widgets/widgets.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title:
            Text("กำลังติดตาม", style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<FollowCubit, FollowState>(
          builder: (context, state) {
            if (state is FollowLoaded) {
              return ListView.builder(
                itemCount: state.followings.length,
                itemBuilder: (context, index) {
                  final user = state.followings[index].followed;
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          productsStoreRoute,
                          arguments: user.userId,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          leading: ImageCard(
                            imageURL: user.picture ?? "",
                            radius: 40,
                          ),
                          title: Text(
                            user.name,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          trailing: SizedBox(
                            height: 40,
                            width: 110,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              onPressed: () {
                                if (context
                                    .read<FollowCubit>()
                                    .isFollowing(user.userId)) {
                                  showConfirmDialog(
                                    context,
                                    title: "คุณต้องการยกเลิกการติดตามหรือไม่",
                                    onConfirm: () {
                                      context
                                          .read<FollowCubit>()
                                          .unFollow(userId: user.userId);
                                    },
                                  );
                                } else {
                                  context
                                      .read<FollowCubit>()
                                      .follow(userId: user.userId);
                                }
                              },
                              child: Text(
                                context
                                        .read<FollowCubit>()
                                        .isFollowing(user.userId)
                                    ? "กำลังติดตาม"
                                    : "ติดตาม",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
