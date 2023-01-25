import 'package:flutter/material.dart';

import '../../core/utilities/prefs_helper.dart';
import 'logistic_model.dart';

/// Provider [LogisticProvider] : Provide logistics details
class LogisticProvider with ChangeNotifier {
  LogisticModel _logisticModel;

  /// FUNC [setLogiModel] : Set the logi model to prefs
  void setLogiModel() {
    Map<String, dynamic> logiData = PrefsHelper.getLogiPrefs();
    LogisticModel model = LogisticModel(
      logiId: logiData["logiId"],
      logiName: logiData["logiName"],
      logiEmail: logiData["logiEmail"],
      logiNumber: logiData["logiNumber"],
      logiProfilePic: logiData["logiProfilePic"],
    );
    _logisticModel = model;
  }

  /// FUNC [getLogisticsHeader] : Get logi headers with id
  Map<String, String> getLogisticsHeader() {
    return {"as": "${_logisticModel.logiId}:LOGISTIC"};
  }
}
