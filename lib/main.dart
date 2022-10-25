import 'package:flutter/material.dart';
import 'package:e_commerce/configs/theme.dart';
import 'package:e_commerce/presentation/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/cubits/cubits.dart';

import 'router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const HomeScreen(),
      ),
    );
  }
}
