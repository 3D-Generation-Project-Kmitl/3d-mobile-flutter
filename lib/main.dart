import 'package:flutter/material.dart';
import 'package:e_commerce/configs/theme.dart';
import 'package:e_commerce/presentation/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightAppTheme,
      home: const LoginScreen(),
    );
  }
}
