import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lenden_delivery/core/api/api_list.dart';
import 'package:lenden_delivery/core/utilities/prefs_helper.dart';

enum Status {
  Online,
  Offline,
}

/// Provider [RiderProvider] : Provide all rider details and socket
class RiderProvider with ChangeNotifier {
  Status _userStatus = Status.Offline;
  String socketURL = APIList.socketURL + "/riderLocation";
  static const platform = const MethodChannel('com.lenden_delivery/native');

  Status get socketStatus {
    return _userStatus == null ? Status.Offline : _userStatus;
  }

  void changeSocketStatus(Status status) async {
    if (status == null) {
      return;
    } else if (status == Status.Online) {
      //connect to socket
      await startLocationUpdate();
    } else {
      //disconnect from socket
      await stopLocationUpdate();
    }
  }

  Future<String> checkLocationPermission() async {
    try {
      String result = await platform.invokeMethod('checkLocationService');
      return result;
    } catch (e) {
      print("error in starting tracking");
      print(e);
      throw e;
    }
  }

  Future<void> startLocationUpdate() async {
    try {
      if (_userStatus == Status.Online) {
        cancelAllUpdate();
      } else {
        String userID = PrefsHelper.getUserIdPrefs();
        String logisticsID = PrefsHelper.getLogisticsIdPrefs();
        String mobileNumber = PrefsHelper.getMobilePrefs();
        String username = PrefsHelper.getUsernamePrefs();
        String result = await platform
            .invokeMethod('startLocationService', <String, dynamic>{
          "userId": userID,
          "socketUrl": APIList.socketURL + "/riderLocation",
          "logisticsId": logisticsID,
          "username": username,
          "mobileNumber": mobileNumber,
        });
        print(result);
        if (result == "Started Posting") {
          _userStatus = Status.Online;
        }
      }
    } catch (e) {
      print("error in starting tracking");
      print(e);
      _userStatus = Status.Offline;
    }
  }

  Future<void> stopLocationUpdate() async {
    try {
      String result = await platform.invokeMethod('stopLocationService');
      print(result);
      if (result == "Stopped Posting") {
        _userStatus = Status.Offline;
        await cancelAllUpdate();
      }
    } catch (e) {
      print("error in stopped posting");
      print(e);
      _userStatus = Status.Online;
    }
  }

  Future<void> cancelAllUpdate() async {
    try {
      String result = await platform.invokeMethod('cancelOldWorker');
      print(result);
      if (result == "Cancelled Worker") {
        _userStatus = Status.Offline;
      }
    } catch (e) {
      print("error in stopped posting");
      print(e);
      _userStatus = Status.Online;
    }
  }
}
