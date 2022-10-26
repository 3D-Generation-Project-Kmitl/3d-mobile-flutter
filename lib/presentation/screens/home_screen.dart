import 'package:flutter/material.dart';
import 'package:e_commerce/utils/dio_client.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = "/home";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HomeScreen(),
    );
  }

  //get accesstoken
  Future<String> getAccessToken() async {
    try {
      final response = await DioClient().dio.post('/auth/getAccessToken');
      print(response.data);
      return response.data;
    } catch (e) {
      if (e is DioError) {
        print(e.response?.statusCode);
      } else {
        print(e);
      }
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
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
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Login Screen")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  getAccessToken();
                },
                child: Text("Get Access Token")),
          ],
        ))));
  }
}
