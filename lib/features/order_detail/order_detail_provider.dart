import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lenden_delivery/core/network/api_manager.dart';
import 'package:lenden_delivery/core/services/service_locator.dart';

import '../../core/api/api_list.dart';
import '../client/client_model.dart';
import '../vendor/vendor_model.dart';
import 'simple_detail_model.dart';

/// Model [FullOrderDetail] : Model for the full order details
class FullOrderDetail {
  SimpleOrderModel simpleOrderModel;
  VendorModel vendorModel;
  ClientModel clientModel;
  ClientLocation clientLocation;

  FullOrderDetail(
      {@required this.simpleOrderModel,
      @required this.vendorModel,
      @required this.clientModel,
      @required this.clientLocation});
}

/// Provider [OrderDetailProvider] : Provide all order details
class OrderDetailProvider with ChangeNotifier {
  final ApiManager _apiManager = locator<ApiManager>();

  /// FUNC [fetchOrderDetailsById] : Fetch all the orders by id
  Future<FullOrderDetail> fetchOrderDetailsById(
      {@required String orderId,
      @required String vendorId,
      @required String clientId}) async {
    try {
      final orderDetailResponse = await _apiManager.dio.get(
        APIList.getOrderDetails + orderId,
        options: Options(
          headers: {"as": "$vendorId:VENDOR"},
        ),
      );

      SimpleOrderModel simpleOrderModel =
          SimpleOrderModel.fromJson(orderDetailResponse.data);
      final vendorDetailResponse = await _apiManager.dio.get(
        APIList.getVendorDataById + vendorId,
      );
      VendorModel vendorModel = VendorModel.fromJson(vendorDetailResponse.data);

      final clientDetailResponse = await _apiManager.dio.get(
        APIList.getUserDataById + clientId,
      );
      ClientModel clientModel = ClientModel.fromJson(clientDetailResponse.data);

      ClientLocation clientLocation;
      if (simpleOrderModel.deliveryAddress != null) {
        clientLocation = ClientLocation(
            simpleOrderModel.deliveryAddress.addressTitle,
            simpleOrderModel.deliveryAddress.addressDetail,
            simpleOrderModel.deliveryAddress.geolocation);
      } else {
        clientLocation = ClientLocation("", "", null);
      }
      FullOrderDetail fullOrderDetail = FullOrderDetail(
          simpleOrderModel: simpleOrderModel,
          vendorModel: vendorModel,
          clientModel: clientModel,
          clientLocation: clientLocation);
      print("Success Fetch Orders");
      notifyListeners();
      return fullOrderDetail;
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
