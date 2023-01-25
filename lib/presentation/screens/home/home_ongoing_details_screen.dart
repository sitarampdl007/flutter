import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/logistic/logistic_provider.dart';
import '../../../features/order/order_provider.dart';
import '../../../features/order_detail/order_detail_provider.dart';
import '../../widgets/api_error.dart';
import '../../widgets/cancel_badge.dart';
import '../../widgets/horizontal_time_line.dart';
import 'task/cancel_screen.dart';
import 'task/delivery_cancelled_screen.dart';
import 'task/delivery_screen.dart';
import 'task/payment_screen.dart';
import 'task/pick_up_screen.dart';

class HomeOngoingDetailsScreen extends StatefulWidget {
  static const String routeName = "/home_ongoing_details_screen";

  @override
  _HomeOngoingDetailsScreenState createState() =>
      _HomeOngoingDetailsScreenState();
}

class _HomeOngoingDetailsScreenState extends State<HomeOngoingDetailsScreen> {
  //ui
  ThemeData _themeConst;
  var _mHeight, _mWidth;
  MediaQueryData _mediaQueryData;

  // state
  bool _isInit = true;
  bool _isLoading = true;
  bool _hasError = false;
  FullOrderDetail _fullOrderDetail;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //vars
  String _orderState, _orderNo, _orderId, _vendorId, _clientId, _priority;

  /// FUNC [_getScreen]: Get the screen according to state
  Widget _getScreen(String orderState, String orderId,
      FullOrderDetail orderDetail, GlobalKey<ScaffoldState> key) {
    switch (orderState) {
      case "PICKINGUP":
        return PickUpScreen(orderDetail, _changeScreen, key);
      case "INTRANSIT":
        return DeliveryScreen(orderDetail, _changeScreen);
      case "PAYMENT":
        return PaymentScreen(
          loadedOrder: orderDetail,
          changeScreen: _changeScreen,
          scaffoldKey: _scaffoldKey,
        );
      case "DELIVERED":
        break;
      case "DELIVERY_FAILURE":
        return DeliveryCancelledScreen(orderId);
      default:
        return PickUpScreen(orderDetail, _changeScreen, key);
    }
  }

  /// FUNC [_changeScreen]: Change the screen according to state
  Future<void> _changeScreen(String status, FullOrderDetail orderDetail,
      File deliveredImage, File signature) async {
    try {
      if (status != "PAYMENT" && status != "DELIVERY_FAILURE") {
        final logisticHeaders =
            Provider.of<LogisticProvider>(context, listen: false)
                .getLogisticsHeader();
        final updateResponse =
            await Provider.of<OrderProvider>(context, listen: false)
                .updateOrderState(
                    orderId: orderDetail.simpleOrderModel.orderDetails.orderId,
                    updateState: status,
                    logiHeaders: logisticHeaders,
                    deliveredImage: deliveredImage,
                    customerSignature: signature);
      }
      if (status != "DELIVERED") {
        setState(() {
          _orderState = status;
        });
      }
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  /// FUNC [_fetchOrderDetail]: Fetch the order detail
  Future<void> _fetchOrderDetail() async {
    var orderType =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    _orderNo = orderType['orderNo'];
    _orderState = orderType['orderState'];
    _orderId = orderType['orderId'];
    _vendorId = orderType['vendorId'];
    _clientId = orderType["clientId"];
    _priority = orderType["priority"];
    if (_orderState != "DELIVERY_FAILURE") {
      try {
        setState(() {
          _isLoading = true;
        });
        _fullOrderDetail =
            await Provider.of<OrderDetailProvider>(context, listen: false)
                .fetchOrderDetailsById(
                    vendorId: _vendorId,
                    orderId: _orderId,
                    clientId: _clientId);
      } catch (error) {
        if (this.mounted) {
          setState(() {
            _hasError = true;
          });
        }
      }
    }
    if (this.mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      await _fetchOrderDetail();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    _themeConst = Theme.of(context);
    _mediaQueryData = MediaQuery.of(context);
    _mHeight = _mediaQueryData.size.height;
    _mWidth = _mediaQueryData.size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("$_orderNo"),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 15, bottom: 7),
            icon: _priority == "HIGH"
                ? Icon(
                    FontAwesomeIcons.utensils,
                    color: LendenAppTheme.pinkColor,
                    size: 25,
                  )
                : Icon(
                    FontAwesomeIcons.gifts,
                    color: LendenAppTheme.greenColor,
                    size: 25,
                  ),
            onPressed: () {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(_priority == "HIGH"
                    ? "The Order Type is of Food with HIGH Priority"
                    : "The Order Type is of Normal with LOW Priority"),
                duration: Duration(seconds: 2),
                backgroundColor: _priority == "HIGH"
                    ? LendenAppTheme.pinkColor
                    : LendenAppTheme.greenColor,
              ));
            },
          ),
          _orderState == "DELIVERY_FAILURE"
              ? Container()
              : Badge(
                  child: IconButton(
                    padding: const EdgeInsets.only(right: 20),
                    icon: const Icon(
                      Icons.local_shipping,
                      size: 30,
                    ),
                    onPressed: () async {
                      final cancelState = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => CancelScreen(_orderId)));
                      if (cancelState == "DELIVERY_FAILURE") {
                        _changeScreen(
                            "DELIVERY_FAILURE", _fullOrderDetail, null, null);
                      }
                    },
                  ),
                )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? APIError()
              : ListView(
                  children: [
                    _orderState == "DELIVERY_FAILURE"
                        ? Container()
                        : HorizontalTimeLine(deliveryStatus: _orderState),
                    _getScreen(
                      _orderState,
                      _orderId,
                      _fullOrderDetail,
                      _scaffoldKey,
                    )
                  ],
                ),
    );
  }
}
