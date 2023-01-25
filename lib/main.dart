import 'dart:io';

import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:lenden_delivery/core/utilities/http_helper.dart';
import 'package:lenden_delivery/features/rider/rider_provider.dart';
import 'package:provider/provider.dart';

import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/assets.dart';
import 'core/utilities/prefs_helper.dart';
import 'features/auth/auth_provider.dart';
import 'features/logistic/logistic_provider.dart';
import 'features/order/order_provider.dart';
import 'features/order_detail/order_detail_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/delivery_history/delivery_details_screen.dart';
import 'presentation/screens/home/home_ongoing_details_screen.dart';
import 'presentation/screens/main_overview_screen.dart';
import 'presentation/screens/map/map_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await FlutterConfig.loadEnvVariables();
  // await PrefsHelper.initializePrefs();
  // // HttpOverrides.global = new MyHttpOverrides();
  // await setupLocator();
  runApp(MainClass());
}

/// [MainClass] : The MainClass having all routing and the providers
class MainClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(
    //       create: (ctx) => AuthProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (ctx) => OrderProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (ctx) => LogisticProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (ctx) => OrderDetailProvider(),
    //     ),
    //     ChangeNotifierProvider(
    //       create: (ctx) => RiderProvider(),
    //     )
    //   ],
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: LendenSplash(),
    //     theme: LendenAppTheme().primaryThemeData,
    //     routes: {
    //       LoginScreen.routeName: (ctx) => LoginScreen(),
    //       MainOverviewScreen.routeName: (ctx) => MainOverviewScreen(),
    //       DeliveryDetailsScreen.routeName: (ctx) => DeliveryDetailsScreen(),
    //       MapScreen.routeName: (ctx) => MapScreen(),
    //       HomeOngoingDetailsScreen.routeName: (ctx) =>
    //           HomeOngoingDetailsScreen(),
    //     },
    //     onUnknownRoute: (settings) {
    //       return MaterialPageRoute(builder: (ctx) => LoginScreen());
    //     },
    //   ),
    // );
    return Text("Hello");
  }
}

/// [LendenSplash] : The LendenSplash having loading splash screen
class LendenSplash extends StatefulWidget {
  @override
  _LendenSplashState createState() => _LendenSplashState();
}

class _LendenSplashState extends State<LendenSplash> {
  bool _isInit = true;
  bool _isLogin = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      await checkLogin();
    }
    _isInit = false;
  }

  /// FUNC [checkLogin] : Check if user is logged for auto login
  Future<void> checkLogin() async {
    _isLogin =
        await Provider.of<AuthProvider>(context, listen: false).tryAutoLogin();
    if (_isLogin) {
      Provider.of<LogisticProvider>(context, listen: false).setLogiModel();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double mHeight = mediaQueryData.size.height;
    double mWidth = mediaQueryData.size.width;
    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       Container(
    //         decoration: const BoxDecoration(
    //             color: Colors.transparent,
    //             image: DecorationImage(
    //                 image: AssetImage(AssetsSource.backDropImg),
    //                 fit: BoxFit.cover)),
    //       ),
    //       Center(
    //         child: SplashScreen.navigate(
    //           name: AssetsSource.logoSplashRive,
    //           backgroundColor: Colors.transparent,
    //           startAnimation: "go",
    //           until: () => Future.delayed(
    //             Duration(seconds: 3),
    //           ),
    //           next: (ctx) => _isLogin ? MainOverviewScreen() : LoginScreen(),
    //           alignment: Alignment.center,
    //           width: double.infinity,
    //           height: mHeight * 0.15,
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return Text("hello");
  }
}
