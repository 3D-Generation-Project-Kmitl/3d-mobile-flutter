import 'package:dio/dio.dart';

BaseOptions _options = BaseOptions(
    baseUrl: 'http://192.168.0.104:8080/api',
    connectTimeout: 5000,
    receiveTimeout: 3000,
    responseType: ResponseType.plain);

Dio dio = Dio(_options);
