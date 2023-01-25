import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/status_helper.dart';
import '../../../core/utilities/location_helper.dart';
import '../../../features/client/client_model.dart';
import '../../../features/order/order_model.dart';
import '../../../features/order_detail/order_detail_provider.dart';
import '../../widgets/api_error.dart';
import '../../widgets/card_info_builder.dart';
import '../../widgets/private_image_widget.dart';
import '../../widgets/product_detail_widget.dart';
import '../../widgets/static_map_image.dart';
import '../../widgets/text_with_icon.dart';
import '../../widgets/timeline_builder.dart';
import '../map/map_screen.dart';

/// [DeliveryDetailsScreen] : The DeliveryDetailsScreen shows the details of the particular order
class DeliveryDetailsScreen extends StatelessWidget {
  //Route
  static const String routeName = "/delivery_details_screen";

  //UI
  ThemeData _themeConst;
  var _mHeight, _mWidth;
  MediaQueryData _mediaQueryData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  /// FUNC [_showPreviewImg] : Help to show the preview img of the map
  String _showPreviewImg(
      {@required Location pickup, @required DoubleLocation dropOff}) {
    return LocationHelper.getLocationPreviewImg(
        type: "Normal", pickup: pickup, dropOff: dropOff);
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    _themeConst = Theme.of(context);
    _mediaQueryData = MediaQuery.of(context);
    _mHeight = _mediaQueryData.size.height;
    _mWidth = _mediaQueryData.size.width;
    var orderType = ModalRoute.of(context).settings.arguments as Map;
    String orderNo = orderType['orderNo'];
    String orderId = orderType['orderId'];
    String vendorId = orderType['vendorId'];
    String clientId = orderType["clientId"];
    String priority = orderType["priority"];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(" $orderNo"),
        centerTitle: true,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 25),
            icon: priority == "HIGH"
                ? const Icon(
                    FontAwesomeIcons.utensils,
                    color: LendenAppTheme.pinkColor,
                    size: 25,
                  )
                : const Icon(
                    FontAwesomeIcons.gifts,
                    color: LendenAppTheme.greenColor,
                    size: 25,
                  ),
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(priority == "HIGH"
                    ? "The Order Type is of Food with HIGH Priority"
                    : "The Order Type is of Normal with LOW Priority"),
                duration: Duration(seconds: 2),
                backgroundColor: priority == "HIGH"
                    ? LendenAppTheme.pinkColor
                    : LendenAppTheme.greenColor,
              ));
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<OrderDetailProvider>(context, listen: false)
            .fetchOrderDetailsById(
                vendorId: vendorId, orderId: orderId, clientId: clientId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : snapshot.hasError
                  ? APIError()
                  : ListView(
                      children: [
                        Card(
                          margin: const EdgeInsets.all(0),
                          elevation: 1,
                          color: OrderHelper.getColorForOrder(
                              snapshot.data.simpleOrderModel.state),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          child: TextWithIcon(
                            text: OrderHelper.getStringForOrder(
                                snapshot.data.simpleOrderModel.state),
                            icon: OrderHelper.getIconForOrder(
                                orderState:
                                    snapshot.data.simpleOrderModel.state),
                            mainAxisAlignment: MainAxisAlignment.center,
                            textStyle: _themeConst.textTheme.subtitle1.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, MapScreen.routeName,
                                arguments: {
                                  'mapType': "Normal",
                                  'from': snapshot.data.vendorModel.geolocation,
                                  'fromAddress':
                                      "${snapshot.data.vendorModel.permanentAddress.tole}, ${snapshot.data.vendorModel.permanentAddress.vdc}",
                                  'to':
                                      snapshot.data.clientLocation.geolocation,
                                  'toAddress':
                                      snapshot.data.clientLocation.addressTitle
                                });
                          },
                          child: StaticMapImage(
                            mHeight: _mHeight,
                            previewImageUrl: _showPreviewImg(
                              pickup: snapshot.data.vendorModel.geolocation,
                              dropOff: snapshot.data.clientLocation.geolocation,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _mHeight * 0.012,
                        ),
                        TimelineBuilder(
                          vendorModel: snapshot.data.vendorModel,
                          deliveryContact:
                              snapshot.data.simpleOrderModel.contact,
                          deliveryUserName: snapshot.data.clientModel.name,
                          deliveryLocation:
                              snapshot.data.clientLocation.addressTitle,
                        ),
                        SizedBox(
                          height: _mHeight * 0.012,
                        ),
                        CardInfoBuilder(
                            description: Text(
                              "${snapshot.data.clientLocation.addressTitle} - ${snapshot.data.clientLocation.addressDetail}",
                              style: _themeConst.textTheme.subtitle1.copyWith(
                                color: LendenAppTheme.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            title: "Address Details",
                            iconType: FontAwesomeIcons.streetView),
                        SizedBox(
                          height: _mHeight * 0.012,
                        ),
                        CardInfoBuilder(
                            description: Text(
                              snapshot.data.simpleOrderModel.specialNote == null
                                  ? "No any notes added!"
                                  : snapshot.data.simpleOrderModel.specialNote,
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
                        if (snapshot.data.simpleOrderModel.state == "DELIVERED")
                          snapshot.data.simpleOrderModel.deliveredImage ==
                                      null ||
                                  snapshot.data.simpleOrderModel
                                          .deliveredImage ==
                                      "[]"
                              ? Container()
                              : CardInfoBuilder(
                                  description: PrivateImage(
                                      fakeImageUrl: jsonDecode(snapshot.data
                                          .simpleOrderModel.deliveredImage)[0]),
                                  title: "Delivered Photo",
                                  iconType: FontAwesomeIcons.cameraRetro),
                        SizedBox(
                          height: _mHeight * 0.012,
                        ),
                        ProductDetailWidget(
                          snapshot.data.simpleOrderModel,
                        )
                      ],
                    );
        },
      ),
    );
  }
}
