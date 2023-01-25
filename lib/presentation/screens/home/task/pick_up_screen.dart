import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenden_delivery/presentation/widgets/validate_dialog.dart';

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

class PickUpScreen extends StatefulWidget {
  final FullOrderDetail loadedOrder;
  final Function changeScreen;
  final GlobalKey<ScaffoldState> scaffoldKey;

  PickUpScreen(this.loadedOrder, this.changeScreen, this.scaffoldKey);

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  //UI
  ThemeData _themeConst;
  var _mHeight, _mWidth;
  MediaQueryData _mediaQueryData;

  //vars
  Future _loadMap;
  var _scanResult;
  String _validateOrderNo = "";
  final _validateFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isQR = false;
  bool _gotError = false;
  String _errorText;

  /// FUNC [_getLocationAndPreview] : Getting location of user and showing it to map
  Future<Map<String, dynamic>> _getLocationAndPreview() async {
    String vendorLat = widget.loadedOrder.vendorModel.geolocation.latitude;
    String vendorLong = widget.loadedOrder.vendorModel.geolocation.longitude;
    var userPosition = await LocationHelper.getUserLocation();
    Location userLocation = Location(
        userPosition.latitude.toString(), userPosition.longitude.toString());
    DoubleLocation vendorDouble =
        DoubleLocation(double.parse(vendorLat), double.parse(vendorLong));
    final locationMap = {
      "userLocation": userLocation,
      "staticImg": LocationHelper.getLocationPreviewImg(
          type: "UserPickup", pickup: userLocation, dropOff: vendorDouble)
    };
    userLocation = null;
    vendorDouble = null;
    return locationMap;
  }

  @override
  void initState() {
    _loadMap = _getLocationAndPreview();
    super.initState();
  }

  /// FUNC [_showError] : Show Error during errors
  Widget _showError(String text, bool gotError) {
    return gotError
        ? Text(
            text,
            textAlign: TextAlign.center,
            style: _themeConst.textTheme.subtitle1.copyWith(
              color: Colors.white,
            ),
          )
        : Container();
  }

  /// FUNC [scan] : Scan using QR Code
  Future _scan() async {
    setState(() {
      _isQR = true;
    });
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      _scanResult = barcode;
      Map<String, dynamic> scanMap = jsonDecode(barcode.rawContent);
      print("The scan result is $_scanResult");
      String id = scanMap["id"];
      print("The map result is $id");
      if (widget.loadedOrder.simpleOrderModel.orderDetails.orderId == id) {
        await widget.changeScreen("INTRANSIT", widget.loadedOrder, null, null);
      } else {
        setState(() {
          _gotError = true;
          _errorText = "Sorry, the scanned code is not correct!";
        });
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        _scanResult = 'The user did not grant the camera permission!';
        print(_scanResult);
      } else {
        _scanResult = 'Unknown error: $e';
        print("The scan result is $_scanResult");
      }
    } on FormatException {
      _scanResult =
          'User returned using the "back"-button before scanning anything. Result';
      print("The scan result is $_scanResult");
    } catch (e) {
      _scanResult = 'Unknown error: $e';
      print("The scan result is $_scanResult");
      setState(() {
        _gotError = true;
        _errorText =
            "Sorry, couldnot proceed to update the order. Please try again!";
      });
    }
    setState(() {
      _isQR = false;
    });
  }

  // FUNC [_validateOrder] : Validate Order Number and Proceed
  Future<void> _validateOrder(BuildContext dialogCtx) async {
    final isValid = _validateFormKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _validateFormKey.currentState.save();
    try {
      await widget.changeScreen("INTRANSIT", widget.loadedOrder, null, null);
      _validateFormKey.currentState.reset();
    } catch (error) {
      setState(() {
        _errorText =
            "Sorry, couldnot proceed to update the order. Please try again!";
      });
    }
    Navigator.pop(dialogCtx);
  }

  /// FUNC [_showValidateDialog] : Show Validate Dialog to change state
  void _showValidateDialog(BuildContext sCtx) {
    showDialog(
        context: sCtx,
        builder: (dCtx) => ValidateDialog(
              themeConst: _themeConst,
              mHeight: _mHeight,
              validateOrder: () => _updateStatus(sCtx),
              buildContext: dCtx,
              orderNo: widget.loadedOrder.simpleOrderModel.orderNumber,
              orderId: widget.loadedOrder.simpleOrderModel.orderDetails.orderId,
            ));
  }

  Future<void> _updateStatus(BuildContext sCtx) async {
    try {
      await widget.changeScreen("INTRANSIT", widget.loadedOrder, null, null);
    } catch (error) {
      throw (error);
    }
  }

  // =========================== Build Function ===========================
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
                            'mapType': "UserPickup",
                            'from': userLocation,
                            'fromAddress': "Your Location",
                            'to': widget.loadedOrder.vendorModel.geolocation,
                            'toAddress':
                                "${widget.loadedOrder.vendorModel.permanentAddress.tole}, ${widget.loadedOrder.vendorModel.permanentAddress.vdc}",
                          });
                    },
                    child: StaticMapImage(
                      mHeight: _mHeight,
                      previewImageUrl: snapshot.data["staticImg"],
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
                        widget.loadedOrder.simpleOrderModel.specialNote == null
                            ? "No any notes added!"
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
                    title: "Validate",
                    onTap: () => _showValidateDialog(context),
                    btnColor: LendenAppTheme.greenColor,
                    isLoading: false,
                  ),
                  SizedBox(
                    height: _mHeight * 0.07,
                  )
                ],
              );
      },
    );
  }
}
