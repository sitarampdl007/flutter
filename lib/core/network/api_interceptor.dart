import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiInterceptor extends Interceptor {
  static final statusCodeUnauthorized = 401;

  final Function refreshSession;
  final Function getValidAccessToken;

  /// secure storage
  static FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final Dio dioInstance;

  ApiInterceptor({
    @required this.dioInstance,
    this.refreshSession,
    this.getValidAccessToken,
  });

  /// FUNC [readKey] : Help reading keys
  static Future<String> readKey({@required String key}) async {
    String rtn = '';
    try {
      rtn = await secureStorage.read(key: key);
    } catch (e) {
      rethrow;
    }
    return rtn;
  }

  /// FUNC [saveKey] : Help reading keys
  static Future<void> saveKey(
      {@required String key, @required var value}) async {
    try {
      await secureStorage.write(key: "user_token", value: value);
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await secureStorage.read(key: "user_token");
    if (token != null && token.isNotEmpty) {
      options.headers.putIfAbsent('Authorization', () => '$token');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
