import 'package:flutter/foundation.dart';

/// Model [LogisticModel] : Model for logistics info
class LogisticModel {
  final String logiId;
  final String logiName;
  final String logiNumber;
  final String logiProfilePic;
  final String logiEmail;

  LogisticModel(
      {@required this.logiNumber,
      @required this.logiProfilePic,
      @required this.logiEmail,
      @required this.logiId,
      @required this.logiName});
}
