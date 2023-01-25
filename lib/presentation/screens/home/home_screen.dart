import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utilities/location_helper.dart';
import '../../../features/client/client_model.dart';
import '../../../features/order/order_model.dart';
import '../../../features/order/order_provider.dart';
import '../../widgets/empty_order.dart';
import '../../widgets/static_map_image.dart';
import '../map/map_screen.dart';
import 'home_ongoing_item_widget.dart';

/// [HomeScreen] : The HomeScreen having all the details about the current order info
class HomeScreen extends StatefulWidget {
  static const String routeName = "/home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //UI
  ThemeData _themeConst;
  var _mHeight, _mWidth;
  MediaQueryData _mediaQueryData;

  // vars
  List<OrderModel> _loadedOngoing;
  List<DoubleLocation> _deliveryLocations = [];
  List<Location> _pickUpLocations = [];
  String _pickupList = "";
  String _deliveryList = "";

  // FUNC [_showPreviewImg] : Get the map preview image
  String _showPreviewImg() {
    _loadedOngoing.forEach((order) {
      if (order.state != "DELIVERY_FAILURE") {
        if (order.vendor != null) {
          _pickUpLocations.add(order.vendor.geolocation);
        }
        if (order.deliveryAddress != null) {
          _deliveryLocations.add(order.deliveryAddress.geolocation);
        }
      }
    });
    String imgUrl;
    if (_pickUpLocations.isNotEmpty && _deliveryLocations.isNotEmpty) {
      _pickUpLocations.forEach((location) {
        _pickupList = _pickupList +
            LocationHelper.pickUpMarker +
            '${double.parse(location.latitude)},${double.parse(location.longitude)}';
      });
      _deliveryLocations.forEach((location) {
        _deliveryList = _deliveryList +
            LocationHelper.dropUpMarker +
            '${location.latitude},${location.longitude}';
      });
      imgUrl = LocationHelper.getMultipleLocationPreviewImg(
          pickup: _pickupList, delivery: _deliveryList);
    }

    return imgUrl;
  }

  @override
  void dispose() {
    super.dispose();
    _deliveryLocations.clear();
    _pickUpLocations.clear();
    _pickupList = "";
    _deliveryList = "";
  }

  // =========================== Build Function ===========================

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    _loadedOngoing =
        orderProvider.orderObject == null ? [] : orderProvider.ongoingOrderList;
    _themeConst = Theme.of(context);
    _mediaQueryData = MediaQuery.of(context);
    _mHeight = _mediaQueryData.size.height;
    _mWidth = _mediaQueryData.size.width;
    return _loadedOngoing.isEmpty
        ? EmptyOrder()
        : ListView(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, MapScreen.routeName, arguments: {
                    'mapType': "Multiple",
                    'deliveryList': _deliveryLocations,
                    'pickupList': _pickUpLocations,
                  });
                },
                child: StaticMapImage(
                  mHeight: _mHeight,
                  previewImageUrl: _showPreviewImg(),
                ),
              ),
              SizedBox(
                height: _mHeight * 0.02,
              ),
              SizedBox(
                height: _mHeight * 0.02,
              ),
              Column(
                children: _loadedOngoing
                    .map((order) => HomeOngoingItem(loadedOrder: order))
                    .toList(),
              )
            ],
          );
  }
}
