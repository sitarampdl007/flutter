import 'package:flutter/material.dart';

import '../../../core/theme/status_helper.dart';
import '../../../features/order/order_model.dart';
import 'home_ongoing_details_screen.dart';

class HomeOngoingItem extends StatelessWidget {
  //VARS
  final OrderModel loadedOrder;

  //UI
  MediaQueryData _mediaQuery;
  ThemeData _themeConst;
  var _mHeight, _mWidth;

  HomeOngoingItem({
    Key key,
    this.loadedOrder,
  }) : super(key: key);

  // =========================== UI Functions ===========================

  ///FUNC [_buildCardItem] : To build each item card
  Widget _buildCardItem(BuildContext ctx) {
    return InkWell(
      onTap: () => Navigator.pushNamed(ctx, HomeOngoingDetailsScreen.routeName,
          arguments: {
            'orderNo': loadedOrder.orderNumber,
            'orderId': loadedOrder.orderDetails.orderId,
            'orderState': loadedOrder.state,
            'vendorId': loadedOrder.vendorId,
            'clientId': loadedOrder.userId,
            'priority': loadedOrder.orderDetails.priority,
            'deliveryFailureIssue': loadedOrder.deliveryIssue,
            'deliveryFailureNote': loadedOrder.deliveryFailureNote,
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
                      style: _themeConst.textTheme.caption.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
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

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    _themeConst = Theme.of(context);
    _mHeight = _mediaQuery.size.height;
    _mWidth = _mediaQuery.size.width;
    return _buildCardItem(context);
  }
}
