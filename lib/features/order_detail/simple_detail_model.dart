import 'package:json_annotation/json_annotation.dart';
import 'package:lenden_delivery/features/client/client_model.dart';

part 'simple_detail_model.g.dart';

/// Model [SimpleOrderModel] : Simple Order Model
@JsonSerializable()
class SimpleOrderModel {
  String id;
  String orderNumber;
  String userId;
  String vendorId;
  List<String> products;
  String state;
  DeliveryAddress deliveryAddress;
  String contact;
  String specialNote;
  String orderedDate;
  String logisticId;
  String logisticUserId;
  String deliveredImage;
  String deliveryFailureNote;
  SimpleOrderInformation orderDetails;

  SimpleOrderModel(
      this.id,
      this.orderNumber,
      this.userId,
      this.vendorId,
      this.products,
      this.state,
      this.deliveryAddress,
      this.contact,
      this.specialNote,
      this.orderedDate,
      this.logisticId,
      this.logisticUserId,
      this.deliveredImage,
      this.deliveryFailureNote,
      this.orderDetails);

  factory SimpleOrderModel.fromJson(Map<String, dynamic> json) =>
      _$SimpleOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleOrderModelToJson(this);
}

/// Model [SimpleOrderInformation] : SimpleOrderInformation
@JsonSerializable()
class SimpleOrderInformation {
  String id;
  String orderId;
  List<OrderItems> orderItems;
  List<String> offerDetails;
  double orderTotal;
  double deliveryRate;
  String priority;
  String createdAt;

  SimpleOrderInformation(
      this.id,
      this.orderId,
      this.orderItems,
      this.offerDetails,
      this.orderTotal,
      this.deliveryRate,
      this.priority,
      this.createdAt);

  factory SimpleOrderInformation.fromJson(Map<String, dynamic> json) =>
      _$SimpleOrderInformationFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleOrderInformationToJson(this);
}

/// Model [OrderItems] : OrderItems
@JsonSerializable()
class OrderItems {
  String productId;
  String productName;
  double pricePerUnit;
  String productImage;
  String measuringUnit;
  String weight;
  double productUnit;
  double discount;
  double payAbleAmount;
  String quantity;
  String priority;
  String commissionPercent;

  OrderItems(
      this.productId,
      this.productName,
      this.pricePerUnit,
      this.productImage,
      this.measuringUnit,
      this.weight,
      this.productUnit,
      this.discount,
      this.payAbleAmount,
      this.quantity,
      this.priority,
      this.commissionPercent);

  factory OrderItems.fromJson(Map<String, dynamic> json) =>
      _$OrderItemsFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemsToJson(this);
}

/// Model [DeliveryAddress] : Model for DeliverAddress
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
