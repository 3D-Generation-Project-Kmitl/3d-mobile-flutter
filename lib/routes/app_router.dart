import 'package:flutter/material.dart';
import 'package:e_commerce/presentation/screens/screens.dart';
import './screens_routes.dart';

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
      ),
    );
  }
}
