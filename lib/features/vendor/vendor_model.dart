import 'package:json_annotation/json_annotation.dart';

import '../order/order_model.dart' show Location;

part 'vendor_model.g.dart';

/// Model [VendorModel] : VendorModel with details
@JsonSerializable()
class VendorModel {
  String id;
  String name;
  String tagline;
  String email;
  String mobileNumber;
  String landlineNumber;
  PermanentAddress permanentAddress;
  Location geolocation;
  String profilePicture;

  VendorModel(
      this.id,
      this.name,
      this.tagline,
      this.email,
      this.mobileNumber,
      this.landlineNumber,
      this.permanentAddress,
      this.geolocation,
      this.profilePicture);

  factory VendorModel.fromJson(Map<String, dynamic> json) =>
      _$VendorModelFromJson(json);

  Map<String, dynamic> toJson() => _$VendorModelToJson(this);
}

/// Model [PermanentAddress] :PermanentAddress
@JsonSerializable()
class PermanentAddress {
  String zone;
  String district;
  String vdc;
  String ward;
  String tole;

  PermanentAddress(this.zone, this.district, this.vdc, this.ward, this.tole);

  factory PermanentAddress.fromJson(Map<String, dynamic> json) =>
      _$PermanentAddressFromJson(json);

  Map<String, dynamic> toJson() => _$PermanentAddressToJson(this);
}
