import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:marketplace/constants/api.dart';

BaseOptions _options = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
    responseType: ResponseType.plain);

class DioClient {
  static final DioClient _instance = DioClient._internal();
  DioClient._internal();
  factory DioClient() => _instance;

  late Dio _dio;
  late CookieJar _cookieJar;
  late Directory _appDocDir;
  late String _appDocPath;

  Dio get dio => _dio;

  void init() async {
    _dio = Dio(_options);
    _appDocDir = await getApplicationDocumentsDirectory();
    _appDocPath = _appDocDir.path;
    _cookieJar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage('$_appDocPath/.cookies/'),
    );
    _dio.interceptors.add(CookieManager(_cookieJar));
  }
}
