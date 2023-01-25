// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return OrderModel(
    json['id'] as String,
    json['orderNumber'] as String,
    json['userId'] as String,
    json['vendorId'] as String,
    json['state'] as String,
    json['contact'] as String,
    json['orderedDate'] as String,
    json['orderDetails'] == null
        ? null
        : OrderDetails.fromJson(json['orderDetails'] as Map<String, dynamic>),
    json['logisticUser'] == null
        ? null
        : LogisticUser.fromJson(json['logisticUser'] as Map<String, dynamic>),
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    (json['products'] as List)?.map((e) => e as String)?.toList(),
    json['vendor'] == null
        ? null
        : Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
    json['rider'] as String,
    json['updatedAt'] as String,
    json['deliveryAddress'] == null
        ? null
        : DeliveryAddress.fromJson(
            json['deliveryAddress'] as Map<String, dynamic>),
  )
    ..specialNote = json['specialNote'] as String
    ..deliveredImage = json['deliveredImage'] as String
    ..deliveryFailureNote = json['deliveryFailureNote'] as String
    ..deliveryIssue = json['deliveryIssue'] as String;
}

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'userId': instance.userId,
      'vendorId': instance.vendorId,
      'state': instance.state,
      'contact': instance.contact,
      'orderedDate': instance.orderedDate,
      'specialNote': instance.specialNote,
      'deliveredImage': instance.deliveredImage,
      'deliveryFailureNote': instance.deliveryFailureNote,
      'deliveryIssue': instance.deliveryIssue,
      'orderDetails': instance.orderDetails,
      'logisticUser': instance.logisticUser,
      'vendor': instance.vendor,
      'deliveryAddress': instance.deliveryAddress,
      'user': instance.user,
      'rider': instance.rider,
      'products': instance.products,
      'updatedAt': instance.updatedAt,
    };

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    json['latitude'] as String,
    json['longitude'] as String,
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

Vendor _$VendorFromJson(Map<String, dynamic> json) {
  return Vendor(
    json['vendorName'] as String,
    json['permanentAddress'] == null
        ? null
        : PermanentAddress.fromJson(
            json['permanentAddress'] as Map<String, dynamic>),
    json['geolocation'] == null
        ? null
        : Location.fromJson(json['geolocation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'vendorName': instance.vendorName,
      'permanentAddress': instance.permanentAddress,
      'geolocation': instance.geolocation,
    };

DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) {
  return DeliveryAddress(
    json['addressTitle'] as String,
    json['addressDetail'] as String,
    json['geolocation'] == null
        ? null
        : DoubleLocation.fromJson(json['geolocation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DeliveryAddressToJson(DeliveryAddress instance) =>
    <String, dynamic>{
      'addressTitle': instance.addressTitle,
      'addressDetail': instance.addressDetail,
      'geolocation': instance.geolocation,
    };

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) {
  return OrderDetails(
    json['orderId'] as String,
    (json['orderTotal'] as num)?.toDouble(),
    (json['deliveryRate'] as num)?.toDouble(),
    json['priority'] as String,
  );
}

Map<String, dynamic> _$OrderDetailsToJson(OrderDetails instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'orderTotal': instance.orderTotal,
      'deliveryRate': instance.deliveryRate,
      'priority': instance.priority,
    };

LogisticUser _$LogisticUserFromJson(Map<String, dynamic> json) {
  return LogisticUser(
    json['userId'] as String,
  );
}

Map<String, dynamic> _$LogisticUserToJson(LogisticUser instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['name'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'name': instance.name,
    };
