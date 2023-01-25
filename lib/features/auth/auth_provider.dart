import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lenden_delivery/core/network/api_interceptor.dart';
import 'package:lenden_delivery/core/network/api_manager.dart';
import 'package:lenden_delivery/core/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/api_list.dart';
import '../../core/error/exceptions.dart';
import '../../core/utilities/prefs_helper.dart';

/// Provider [AuthProvider] : Provide tokens and check auths
class AuthProvider extends ChangeNotifier {
  final ApiManager _apiManager = locator<ApiManager>();
  String _authToken;
  DateTime _expiryDate;
  Timer _authTimer;

  /// FUNC [isAuth] : Check if user is authenticated
  bool get isAuth {
    return _authToken != null;
  }

  /// FUNC [token] : Get token of user
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _authToken != null) {
      return _authToken;
    }
    return null;
  }

  /// =============================== LOGIN FUNCTIONS =================================

  /// FUNC [authenticate] : Login user
  /// @username : rider user value
  /// @password : user password
  Future<void> authenticate(String username, String password) async {
    try {
      // =================== CHECK ============================
      final authCheckResponse = await _apiManager.dio.get(
        APIList.authCheckUrl + username,
      );
      final checkJson = authCheckResponse.data as Map<String, dynamic>;
      // =================== LOGIN ============================
      if (checkJson["message"] == "RIDER_USER_OF_LOGISTIC") {
        BaseOptions options = BaseOptions(
            baseUrl: APIList.baseUrl,
            connectTimeout: 10000,
            receiveTimeout: 10000,
            contentType: Headers.formUrlEncodedContentType,
            responseType: ResponseType.json);
        final loginDio = Dio(options);
        final authLoginResponse = await loginDio.post(
          APIList.authLoginUrl,
          data: {
            "username": username,
            "password": password,
            "grant_type": 'password',
            "client_id": 'lenden-app'
          },
        );
        final loginJson = authLoginResponse.data as Map<String, dynamic>;
        // =================== TOKENS ============================
        if (loginJson.containsKey("access_token") &&
            loginJson["access_token"] != null) {
          _authToken = loginJson["access_token"];
          _expiryDate =
              DateTime.now().add(Duration(seconds: loginJson["expires_in"]));
          await ApiInterceptor.saveKey(key: "user_token", value: _authToken);
          await ApiInterceptor.saveKey(
              key: "refresh_token", value: loginJson["refresh_token"]);
          // =================== USER DATA ============================
          final userResponse = await _apiManager.dio.get(
            APIList.userData,
            options: Options(headers: {
              "as": "SELF",
            }),
          );
          final Map<String, dynamic> userJson = userResponse.data;
          final logiResponse = await _apiManager.dio.get(
            APIList.associatedLogiId,
          );
          final Map<String, dynamic> logiJson = logiResponse.data;
          // =================== STORAGE ============================
          PrefsHelper.setUserPrefs(userJson, _expiryDate);
          PrefsHelper.setLogiPrefs(logiJson);
          // =================== AUTO LOGOUT ============================
          _autoLogout();
          notifyListeners();
        }
      }
    } on DioError catch (dioErr) {
      print("Http error found ${dioErr.response?.data}");
      final errorMsg = dioErr.response?.data;
      if (errorMsg != null && errorMsg is Map) {
        AuthResultStatus status;
        if (errorMsg.containsKey("message")) {
          status =
              AuthException.handleException(dioErr.response?.data["message"]);
        } else if (errorMsg.containsKey("error")) {
          status =
              AuthException.handleException(dioErr.response?.data["error"]);
        }
        String message = AuthException.generatedExceptionMessage(status);
        throw (message);
      }
      rethrow;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  /// FUNC [tryAutoLogin] : Try to Auto Login User
  Future<bool> tryAutoLogin() async {
    try {
      final prefs = PrefsHelper.checkPrefs();
      if (prefs) {
        final extractedData = PrefsHelper.getUserPrefs();
        final expiryDate = DateTime.parse(extractedData['expiryDate']);
        if (expiryDate.isBefore(DateTime.now())) {
          return false;
        }
        //initalize auto login
        _authToken = await ApiInterceptor.readKey(key: "user_token");
        _expiryDate = expiryDate;
        _autoLogout();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  /// =============================== LOGOUT FUNCTIONS =================================

  /// FUNC [_autoLogout] : Auto Logout User
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  /// FUNC [logout] : Logout the current user
  Future<void> logout() async {
    try {
      _authToken = null;
      _expiryDate = null;
      if (_authTimer != null) {
        _authTimer.cancel();
        _authTimer = null;
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await ApiInterceptor.secureStorage.deleteAll();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
