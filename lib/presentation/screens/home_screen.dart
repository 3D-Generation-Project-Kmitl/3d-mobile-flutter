import 'package:e_commerce/cubits/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/user/user_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = "/home";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = BlocProvider.of<UserCubit>(context);
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Home Screen",
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
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text("Login"),
                        )
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
