import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/status_helper.dart';
import '../../../features/logistic/logistic_provider.dart';
import '../../../features/order/order_model.dart';
import '../../../features/order/order_provider.dart';
import '../../widgets/start_pickup_dialog.dart';
import '../delivery_history/delivery_details_screen.dart';

/// [AssignListItem] : The AssignListItem has the particular assign item and card
class AssignListItem extends StatelessWidget {
  //VARS
  final OrderModel loadedOrder;

  //UI
  MediaQueryData _mediaQuery;
  ThemeData _themeConst;
  var _mHeight;

  AssignListItem({
    Key key,
    this.loadedOrder,
  }) : super(key: key);

  // =========================== UI Functions ===========================

  ///FUNC [_buildCardItem] : To build each item card
  Widget _buildCardItem(BuildContext ctx) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(ctx, DeliveryDetailsScreen.routeName, arguments: {
        'orderId': loadedOrder.orderDetails.orderId,
        'orderNo': loadedOrder.orderNumber,
        'vendorId': loadedOrder.vendorId,
        'clientId': loadedOrder.userId,
        'priority': loadedOrder.orderDetails.priority
      }),
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: OrderHelper.getColorForOrder(loadedOrder.state),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loadedOrder.orderNumber,
                      textAlign: TextAlign.start,
                      style: _themeConst.textTheme.headline6
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      OrderHelper.getStringForDelivery(loadedOrder.state),
                      textAlign: TextAlign.start,
                      style: _themeConst.textTheme.caption
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${loadedOrder.vendor.permanentAddress.tole}, ${loadedOrder.vendor.permanentAddress.district}",
                        textAlign: TextAlign.center,
                        style: _themeConst.textTheme.caption
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        loadedOrder.deliveryAddress == null
                            ? ""
                            : loadedOrder.deliveryAddress.addressTitle,
                        textAlign: TextAlign.center,
                        style: _themeConst.textTheme.caption
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// FUNC [_showPickupDialog] : Show pickup dialog
  Future<bool> _showPickupDialog(BuildContext sCtx) {
    return showDialog(
        context: sCtx,
        builder: (dCtx) => StartPickupDialog(
              buildContext: dCtx,
              mHeight: _mHeight,
              startPickup: () => _updateStatus(sCtx),
              themeConst: _themeConst,
            ));
  }

  Future<void> _updateStatus(BuildContext sCtx) async {
    try {
      final logisticHeaders = Provider.of<LogisticProvider>(sCtx, listen: false)
          .getLogisticsHeader();
      await Provider.of<OrderProvider>(sCtx, listen: false).updateOrderState(
          orderId: loadedOrder.orderDetails.orderId,
          updateState: "PICKINGUP",
          logiHeaders: logisticHeaders);
    } catch (error) {
      throw (error);
    }
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    _themeConst = Theme.of(context);
    _mHeight = _mediaQuery.size.height;

    return loadedOrder.state == "READYFORPICKUP"
        ? Dismissible(
            key: ValueKey(DateTime.now()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {},
            background: Container(
              color: LendenAppTheme.ratingColor,
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(top: 10, bottom: 15),
              padding: const EdgeInsets.only(right: 20),
            ),
            confirmDismiss: (direction) {
              return _showPickupDialog(context);
            },
            child: _buildCardItem(context))
        : _buildCardItem(context);
  }
}
