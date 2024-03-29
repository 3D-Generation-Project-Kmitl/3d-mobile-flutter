import 'package:camera/camera.dart';
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
        List<dynamic> args = settings.arguments as List<dynamic>;
        return _route(
            OtpScreen(
              email: args[0] as String,
              type: args[1] as String,
            ),
            otpRoute);
      case resetPasswordRoute:
        String token = settings.arguments as String;
        return _route(ResetPasswordScreen(token: token), resetPasswordRoute);
      case homeRoute:
        return _route(const HomeScreen(), homeRoute);
      case searchRoute:
        String? keyword = settings.arguments as String?;
        return _route(SearchScreen(keyword: keyword ?? ''), searchRoute);
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
      case viewModelRoute:
        Model model = settings.arguments as Model;
        return _route(ViewModelScreen(model: model), viewModelRoute);
      case productDetailRoute:
        int productId = settings.arguments as int;
        return _route(
            ProductDetailScreen(productId: productId), productDetailRoute);
      case customerModelRoute:
        return _route(const CustomerModelScreen(), customerModelRoute);
      case settingRoute:
        return _route(const SettingScreen(), settingRoute);
      case searchResultRoute:
        String keyword = settings.arguments as String;
        return _route(SearchResultScreen(keyword: keyword), searchResultRoute);
      case changePasswordRoute:
        return _route(const ChangePasswordScreen(), changePasswordRoute);
      case editProfileRoute:
        return _route(const EditProfileScreen(), editProfileRoute);
      case identityRoute:
        return _route(const IdentityScreen(), identityRoute);
      case storeRoute:
        return _route(const StoreScreen(), storeRoute);
      case productsStoreRoute:
        int id = settings.arguments as int;
        return _route(ProductsStoreScreen(storeId: id), productsStoreRoute);
      case storeModelRoute:
        return _route(const StoreModelScreen(), storeModelRoute);
      case storeViewModelRoute:
        Model model = settings.arguments as Model;
        return _route(StoreViewModelScreen(model: model), storeViewModelRoute);
      case storeProductRoute:
        return _route(const StoreProductScreen(), storeProductRoute);
      case storeAddProductRoute:
        Model model = settings.arguments as Model;
        return _route(
            StoreAddProductScreen(model: model), storeAddProductRoute);
      case storeEditProductRoute:
        Product product = settings.arguments as Product;
        return _route(
            StoreEditProductScreen(product: product), storeEditProductRoute);
      case storeWalletRoute:
        return _route(const StoreWalletScreen(), storeWalletRoute);
      case storeWithdrawRoute:
        return _route(const StoreWithdrawScreen(), storeWithdrawRoute);
      case followerRoute:
        return _route(const FollowerScreen(), followerRoute);
      case followingRoute:
        return _route(const FollowingScreen(), followingRoute);
      case reportRoute:
        ProductDetail product = settings.arguments as ProductDetail;
        return _route(ReportScreen(product: product), reportRoute);
      case reconCameraRoute:
        return _route(const CameraScreen(), reconCameraRoute);
      case reconImagePreviewRoute:
        List<dynamic> args = settings.arguments as List<dynamic>;
        //XFile previewImage = settings.arguments as XFile;
        return _route(
            ImageViewerScreen(
              previewImage: args[0] as XFile?,
              isShowAll: args[1] as bool,
            ),
            reconImagePreviewRoute);
      case reconGalleryRoute:
        return _route(const ImageGalleryScreen(), reconGalleryRoute);
      case reconConfigRoute:
        return _route(const ReconstructionConfigScreen(), reconConfigRoute);
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
