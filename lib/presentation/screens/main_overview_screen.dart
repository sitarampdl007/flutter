import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:lenden_delivery/features/auth/auth_provider.dart';
import 'package:lenden_delivery/features/rider/rider_provider.dart';
import 'package:lenden_delivery/presentation/widgets/loading_animation_widget.dart';
import 'package:lenden_delivery/presentation/widgets/sort_bottomsheet_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/assets.dart';
import '../../features/logistic/logistic_provider.dart';
import '../../features/order/order_provider.dart';
import '../widgets/api_error.dart';
import 'assign/assign_delivery_screen.dart';
import 'auth/login_screen.dart';
import 'delivery_history/delivery_history_screen.dart';
import 'home/home_screen.dart';
import 'userprofile/user_profile_screen.dart';

/// =========================== For List Of Screens ===========================
enum Pages { Home, Assign, History, User }

/// [MainOverviewScreen] : The Main Screen having all the bottom navigation and
/// various widgets combine
class MainOverviewScreen extends StatefulWidget {
  static const routeName = '/main_overview_screen';

  @override
  _MainOverviewScreenState createState() => _MainOverviewScreenState();
}

class _MainOverviewScreenState extends State<MainOverviewScreen>
    with WidgetsBindingObserver {
  // know if the app is in bg or foreground
  AppLifecycleState _lifecycleState;
  bool _isInForeground = true;

  // VARIABLES
  bool _isInit = true;
  bool _isFetching = false;
  bool _hasError = false;
  Status userStatus;

  //UI
  int _selectedPageIndex = 0;
  Pages _selectedPage = Pages.Home;
  ThemeData _themeConst;
  MediaQueryData _mediaConst;
  double _mHeight;
  double _mWidth;

  // ========================== CHECK APP STATES =======================

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // start work manager and fetch location

    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      _getAllPermission();
      await _getOrdersList();
      userStatus =
          Provider.of<RiderProvider>(context, listen: false).socketStatus;
    }
    _isInit = false;
  }

  ///FUNC [_getAllPermission] : Get permission for location
  void _getAllPermission() async {
    try {
      String result = await Provider.of<RiderProvider>(context, listen: false)
          .checkLocationPermission();
      if (result == "service_enabled") {
        geo.LocationPermission permission =
            await geo.Geolocator.checkPermission();
        if (permission != geo.LocationPermission.always ||
            permission != geo.LocationPermission.whileInUse) {
          permission = await geo.Geolocator.requestPermission();
        }
      }
    } catch (error) {
      _getAllPermission();
    }
  }

  /// FUNC [_getOrdersList] : Get all the recent orders
  Future<void> _getOrdersList() async {
    try {
      if (this.mounted) {
        setState(() {
          _isFetching = true;
        });
      }
      final logisticHeaders =
          Provider.of<LogisticProvider>(context, listen: false)
              .getLogisticsHeader();
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.setOrdersNull();
      await orderProvider.fetchOrders(
          logiHeaders: logisticHeaders, type: "recent");
    } catch (error) {
      print(error);
      if (this.mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
    if (this.mounted) {
      setState(() {
        _isFetching = false;
      });
    }
  }

  /// FUNC [_onWillPop] : Go back and exit app
  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (dCtx) => AlertDialog(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text('Exit Lenden Delivery?'),
            content: Text(
              'The application will exit. Are you sure?',
              style: _themeConst.textTheme.caption.copyWith(fontSize: 15),
            ),
            actions: <Widget>[
              FlatButton(
                color: LendenAppTheme.greenColor,
                onPressed: () {
                  Navigator.of(dCtx).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
              FlatButton(
                color: LendenAppTheme.redColor,
                onPressed: () => Navigator.of(dCtx).pop(false),
                child: Text('No'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    _mediaConst = MediaQuery.of(context);
    _mHeight = _mediaConst.size.height;
    _mWidth = _mediaConst.size.width;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          LendenAppTheme.primary, //or set color with: Color(0xFF0000FF)
    ));
    _themeConst = Theme.of(context);
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: _buildAppBar(context),
          body: _isFetching
              ? Center(
                  child: LoadingAnimation(),
                )
              : _hasError
                  ? APIError()
                  : _getPage(),
          floatingActionButton:
              keyboardIsOpened ? _buildFloatingButton(context) : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomBar(context)),
    );
  }

  // =========================== UI Functions ===========================

  ///FUNC [_selectPage] : To change the page
  void _selectPage(int index) {
    _selectedPageIndex = index;
  }

  ///FUNC [_getPage] : To get selected page
  Widget _getPage() {
    Widget page;
    switch (_selectedPageIndex) {
      case 0:
        page = HomeScreen();
        break;
      case 1:
        page = AssignDeliveryScreen();
        break;
      case 2:
        page = DeliveryHistoryScreen();
        break;
      case 3:
        page = UserProfileScreen();
        break;
      default:
        page = HomeScreen();
    }
    setState(() {});
    return page;
  }

  ///UI [_createAppBar] : To get the types of app
  PreferredSizeWidget _createAppBar(
      {String title, bool center, List<Widget> action}) {
    return AppBar(
      elevation: 0,
      title: Text(title),
      automaticallyImplyLeading: false,
      centerTitle: center,
      actions: action,
    );
  }

  /// FUNC [_showLogoutDialog] : Show logout confirm
  void _showLogoutDialog(BuildContext sCtx) {
    showDialog(
        context: sCtx,
        builder: (dCtx) => AlertDialog(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text("Are you sure to logout?"),
              actions: [
                FlatButton(
                    onPressed: () async {
                      await Provider.of<RiderProvider>(context, listen: false)
                          .stopLocationUpdate();
                      await Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                      Navigator.pop(dCtx);
                      Navigator.pushReplacementNamed(
                          sCtx, LoginScreen.routeName);
                    },
                    color: LendenAppTheme.greenColor,
                    child: Text("Yes")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(dCtx);
                    },
                    color: LendenAppTheme.redColor,
                    child: Text("No")),
              ],
            ));
  }

  ///UI [_buildAppBar] : Build the types of app
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    PreferredSizeWidget appBar;

    switch (_selectedPageIndex) {
      case 0:
        appBar = _createAppBar(
            title: "Ongoing Delivery",
            action: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  await _getOrdersList();
                },
              ),
            ],
            center: true);
        break;
      case 1:
        appBar = _createAppBar(
            title: "Today's Delivery",
            action: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  await _getOrdersList();
                },
              )
            ],
            center: true);
        break;
      case 2:
        appBar = _createAppBar(
            title: "Delivery History",
            action: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.sortAmountDownAlt,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context, builder: (mCtx) => SortBottomSheet());
                },
              )
            ],
            center: true);
        break;
      case 3:
        appBar = _createAppBar(
            title: "Profile",
            action: [
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.signOutAlt,
                ),
                onPressed: () => _showLogoutDialog(context),
              )
            ],
            center: true);
        break;
      default:
        appBar = _createAppBar(title: "Homepage", action: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.bell,
              color: _themeConst.primaryColor,
            ),
            onPressed: () {},
          )
        ]);
        break;
    }
    return appBar;
  }

  ///UI [_buildBottomBar] : Build the bottom bar with its items
  Widget _buildBottomBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.transparent,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width / 2 - 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.locationArrow,
                      color: _selectedPage == Pages.Home
                          ? Theme.of(context).primaryColor
                          : LendenAppTheme.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_selectedPage != Pages.Home) {
                          _selectedPage = Pages.Home;
                          _selectPage(0);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.assignment,
                      size: 30,
                      color: _selectedPage == Pages.Assign
                          ? _themeConst.primaryColor
                          : LendenAppTheme.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_selectedPage != Pages.Assign) {
                          _selectedPage = Pages.Assign;
                          _selectPage(1);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width / 2 - 40.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.history,
                      color: _selectedPage == Pages.History
                          ? _themeConst.primaryColor
                          : LendenAppTheme.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_selectedPage != Pages.History) {
                          _selectedPage = Pages.History;
                          _selectPage(2);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.user,
                      color: _selectedPage == Pages.User
                          ? _themeConst.primaryColor
                          : LendenAppTheme.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_selectedPage != Pages.User) {
                          _selectedPage = Pages.User;
                          _selectPage(3);
                        }
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///UI [_buildFloatingButton] : Build the floating action button
  Widget _buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "btn1",
      onPressed: _dialogOnOff,
      child: Icon(
        userStatus == Status.Online
            ? FontAwesomeIcons.checkCircle
            : FontAwesomeIcons.timesCircle,
        color: Colors.white,
      ),
      backgroundColor: userStatus == Status.Online
          ? LendenAppTheme.greenColor
          : LendenAppTheme.redColor,
    );
  }

  ///FUNC [_dialogOnOff] : Build the floating action button
  void _dialogOnOff() {
    showDialog(
        context: context,
        builder: (dCtx) => AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                      userStatus == Status.Online
                          ? AssetsSource.offlineLottie
                          : AssetsSource.doneLottie,
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                      repeat: false),
                  Text(
                    "Change Status?",
                    style: _themeConst.textTheme.subtitle1.copyWith(
                        color: LendenAppTheme.grey,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              content: Container(
                height: _mHeight * 0.14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "You must be online to receive online delivery.",
                      textAlign: TextAlign.center,
                      style: _themeConst.textTheme.subtitle2.copyWith(
                          color: LendenAppTheme.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: _mHeight * 0.005,
                    ),
                    Container(
                      width: double.infinity,
                      child: FlatButton(
                        onPressed: () async {
                          if (userStatus == Status.Online) {
                            ///disconnect from socket
                            Provider.of<RiderProvider>(context, listen: false)
                                .stopLocationUpdate();
                            userStatus = Status.Offline;
                          } else {
                            ///connect to socket
                            userStatus = Status.Online;
                            Provider.of<RiderProvider>(context, listen: false)
                                .startLocationUpdate();
                          }
                          Navigator.of(dCtx).pop();
                          setState(() {});
                        },
                        child: Text(
                          userStatus == Status.Online
                              ? "Go Offline"
                              : "Go Online",
                          style: _themeConst.textTheme.subtitle2.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w400),
                        ),
                        color: userStatus == Status.Online
                            ? LendenAppTheme.redColor
                            : LendenAppTheme.greenColor,
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
