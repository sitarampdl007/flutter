import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lenden_delivery/core/theme/app_theme.dart';
import 'package:lenden_delivery/features/order/order_provider.dart';
import 'package:lenden_delivery/features/order_detail/order_detail_provider.dart';
import 'package:lenden_delivery/presentation/widgets/card_info_builder.dart';
import 'package:lenden_delivery/presentation/widgets/text_with_icon.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/assets.dart';

class DeliveryCancelledScreen extends StatelessWidget {
  final String orderId;
  DeliveryCancelledScreen(
    this.orderId,
  );

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ThemeData themeData = Theme.of(context);
    double height = mediaQuery.size.height;
    double width = mediaQuery.size.width;
    final cancelledOrder =
        Provider.of<OrderProvider>(context).findByOrderId(orderId);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: height * 0.25,
          padding: const EdgeInsets.all(10),
          child: Lottie.asset(
            AssetsSource.failureLottie,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          "Delivery Attempt Failure!",
          textAlign: TextAlign.center,
          style: themeData.textTheme.headline6,
        ),
        SizedBox(
          height: height * 0.015,
        ),
        Text(
          "You cannot further proceed this delivery until it is resolved.",
          textAlign: TextAlign.center,
          style: themeData.textTheme.caption.copyWith(fontSize: 14),
        ),
        SizedBox(
          height: height * 0.015,
        ),
        cancelledOrder.deliveryIssue == null
            ? Container()
            : CardInfoBuilder(
                description: Text(
                  "${cancelledOrder.deliveryIssue}",
                  style: themeData.textTheme.subtitle1.copyWith(
                    color: LendenAppTheme.grey,
                  ),
                ),
                title: "Issue",
                iconType: Icons.announcement_rounded),
        SizedBox(
          height: height * 0.015,
        ),
        cancelledOrder.deliveryFailureNote == null
            ? Container()
            : CardInfoBuilder(
                description: Text(
                  "${cancelledOrder.deliveryFailureNote}",
                  style: themeData.textTheme.subtitle1.copyWith(
                    color: LendenAppTheme.grey,
                  ),
                ),
                title: "Note",
                iconType: Icons.create),
        SizedBox(
          height: height * 0.015,
        ),
        cancelledOrder.updatedAt == null
            ? Container()
            : CardInfoBuilder(
                description: Text(
                  DateFormat.yMMMEd()
                      .add_jms()
                      .format(DateTime.parse(cancelledOrder.updatedAt)),
                  style: themeData.textTheme.subtitle1.copyWith(
                    color: LendenAppTheme.grey,
                  ),
                ),
                title: "Date",
                iconType: Icons.timer),
      ],
    );
  }
}
