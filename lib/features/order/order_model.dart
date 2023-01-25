import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../client/client_model.dart';
import '../vendor/vendor_model.dart';

part 'order_model.g.dart';

/// Model [OrderModel] : Model for order
@JsonSerializable()
class OrderModel with ChangeNotifier {
  String id;
  String orderNumber;
  String userId;
  String vendorId;
  String state;
  String contact;
  String orderedDate;
  String specialNote;
  String deliveredImage;
  String deliveryFailureNote;
  String deliveryIssue;
  OrderDetails orderDetails;
  LogisticUser logisticUser;
  Vendor vendor;
  DeliveryAddress deliveryAddress;
  User user;
  String rider;
  List<String> products;
  String updatedAt;

  OrderModel(
      this.id,
      this.orderNumber,
      this.userId,
      this.vendorId,
      this.state,
      this.contact,
      this.orderedDate,
      this.orderDetails,
      this.logisticUser,
      this.user,
      this.products,
      this.vendor,
      this.rider,
      this.updatedAt,
      this.deliveryAddress);

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}

/// Model [Location] : Model for Location
@JsonSerializable()
class Location {
  final String latitude;
  final String longitude;

  Location(this.latitude, this.longitude);
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

/// Model [Vendor] : Model for Vendor
@JsonSerializable()
class Vendor {
  final String vendorName;
  final PermanentAddress permanentAddress;
  final Location geolocation;

  Vendor(this.vendorName, this.permanentAddress, this.geolocation);
  factory Vendor.fromJson(Map<String, dynamic> json) => _$VendorFromJson(json);

  Map<String, dynamic> toJson() => _$VendorToJson(this);
}

/// Model [DeliverAddress] : Model for DeliverAddress
@JsonSerializable()
class DeliveryAddress {
  final String addressTitle;
  final String addressDetail;
  final DoubleLocation geolocation;

  DeliveryAddress(this.addressTitle, this.addressDetail, this.geolocation);
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      _$DeliveryAddressFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryAddressToJson(this);
}

/// Model [OrderDetails] : Model for OrderDetails
@JsonSerializable()
class OrderDetails {
  final String orderId;
  final double orderTotal;
  final double deliveryRate;
  final String priority;

  OrderDetails(this.orderId, this.orderTotal, this.deliveryRate, this.priority);

  factory OrderDetails.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsToJson(this);
}

/// Model [LogisticUser] : Model for LogisticUser
@JsonSerializable()
class LogisticUser {
  String userId;
  LogisticUser(this.userId);

  factory LogisticUser.fromJson(Map<String, dynamic> json) =>
      _$LogisticUserFromJson(json);

  Map<String, dynamic> toJson() => _$LogisticUserToJson(this);
}

/// Model [User] : Model for User
@JsonSerializable()
class User {
  String name;
  User(this.name);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
