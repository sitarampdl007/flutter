import 'package:dio/dio.dart';

import './api_interceptor.dart';
import '../api/api_list.dart';

class ApiManager {
  final _connectTimeout = 8000;
  final _receiveTimeout = 5000;

  Dio dio;

  ApiManager() {
    BaseOptions options = BaseOptions(
        baseUrl: APIList.cssUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json);

    dio = Dio(options);
    dio.interceptors.add(
      ApiInterceptor(
        dioInstance: dio,
      ),
    );
  }
}
