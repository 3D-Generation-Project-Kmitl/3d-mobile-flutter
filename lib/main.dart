import 'package:marketplace/presentation/screens/user/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/configs/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/cubits/cubits.dart';
import 'package:marketplace/utils/dio_client.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import './routes/app_router.dart';
import '.env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = STRIPE_PUBLISHABLE_KEY;
  await Stripe.instance.applySettings();
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
        BlocProvider(
          create: (context) => IdentityCubit(),
        ),
        BlocProvider<ProductsCubit>(
          create: (context) => ProductsCubit(),
        ),
        BlocProvider<CategoryCubit>(
          create: (context) => CategoryCubit(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<FavoriteCubit>(
          create: (context) => FavoriteCubit(),
        ),
        BlocProvider<StoreModelsCubit>(
          create: (context) => StoreModelsCubit(),
        ),
        BlocProvider<MyStoreProductCubit>(
          create: (context) => MyStoreProductCubit(),
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
