import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lenden_delivery/core/theme/app_theme.dart';
import 'package:lenden_delivery/presentation/widgets/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../features/logistic/logistic_provider.dart';
import '../../../features/order/order_provider.dart';
import '../../widgets/api_error.dart';
import 'delivery_history_listview.dart';

///[DeliveryHistoryScreen] : The DeliveryHistoryScreen having all listing of the tasks of the user
class DeliveryHistoryScreen extends StatefulWidget {
  // =========================== Build Function ===========================
  @override
  _DeliveryHistoryScreenState createState() => _DeliveryHistoryScreenState();
}

class _DeliveryHistoryScreenState extends State<DeliveryHistoryScreen> {
  //vars
  Future _fetchHistory;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final logisticHeaders =
          Provider.of<LogisticProvider>(context, listen: false)
              .getLogisticsHeader();
      _fetchHistory = Provider.of<OrderProvider>(context, listen: false)
          .fetchOrders(logiHeaders: logisticHeaders, type: "history");
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double mWidth = mediaQueryData.size.width;
    double mHeight = mediaQueryData.size.height;
    ThemeData themeData = Theme.of(context);
    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (ctx, innerBox) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([Text("")]),
            )
          ];
        },
        body: FutureBuilder(
          future: _fetchHistory,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? Center(child: LoadingAnimation())
                : snapshot.hasError
                    ? APIError()
                    : DeliveryHistoryListView();
          },
        ),
      ),
    );
  }
}
