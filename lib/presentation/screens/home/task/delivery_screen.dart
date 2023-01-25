import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utilities/location_helper.dart';
import '../../../../features/client/client_model.dart';
import '../../../../features/order/order_model.dart';
import '../../../../features/order_detail/order_detail_provider.dart';
import '../../../widgets/card_info_builder.dart';
import '../../../widgets/product_detail_widget.dart';
import '../../../widgets/static_map_image.dart';
import '../../../widgets/task_buttons.dart';
import '../../../widgets/timeline_builder.dart';
import '../../map/map_screen.dart';

class DeliveryScreen extends StatefulWidget {
  final Function changeStatus;
  final FullOrderDetail loadedOrder;
  DeliveryScreen(this.loadedOrder, this.changeStatus);

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  //vars
  ThemeData _themeConst;
  var _mHeight, _mWidth;
  MediaQueryData _mediaQueryData;
  Future _loadMap;

  /// FUNC [_getLocationAndPreview] : Getting location of user and showing it to map
  Future<Map<String, dynamic>> _getLocationAndPreview() async {
    var userPosition = await LocationHelper.getUserLocation();
    Location userLocation = Location(
        userPosition.latitude.toString(), userPosition.longitude.toString());
    final locationMap = {
      "userLocation": userLocation,
      "staticImg": LocationHelper.getLocationPreviewImg(
          type: "UserDelivery",
          pickup: userLocation,
          dropOff: widget.loadedOrder.clientLocation == null
              ? null
              : widget.loadedOrder.clientLocation.geolocation)
    };
    userLocation = null;
    return locationMap;
  }

  @override
  void initState() {
    _loadMap = _getLocationAndPreview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _themeConst = Theme.of(context);
    _mediaQueryData = MediaQuery.of(context);
    _mHeight = _mediaQueryData.size.height;
    _mWidth = _mediaQueryData.size.width;
    return FutureBuilder(
        future: _loadMap,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Location userLocation = snapshot.data["userLocation"];
                        Navigator.pushNamed(context, MapScreen.routeName,
                            arguments: {
                              'mapType': "UserDelivery",
                              'from': userLocation,
                              'fromAddress': "Your Location",
                              'to':
                                  widget.loadedOrder.clientLocation.geolocation,
                              'toAddress':
                                  "${widget.loadedOrder.clientLocation.addressTitle}, ${widget.loadedOrder.clientLocation.addressDetail}",
                            });
                      },
                      child: StaticMapImage(
                        mHeight: _mHeight,
                        previewImageUrl: snapshot.data['staticImg'],
                      ),
                    ),
                    SizedBox(
                      height: _mHeight * 0.012,
                    ),
                    TimelineBuilder(
                      vendorModel: widget.loadedOrder.vendorModel,
                      deliveryContact:
                          widget.loadedOrder.simpleOrderModel.contact,
                      deliveryUserName: widget.loadedOrder.clientModel.name,
                      deliveryLocation:
                          widget.loadedOrder.clientLocation.addressTitle,
                    ),
                    SizedBox(
                      height: _mHeight * 0.012,
                    ),
                    CardInfoBuilder(
                        description: Text(
                          widget.loadedOrder.simpleOrderModel.specialNote ==
                                  null
                              ? "No special notes added"
                              : widget.loadedOrder.simpleOrderModel.specialNote,
                          style: _themeConst.textTheme.subtitle1.copyWith(
                            color: LendenAppTheme.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        title: "Delivery Notes",
                        iconType: FontAwesomeIcons.commentDots),
                    SizedBox(
                      height: _mHeight * 0.012,
                    ),
                    ProductDetailWidget(
                      widget.loadedOrder.simpleOrderModel,
                    ),
                    TaskButtons(
                      title: "Proceed to Payment",
                      onTap: () async {
                        await widget.changeStatus(
                            "PAYMENT", widget.loadedOrder, null, null);
                      },
                      btnColor: LendenAppTheme.greenColor,
                      isLoading: false,
                    ),
                    SizedBox(
                      height: _mHeight * 0.07,
                    )
                  ],
                );
        });
  }
}
