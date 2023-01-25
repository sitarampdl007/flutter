import 'package:flutter_config/flutter_config.dart';

class APIList {
  static String baseUrl = FlutterConfig.get("APP_BASE_URL");
  static String cssUrl = FlutterConfig.get("APP_CSS_URL");
  static String socketURL = FlutterConfig.get("APP_SOCKET_URL");

  static String authCheckUrl = "logistic/user/rider/";
  static String authLoginUrl =
      'auth/realms/lendenrealm/protocol/openid-connect/token';
  static String userData = 'users';
  static String associatedLogiId = 'logistic/partner';
  static String getUserDataById = 'logistic/user/detail?userId=';
  static String getUserDataByPhone = 'users/phoneNumber/';
  static String getVendorDataById = 'logistic/vendorprofile?vendorId=';
  static String privateImageUrl = 'users/file?fileUrl=';
  static String getLogiProfile = 'logistic/profile?logisticId=';
  static String getNewOrders = 'logistic/rider/order?page=nohistory';
  static String getAllHistory = 'logistic/rider/order?page=history';
  static String getTodayDelivered = 'logistic/rider/todaydeliveredorder';
  static String updateOrderState = 'logistic/rider/order';
  static String getOrderDetails = 'order/detail?orderId=';
  static String getDeliveryLocation = 'order/deliveryaddress/detail?addressId=';
}
