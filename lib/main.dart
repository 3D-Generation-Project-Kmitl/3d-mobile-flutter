import 'package:e_commerce/presentation/screens/splash_screen.dart';
import 'package:e_commerce/presentation/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/configs/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerce/cubits/cubits.dart';
import 'package:e_commerce/utils/dio_client.dart';

import 'router/app_router.dart';

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';


void main() {

  runApp(const MyApp());
  DioClient().init();


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
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        home: const SplashScreen(),
      ),
    );
  }

}

// Future<void> main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();

//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();

//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;

//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }
