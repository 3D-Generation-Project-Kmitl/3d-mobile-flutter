import 'package:flutter/material.dart';
import 'package:marketplace/presentation/screens/screens.dart';
import './screens_routes.dart';
import 'package:marketplace/data/models/models.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _route(const SplashScreen(), splashRoute);
      case navigationRoute:
        int? route = settings.arguments as int?;
        return _navigationRoute(
            const BottomNavigation(), navigationRoute, route);
      case loginRoute:
        return _route(const LoginScreen(), loginRoute);
      case registerRoute:
        return _route(const RegisterScreen(), registerRoute);
      case forgotPasswordRoute:
        return _route(const ForgotPasswordScreen(), forgotPasswordRoute);
      case otpRoute:
        String email = settings.arguments as String;
        return _route(OtpScreen(email: email), otpRoute);
      case resetPasswordRoute:
        String token = settings.arguments as String;
        return _route(ResetPasswordScreen(token: token), resetPasswordRoute);
      case homeRoute:
        return _route(const HomeScreen(), homeRoute);
      case searchRoute:
        return _route(const SearchScreen(), searchRoute);
      case favoriteRoute:
        return _route(const FavoriteScreen(), favoriteRoute);
      case notificationRoute:
        return _route(const NotificationScreen(), notificationRoute);
      case profileRoute:
        return _route(const ProfileScreen(), profileRoute);
      case cartRoute:
        return _route(const CartScreen(), cartRoute);
      case orderCompletedRoute:
        return _route(const OrderCompletedScreen(), orderCompletedRoute);
      case myOrdersRoute:
        return _route(const MyOrdersScreen(), myOrdersRoute);
      case orderDetailRoute:
        int id = settings.arguments as int;
        return _route(OrderDetailScreen(orderId: id), orderDetailRoute);
      case productDetailRoute:
        Product? product = settings.arguments as Product?;
        if (product != null) {
          return _route(
              ProductDetailScreen(product: product), productDetailRoute);
        } else {
          return _errorRoute();
        }
      case gen3DRoute:
        return _route(const CameraPage(), gen3DRoute);
      case customerModelRoute:
        return _route(const CustomerModelScreen(), customerModelRoute);
      default:
        return _errorRoute();
    }
  }

  static Route _route(Widget screen, String routeName) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => screen,
    );
  }

  static Route _navigationRoute(Widget screen, String routeName, int? route) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => BottomNavigation(routeIndex: route),
    );
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Error'),
        ),
      ),
    );
  }
}
