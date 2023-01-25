import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/status_helper.dart';
import '../../../features/order/order_provider.dart';
import 'assign_list_view_widget.dart';

///[AssignDeliveryScreen] : The AssignDeliveryScreen to get assign delivery of today
class AssignDeliveryScreen extends StatefulWidget {
  @override
  _AssignDeliveryScreenState createState() => _AssignDeliveryScreenState();
}

class _AssignDeliveryScreenState extends State<AssignDeliveryScreen> {
  //UI
  MediaQueryData _mediaQuery;
  ThemeData _themeConst;
  var _mHeight, _mWidth;

  //VARS
  String _selectedTask = "READYFORPICKUP";
  Color _assignButtonColor = LendenAppTheme.accent;
  Color _ongoingButtonColor = Colors.transparent;
  Color _doneButtonColor = Colors.transparent;
  Color _assignTextColor = Colors.white;
  Color _ongoingTextColor = LendenAppTheme.grey;
  Color _doneTextColor = LendenAppTheme.grey;

  ///FUNC [_getDecoForButton] : Get button deco on type
  BoxDecoration _getDecoForButton(String type) {
    switch (type) {
      case "READYFORPICKUP":
        return BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15), topLeft: Radius.circular(15)),
          color: _assignButtonColor,
        );
      case "PICKINGUP":
        return BoxDecoration(
          color: _ongoingButtonColor,
        );
      case "DELIVERED":
        return BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
          color: _doneButtonColor,
        );
      default:
        return BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: LendenAppTheme.greenColor,
        );
    }
  }

  ///FUNC [_getDecoForButton] : Get button deco on type
  Color _getColorForButton(String type) {
    switch (type) {
      case "READYFORPICKUP":
        return _assignTextColor;
      case "PICKINGUP":
        return _ongoingTextColor;
      case "DELIVERED":
        return _doneTextColor;
      default:
        return _assignButtonColor;
    }
  }

  ///FUNC [_buildTitleDisplay] : To build the title showing task info
  Widget _buildTitleDisplay({@required String title, @required String type}) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTask = type;
            _changeButtonAndColor();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: _getDecoForButton(type),
          child: Column(
            children: [
              Text(
                title,
                style: _themeConst.textTheme.headline3.copyWith(
                  color: _getColorForButton(type),
                ),
              ),
              SizedBox(
                height: _mHeight * 0.002,
              ),
              Text(
                OrderHelper.getStringForOrder(type),
                style: _themeConst.textTheme.caption.copyWith(
                  fontSize: 14,
                  color: _getColorForButton(type),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///FUNC [_changeButtonAndColor] : Change Button Color
  void _changeButtonAndColor() {
    Color _selectedTextColor = Colors.white;
    Color _unselectedTextColor = LendenAppTheme.grey;
    Color _unselectedBtnColor = Colors.transparent;

    switch (_selectedTask) {
      case "READYFORPICKUP":
        //selected
        _assignButtonColor = LendenAppTheme.accent;
        _assignTextColor = _selectedTextColor;
        //unselected
        _ongoingButtonColor = _unselectedBtnColor;
        _ongoingTextColor = _unselectedTextColor;
        _doneButtonColor = _unselectedBtnColor;
        _doneTextColor = _unselectedTextColor;
        break;
      case "PICKINGUP":
        //selected
        _ongoingButtonColor = LendenAppTheme.ratingColor;
        _ongoingTextColor = _selectedTextColor;
        //unselected
        _assignButtonColor = _unselectedBtnColor;
        _assignTextColor = _unselectedTextColor;
        _doneTextColor = _unselectedTextColor;
        _doneButtonColor = _unselectedBtnColor;
        break;
      case "DELIVERED":
        //selected
        _doneButtonColor = LendenAppTheme.greenColor;
        _doneTextColor = _selectedTextColor;
        //unselected
        _assignButtonColor = _unselectedBtnColor;
        _assignTextColor = _unselectedTextColor;
        _ongoingTextColor = _unselectedTextColor;
        _ongoingButtonColor = _unselectedBtnColor;
        break;
      case "CANCELLED":
        break;
    }
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    final providerObj = Provider.of<OrderProvider>(context);
    final totalRecent =
        providerObj.orderObject == null ? 0 : providerObj.findTotalRecent();
    final totalDelivered = providerObj.deliveredObj == null
        ? 0
        : providerObj.finalTotalDelivered();
    _mediaQuery = MediaQuery.of(context);
    _themeConst = Theme.of(context);
    _mHeight = _mediaQuery.size.height;
    _mWidth = _mediaQuery.size.width;
    return SafeArea(
        child: NestedScrollView(
            headerSliverBuilder: (ctx, innerBox) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Stack(children: [
                      Container(
                        height: _mHeight * 0.15,
                        width: _mWidth,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              LendenAppTheme.primary,
                              LendenAppTheme.primaryDark
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, left: 10, right: 10, bottom: 0),
                        child: Column(
                          children: [
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildTitleDisplay(
                                    title: "$totalRecent",
                                    type: "READYFORPICKUP",
                                  ),
                                  _buildTitleDisplay(
                                      title: "$totalDelivered",
                                      type: "DELIVERED"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ]),
                )
              ];
            },
            body: AssignListView(
              selectedOrderStatus: _selectedTask,
            )));
  }
}
