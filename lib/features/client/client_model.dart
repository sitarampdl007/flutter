import 'package:json_annotation/json_annotation.dart';

part 'client_model.g.dart';

/// Model [ClientModel] : Model for taking delivery user
@JsonSerializable()
class ClientModel {
  String id;
  String name;
  String mobileNumber;
  String bio;
  String gender;
  String email;
  String profilePicture;

  ClientModel(this.id, this.name, this.mobileNumber, this.bio, this.gender,
      this.email, this.profilePicture);

  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClientModelToJson(this);
}

/// Model [ClientLocation] : Model for managing client location
@JsonSerializable()
class ClientLocation {
  String addressTitle;
  String addressDetail;
  DoubleLocation geolocation;

  ClientLocation(this.addressTitle, this.addressDetail, this.geolocation);

  factory ClientLocation.fromJson(Map<String, dynamic> json) =>
      _$ClientLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ClientLocationToJson(this);
}

/// Model [DoubleLocation] : Model for managing double location
@JsonSerializable()
class DoubleLocation {
  double latitude;
  double longitude;

  DoubleLocation(this.latitude, this.longitude);

  factory DoubleLocation.fromJson(Map<String, dynamic> json) =>
      _$DoubleLocationFromJson(json);

  Map<String, dynamic> toJson() => _$DoubleLocationToJson(this);
}
