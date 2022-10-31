import 'package:e_commerce/cubits/auth/auth_cubit.dart';
import 'package:e_commerce/routes/screens_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/user/user_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final authCubit = context.read<AuthCubit>();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Profile Screen",
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(
                height: 20,
              ),
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state.user == null) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, loginRoute);
                          },
                          child: const Text("Login"),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, registerRoute);
                          },
                          child: const Text("Register"),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Text(
                          "Welcome ${state.user!.name}",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            authCubit.logout();
                            userCubit.clearUser();
                          },
                          child: const Text("Logout"),
                        )
                      ],
                    );
                  }
                },
              )
            ],
          )),
        )));
  }
}
