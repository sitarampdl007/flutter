import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/order/order_provider.dart';
import '../../widgets/empty_order.dart';
import 'delivery_history_item_widget.dart';

class DeliveryHistoryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<OrderProvider>(context);
    final historySort = historyProvider.historySorting;
    final loadedOrders = historyProvider.historyOrderList;
    return loadedOrders.length == 0
        ? EmptyOrder()
        : ListView.builder(
            padding:
                const EdgeInsets.only(top: 6, bottom: 15, left: 10, right: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                value: historySort == Sort.OldToNew
                    ? loadedOrders[loadedOrders.length - index - 1]
                    : loadedOrders[index],
                child: DeliveryHistoryItem()),
            itemCount: loadedOrders.length,
          );
  }
}
