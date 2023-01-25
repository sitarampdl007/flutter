import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Helper Class [PrefsHelper] : Helper class for managing shared preferences
class PrefsHelper {
  static SharedPreferences prefs;

  /// FUNC [initializePrefs] : Initialize the prefs
  static Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  /// FUNC [setLogiPrefs] : Set Logistic Prefs
  static void setLogiPrefs(Map<String, dynamic> logiJson) {
    final logiData = json.encode({
      "logiNumber": logiJson.containsKey("contactNumber")
          ? logiJson["contactNumber"]
          : "",
      "logiName": logiJson.containsKey("name") ? logiJson["name"] : "",
      "logiProfilePic": logiJson.containsKey("profilePicture")
          ? logiJson["profilePicture"]
          : "",
      "logiEmail": logiJson.containsKey("email") ? logiJson["email"] : "",
      "logiId": logiJson.containsKey("id") ? logiJson["id"] : "",
    });
    prefs.setString("logiData", logiData);
  }

  /// FUNC [setUserPrefs] : Set User Prefs
  static void setUserPrefs(Map<String, dynamic> userJson, DateTime expiryDate) {
    final userData = json.encode({
      "expiryDate": expiryDate.toIso8601String(),
      "mobileNumber": userJson["mobileNumber"],
      "username": userJson.containsKey("name") ? userJson["name"] : "",
      "profilePicture":
          userJson["profilePicture"] == null ? "" : userJson["profilePicture"],
      "imageId": userJson.containsKey("imageId") ? userJson["imageId"] : "",
      "userId": userJson.containsKey("id") ? userJson["id"] : "",
      "gender": userJson.containsKey("gender") ? userJson["gender"] : "",
      "bio": userJson.containsKey("bio") ? userJson["bio"] : "",
    });
    prefs.setString("userData", userData);
  }

  /// FUNC [getLogiPrefs] : Get Logi Prefs
  static Map<String, dynamic> getLogiPrefs() {
    final logiData = prefs.getString("logiData");
    return jsonDecode(logiData);
  }

  /// FUNC [getUserPrefs] : Get User Prefs
  static Map<String, dynamic> getUserPrefs() {
    final userData = prefs.getString("userData");
    return jsonDecode(userData);
  }

  /// FUNC [getUserPrefs] : Get User Id Prefs
  static String getUserIdPrefs() {
    final userData = prefs.getString("userData");
    final extractedData = jsonDecode(userData);
    return extractedData["userId"];
  }

  /// FUNC [getMobilePrefs] : Get User Id Prefs
  static String getMobilePrefs() {
    final userData = prefs.getString("userData");
    final extractedData = jsonDecode(userData);
    return extractedData["mobileNumber"];
  }

  /// FUNC [getUsernamePrefs] : Get User Id Prefs
  static String getUsernamePrefs() {
    final userData = prefs.getString("userData");
    final extractedData = jsonDecode(userData);
    return extractedData["username"];
  }

  /// FUNC [getLogisticsIdPrefs] : Get Logistics Id Prefs
  static String getLogisticsIdPrefs() {
    final logiData = getLogiPrefs();
    return logiData["logiId"];
  }

  /// FUNC [getProfilePicPrefs] : Get Profile Pic Prefs
  static String getProfilePicPrefs() {
    final profilePic = prefs.getString("profilePic");
    return profilePic;
  }

  /// FUNC [setProfilePicPrefs] : Set Profile Pic Prefs
  static void setProfilePicPrefs(String profilePicRes) {
    prefs.setString("profilePic", profilePicRes);
  }

  /// FUNC [checkPrefs] : Check Prefs available
  static bool checkPrefs() {
    return prefs.containsKey("userData");
  }
}
