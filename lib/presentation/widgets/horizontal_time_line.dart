import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Widget [HorizontalTimeLine] : The HorizontalTimeLine for adjusting delivery status flow
class HorizontalTimeLine extends StatelessWidget {
  final String deliveryStatus;

  const HorizontalTimeLine({Key key, this.deliveryStatus}) : super(key: key);

  Color _getPickingUpColor() {
    switch (deliveryStatus) {
      case "PICKINGUP":
        return LendenAppTheme.deactivatedText;
      case "INTRANSIT":
        return LendenAppTheme.greenColor;
      case "PAYMENT":
        return LendenAppTheme.greenColor;
      case "DELIVERED":
        return LendenAppTheme.greenColor;
      default:
        return LendenAppTheme.deactivatedText;
    }
  }

  Color _getDeliveryColor() {
    switch (deliveryStatus) {
      case "PICKINGUP":
        return LendenAppTheme.deactivatedText;
      case "INTRANSIT":
        return LendenAppTheme.greenColor;
      case "PAYMENT":
        return LendenAppTheme.greenColor;
      case "DELIVERED":
        return LendenAppTheme.deactivatedText;
      default:
        return LendenAppTheme.deactivatedText;
    }
  }

  Color _getPaymentColor() {
    switch (deliveryStatus) {
      case "PICKINGUP":
        return LendenAppTheme.deactivatedText;
      case "INTRANSIT":
        return LendenAppTheme.deactivatedText;
      case "PAYMENT":
        return LendenAppTheme.greenColor;
      case "DELIVERED":
        return LendenAppTheme.deactivatedText;
      default:
        return LendenAppTheme.deactivatedText;
    }
  }

// =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    ThemeData _themeConst = Theme.of(context);
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double _mHeight = _mediaQueryData.size.height;
    return Card(
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16.0, top: 10, bottom: 15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Picking Up",
                      textAlign: TextAlign.center,
                      style: _themeConst.textTheme.caption,
                    )),
                const Spacer(),
                Expanded(
                    flex: 1,
                    child: Text(
                      "In-Transit",
                      textAlign: TextAlign.center,
                      style: _themeConst.textTheme.caption,
                    )),
                const Spacer(),
                Expanded(
                    flex: 1,
                    child: Text(
                      "Delivery Finished",
                      textAlign: TextAlign.center,
                      style: _themeConst.textTheme.caption,
                    )),
              ],
            ),
            SizedBox(
              height: _mHeight * 0.010,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 1,
                  child: CircleAvatar(
                      backgroundColor: LendenAppTheme.greenColor,
                      child: Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Divider(
                    thickness: 3,
                    color: _getPickingUpColor(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                      backgroundColor: _getDeliveryColor(),
                      child: const Icon(
                        Icons.local_shipping,
                        color: Colors.white,
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Divider(
                    thickness: 3,
                    color: _getPaymentColor(),
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: CircleAvatar(
                      backgroundColor: LendenAppTheme.deactivatedText,
                      child: Icon(
                        Icons.assignment_turned_in,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
