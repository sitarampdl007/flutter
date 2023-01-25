import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/assets.dart';
import '../../core/utilities/intents_helper.dart';
import '../../features/order/order_model.dart';
import '../../features/vendor/vendor_model.dart';
import 'text_with_icon.dart';

///Widget [TimelineBuilder] : To build timeline info
class TimelineBuilder extends StatelessWidget {
  final VendorModel vendorModel;
  final String deliveryUserName;
  final String deliveryContact;
  final String deliveryLocation;

  const TimelineBuilder(
      {@required this.vendorModel,
      @required this.deliveryUserName,
      @required this.deliveryContact,
      @required this.deliveryLocation});

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 12, right: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: true,
            indicatorStyle: IndicatorStyle(
              width: 35,
              height: 35,
              padding: EdgeInsets.all(6),
              indicator: Image.asset(AssetsSource.pickupBox),
            ),
            endChild: TripItemDetail(
              title: vendorModel.name,
              address:
                  "${vendorModel.permanentAddress.tole}, ${vendorModel.permanentAddress.vdc}",
              location: Location("27.86565556", "84.54879879"),
              phone: vendorModel.mobileNumber,
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isLast: true,
            indicatorStyle: IndicatorStyle(
              width: 35,
              height: 35,
              padding: EdgeInsets.all(6),
              indicator: Image.asset(AssetsSource.deliveryTruck),
            ),
            endChild: TripItemDetail(
              title: deliveryUserName,
              address: deliveryLocation,
              location: Location("27.86565556", "84.54879879"),
              phone: deliveryContact,
            ),
          ),
        ],
      ),
    );
  }
}

class TripItemDetail extends StatelessWidget {
  const TripItemDetail({
    Key key,
    this.title,
    this.location,
    this.address,
    this.phone,
  }) : super(key: key);

  final String title;
  final Location location;
  final String phone;
  final String address;

  @override
  Widget build(BuildContext context) {
    ThemeData _themeConst = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: _themeConst.textTheme.headline5.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                TextWithIcon(
                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                  text: address,
                  icon: const Icon(
                    Icons.location_on,
                    color: LendenAppTheme.primary,
                    size: 20,
                  ),
                  textStyle: _themeConst.textTheme.subtitle2
                      .copyWith(color: LendenAppTheme.grey),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const CircleAvatar(
                child: Icon(Icons.call),
              ),
              onPressed: () {
                IntentsHelper.makePhoneCall(phone);
              },
            ),
          )
        ],
      ),
    );
  }
}
