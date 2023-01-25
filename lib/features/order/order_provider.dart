import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lenden_delivery/core/network/api_manager.dart';
import 'package:lenden_delivery/core/services/service_locator.dart';

import '../../core/api/api_list.dart';
import '../../core/utilities/prefs_helper.dart';
import 'order_model.dart';

enum Sort { OldToNew, NewToOld }

/// Class [OrderList] : Containing all orders
class OrderList {
  List<OrderModel> orders;

  OrderList({@required this.orders});

  factory OrderList.fromJson(List<dynamic> json) {
    return OrderList(
        orders: json
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList());
  }
}

/// Provider [OrderProvider] : Provide orders and manage it
class OrderProvider with ChangeNotifier {
  final ApiManager _apiManager = locator<ApiManager>();

  // order list
  OrderList _orderList;

  // delivered history list
  OrderList _deliveredList;

  // history order list
  OrderList _historyOrderList;

  // sort type
  Sort _historySorting = Sort.NewToOld;

  /// FUNC [orderList] : return orders list
  OrderList get orderObject {
    return _orderList;
  }

  /// FUNC [orderList] : return orders list
  OrderList get deliveredObj {
    return _deliveredList;
  }

  /// FUNC [setOrdersNull] : set orders list null
  void setOrdersNull() {
    _orderList = null;
  }

  /// FUNC [orderList] : return orders list
  List<OrderModel> get orderList {
    return [..._orderList.orders];
  }

  /// FUNC [_deliveryList] : return history list
  List<OrderModel> get deliveredOrderList {
    return [..._deliveredList.orders];
  }

  /// FUNC [historyOrderList] : return history list
  List<OrderModel> get historyOrderList {
    return [..._historyOrderList.orders];
  }

  /// FUNC [toggleSorting] : Toggle sorting list
  void toggleSorting(Sort value) {
    _historySorting = value;
    notifyListeners();
  }

  /// FUNC [historySorting] : Get historySorting
  Sort get historySorting {
    return _historySorting;
  }

  // FUNC [historyOrderList] : return history list
  List<OrderModel> get ongoingOrderList {
    return _orderList.orders
        .where((order) =>
            (order.state != "READYFORPICKUP" && order.state != "DELIVERED"))
        .toList();
  }

  // FUNC [findTotalRecent] : total recent orders
  int findTotalRecent() {
    return _orderList.orders
        .where((order) => order.state == "READYFORPICKUP")
        .toList()
        .length;
  }

  // FUNC [finalTotalDelivered] : total recent orders
  int finalTotalDelivered() {
    return _deliveredList.orders.length;
  }

  // FUNC [findByOrderId] : Find order id
  OrderModel findByOrderId(String orderId) {
    return _orderList.orders
        .firstWhere((order) => order.orderDetails.orderId == orderId);
  }

  // FUNC [findByHistoryOrderId] : Find history order id
  OrderModel findByHistoryOrderId(String orderNo) {
    return _historyOrderList.orders
        .firstWhere((order) => order.orderNumber == orderNo);
  }

  // FUNC [fetchOrders] : Fetch the orders
  Future<void> fetchOrders(
      {@required Map<String, String> logiHeaders,
      @required String type}) async {
    try {
      final ordersResponse = await _apiManager.dio.get(
        type == "history" ? APIList.getAllHistory : APIList.getNewOrders,
        options: Options(headers: logiHeaders),
      );
      //print(ordersResponse.data);
      if (type == "recent") {
        final orderDeliveredResponse = await _apiManager.dio.get(
          APIList.getTodayDelivered,
          options: Options(headers: logiHeaders),
        );
        print(orderDeliveredResponse.data);
        OrderList deliveredListJson =
            OrderList.fromJson(orderDeliveredResponse.data);
        _deliveredList = deliveredListJson;
      }
      // Parsing
      OrderList orderListJson = OrderList.fromJson(ordersResponse.data);
      type == "history"
          ? _historyOrderList = orderListJson
          : _orderList = orderListJson;
      print("Success Fetch Orders");
      notifyListeners();
    } catch (error) {
      print("Error Fetch Orders");
      throw (error);
    }
  }

  // FUNC [updateOrderState] : Update Order State of provided order
  Future<void> updateOrderState({
    @required String orderId,
    @required String updateState,
    File deliveredImage,
    File customerSignature,
    @required Map<String, String> logiHeaders,
  }) async {
    try {
      final riderData = PrefsHelper.getUserPrefs();
      final riderUserId = riderData["userId"];
      String deliveredFileName, signFileName;
      if (deliveredImage != null) {
        deliveredFileName = deliveredImage.path.split('/').last;
      }
      if (customerSignature != null) {
        signFileName = customerSignature.path.split('/').last;
      }
      var postBody;
      switch (updateState) {
        case "PICKINGUP":
          postBody = {
            "userId": riderUserId,
            "orderId": orderId,
            "state": updateState,
          };
          break;
        case "INTRANSIT":
          postBody = {
            "userId": riderUserId,
            "orderId": orderId,
            "state": updateState,
          };
          break;
        case "DELIVERED":
          postBody = FormData.fromMap({
            "userId": riderUserId,
            "orderId": orderId,
            "state": updateState,
            if (deliveredImage != null)
              "deliveredImage": await MultipartFile.fromFile(
                  deliveredImage.path,
                  filename: deliveredFileName),
            if (customerSignature != null)
              "customerSignature": await MultipartFile.fromFile(
                  customerSignature.path,
                  filename: signFileName)
          });
          break;
      }

      final updateResponse = await _apiManager.dio.put(
        APIList.updateOrderState,
        options: Options(headers: logiHeaders),
        data: postBody,
      );
      // Update State
      OrderModel updateModel = _orderList.orders
          .firstWhere((order) => order.orderDetails.orderId == orderId);
      updateModel.state = updateState;
      // add to delivery list
      if (updateModel.state == "DELIVERED") {
        _deliveredList =
            _deliveredList == null ? OrderList(orders: []) : _deliveredList;
        final checkOrder = _deliveredList.orders
            .where((deliveryOrder) => deliveryOrder.id == orderId);
        if (checkOrder != null) {
          _deliveredList.orders.add(updateModel);
        }
      }
      // Parsing
      print("Success Orders Updated");
      notifyListeners();
    } catch (error) {
      print("Error Fetch Orders");
      print(error);
      throw (error);
    }
  }

  // FUNC [updateOrderState] : Update Order State of provided order
  Future<void> cancelOrderState({
    @required String orderId,
    @required String deliveryFailureNote,
    @required String deliveryIssue,
    @required Map<String, String> logiHeaders,
  }) async {
    try {
      final riderData = PrefsHelper.getUserPrefs();
      final riderUserId = riderData["userId"];
      final postBody = {
        "userId": riderUserId,
        "orderId": orderId,
        "state": "DELIVERY_FAILURE",
        "deliveryFailureNote": deliveryFailureNote,
        "Issue": deliveryIssue
      };

      final updateResponse = await _apiManager.dio.put(
        APIList.updateOrderState,
        data: postBody,
        options: Options(headers: logiHeaders),
      );
      // Update State
      OrderModel orderModel = _orderList.orders
          .firstWhere((order) => order.orderDetails.orderId == orderId);
      orderModel.state = "DELIVERY_FAILURE";
      orderModel.deliveryFailureNote = deliveryFailureNote;
      orderModel.deliveryIssue = deliveryIssue;
      // Parsing
      print("Success Orders Updated");
      notifyListeners();
    } catch (error) {
      print("Error Fetch Orders");
      throw (error);
    }
  }
}
