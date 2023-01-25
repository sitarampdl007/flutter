import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/assets.dart';
import '../../../core/theme/status_helper.dart';
import '../../../features/order/order_model.dart';
import '../../widgets/text_with_icon.dart';
import 'delivery_details_screen.dart';

class DeliveryHistoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedOrder = Provider.of<OrderModel>(context, listen: false);
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double mWidth = mediaQueryData.size.width;
    double mHeight = mediaQueryData.size.height;
    ThemeData themeData = Theme.of(context);
    return InkWell(
      key: ValueKey(selectedOrder.orderDetails.orderId),
      onTap: () {
        Navigator.pushNamed(context, DeliveryDetailsScreen.routeName,
            arguments: {
              'orderId': selectedOrder.orderDetails.orderId,
              'orderNo': selectedOrder.orderNumber,
              'vendorId': selectedOrder.vendorId,
              'clientId': selectedOrder.userId,
              'priority': selectedOrder.orderDetails.priority
            });
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${selectedOrder.orderNumber}",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  TextWithIcon(
                    text: OrderHelper.getStringForOrder(selectedOrder.state),
                    padding: const EdgeInsets.all(0),
                    textStyle: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w500),
                    icon: OrderHelper.getIconForOrder(
                        orderState: selectedOrder.state,
                        iconColor:
                            OrderHelper.getColorForOrder(selectedOrder.state)),
                  ),
                ],
              ),
              SizedBox(
                height: mHeight * 0.015,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      "${selectedOrder.vendor.permanentAddress.tole}, ${selectedOrder.vendor.permanentAddress.vdc}",
                      textAlign: TextAlign.center,
                      style: themeData.textTheme.headline6
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  const Expanded(
                    flex: 2,
                    child: Divider(
                      thickness: 3,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      AssetsSource.deliveryTruck,
                      height: 45,
                      width: 45,
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: Divider(
                      thickness: 3,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      selectedOrder.deliveryAddress == null
                          ? " "
                          : selectedOrder.deliveryAddress.addressTitle,
                      textAlign: TextAlign.center,
                      style: themeData.textTheme.headline6
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mHeight * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.jm().format(
                              DateTime.parse(selectedOrder.orderedDate)),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: LendenAppTheme.grey),
                        ),
                        Text(
                          DateFormat.yMMMEd().format(
                              DateTime.parse(selectedOrder.orderedDate)),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: LendenAppTheme.grey),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat.jm()
                              .format(DateTime.parse(selectedOrder.updatedAt)),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: LendenAppTheme.grey),
                        ),
                        Text(
                          DateFormat.yMMMEd()
                              .format(DateTime.parse(selectedOrder.updatedAt)),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: LendenAppTheme.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Text(
                "Rs. ${(selectedOrder.orderDetails.orderTotal / 100).toStringAsFixed(2)}",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: LendenAppTheme.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
