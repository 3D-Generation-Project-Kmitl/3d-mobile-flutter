import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/presentation/helpers/confirm_dialog.dart';

import '../../../routes/screens_routes.dart';
import '../../widgets/widgets.dart';

class FollowerScreen extends StatelessWidget {
  const FollowerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text("ผู้ติดตาม", style: Theme.of(context).textTheme.headline2),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<FollowCubit, FollowState>(
          builder: (context, state) {
            if (state is FollowLoaded) {
              return ListView.builder(
                itemCount: state.followers.length,
                itemBuilder: (context, index) {
                  final user = state.followers[index].follower;
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
