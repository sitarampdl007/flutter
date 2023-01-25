import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/order/order_model.dart';
import '../../../features/order/order_provider.dart';
import 'assign_list_item_widget.dart';

/// [AssignListView] : The AssignListView Widget showing list of assigned tasks
class AssignListView extends StatelessWidget {
  final String selectedOrderStatus;

  AssignListView({@required this.selectedOrderStatus});

  //  =========================== DUMMY DATA ===========================
  List<OrderModel> getOrderStatusList(BuildContext bCtx) {
    final providerObj = Provider.of<OrderProvider>(bCtx, listen: false);
    List<OrderModel> allOrderList =
        providerObj.orderObject == null ? [] : providerObj.orderList;
    List<OrderModel> allDeliveredList =
        providerObj.deliveredObj == null ? [] : providerObj.deliveredOrderList;
    switch (selectedOrderStatus) {
      case "READYFORPICKUP":
        return allOrderList
            .where((order) => order.state == "READYFORPICKUP")
            .toList();
      case "DELIVERED":
        return allDeliveredList;
      default:
        return allOrderList
            .where((order) => order.state == "READYFORPICKUP")
            .toList();
    }
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    final orderList = getOrderStatusList(context);
    return ListView.builder(
      key: ValueKey(DateTime.now()),
      physics: NeverScrollableScrollPhysics(),
      itemCount: orderList.length,
      itemBuilder: (ctx, index) => AssignListItem(
        loadedOrder: orderList[index],
      ),
    );
  }
}
