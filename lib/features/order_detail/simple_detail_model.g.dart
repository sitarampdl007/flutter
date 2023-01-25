// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleOrderModel _$SimpleOrderModelFromJson(Map<String, dynamic> json) {
  return SimpleOrderModel(
    json['id'] as String,
    json['orderNumber'] as String,
    json['userId'] as String,
    json['vendorId'] as String,
    (json['products'] as List)?.map((e) => e as String)?.toList(),
    json['state'] as String,
    json['deliveryAddress'] == null
        ? null
        : DeliveryAddress.fromJson(
            json['deliveryAddress'] as Map<String, dynamic>),
    json['contact'] as String,
    json['specialNote'] as String,
    json['orderedDate'] as String,
    json['logisticId'] as String,
    json['logisticUserId'] as String,
    json['deliveredImage'] as String,
    json['deliveryFailureNote'] as String,
    json['orderDetails'] == null
        ? null
        : SimpleOrderInformation.fromJson(
            json['orderDetails'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SimpleOrderModelToJson(SimpleOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'userId': instance.userId,
      'vendorId': instance.vendorId,
      'products': instance.products,
      'state': instance.state,
      'deliveryAddress': instance.deliveryAddress,
      'contact': instance.contact,
      'specialNote': instance.specialNote,
      'orderedDate': instance.orderedDate,
      'logisticId': instance.logisticId,
      'logisticUserId': instance.logisticUserId,
      'deliveredImage': instance.deliveredImage,
      'deliveryFailureNote': instance.deliveryFailureNote,
      'orderDetails': instance.orderDetails,
    };

SimpleOrderInformation _$SimpleOrderInformationFromJson(
    Map<String, dynamic> json) {
  return SimpleOrderInformation(
    json['id'] as String,
    json['orderId'] as String,
    (json['orderItems'] as List)
        ?.map((e) =>
            e == null ? null : OrderItems.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['offerDetails'] as List)?.map((e) => e as String)?.toList(),
    (json['orderTotal'] as num)?.toDouble(),
    (json['deliveryRate'] as num)?.toDouble(),
    json['priority'] as String,
    json['createdAt'] as String,
  );
}

Map<String, dynamic> _$SimpleOrderInformationToJson(
        SimpleOrderInformation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'orderItems': instance.orderItems,
      'offerDetails': instance.offerDetails,
      'orderTotal': instance.orderTotal,
      'deliveryRate': instance.deliveryRate,
      'priority': instance.priority,
      'createdAt': instance.createdAt,
    };

OrderItems _$OrderItemsFromJson(Map<String, dynamic> json) {
  return OrderItems(
    json['productId'] as String,
    json['productName'] as String,
    (json['pricePerUnit'] as num)?.toDouble(),
    json['productImage'] as String,
    json['measuringUnit'] as String,
    json['weight'] as String,
    (json['productUnit'] as num)?.toDouble(),
    (json['discount'] as num)?.toDouble(),
    (json['payAbleAmount'] as num)?.toDouble(),
    json['quantity'] as String,
    json['priority'] as String,
    json['commissionPercent'] as String,
  );
}

Map<String, dynamic> _$OrderItemsToJson(OrderItems instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'pricePerUnit': instance.pricePerUnit,
      'productImage': instance.productImage,
      'measuringUnit': instance.measuringUnit,
      'weight': instance.weight,
      'productUnit': instance.productUnit,
      'discount': instance.discount,
      'payAbleAmount': instance.payAbleAmount,
      'quantity': instance.quantity,
      'priority': instance.priority,
      'commissionPercent': instance.commissionPercent,
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
