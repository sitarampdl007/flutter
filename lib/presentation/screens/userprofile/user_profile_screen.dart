import 'package:flutter/material.dart';
import 'package:lenden_delivery/features/order/order_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utilities/prefs_helper.dart';
import '../../../features/auth/auth_provider.dart';
import '../../widgets/circle_image_loader.dart';
import '../../widgets/vertical_bar_chart.dart';
import '../auth/login_screen.dart';

/// [UserProfileScreen] : The UserProfileScreen having details about the user
class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  //UI
  MediaQueryData _mediaQuery;
  ThemeData _themeConst;
  var _mHeight, _mWidth;

  //vars
  Map<String, dynamic> userData;
  bool _isInit = true;

  // =========================== UI Functions ===========================

  /// FUNC [_buildTripInfo] : Build the card trip info
  Widget _buildTripInfo({String label, String caption}) {
    return Column(
      children: <Widget>[
        Text(
          label,
          textAlign: TextAlign.start,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: _themeConst.textTheme.caption.copyWith(fontSize: 16),
        ),
        SizedBox(
          height: _mHeight * 0.012,
        ),
        Text(
          caption,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      userData = PrefsHelper.getUserPrefs();
    }
    _isInit = false;
  }

  /// FUNC [_checkProfilePicLoad] : Check if the prefs has the img url
  bool _checkProfilePicLoad() {
    final profilePic = PrefsHelper.getProfilePicPrefs();
    if (profilePic == "" || profilePic == null) {
      return false;
    } else {
      return true;
    }
  }

  /// FUNC [_showLogoutDialog] : Show logout confirm
  void _showLogoutDialog(BuildContext sCtx) {
    showDialog(
        context: sCtx,
        builder: (dCtx) => AlertDialog(
              title: Text("Are you sure to logout?"),
              actions: [
                FlatButton(
                    onPressed: () async {
                      await Provider.of<AuthProvider>(context, listen: false)
                          .logout();
                      Navigator.pop(dCtx);
                      Navigator.pushReplacementNamed(
                          sCtx, LoginScreen.routeName);
                    },
                    child: Text("Yes")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(dCtx);
                    },
                    child: Text("No")),
              ],
            ));
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);
    _themeConst = Theme.of(context);
    _mHeight = _mediaQuery.size.height;
    _mWidth = _mediaQuery.size.width;
    final providerObj = Provider.of<OrderProvider>(context, listen: false);
    final totalDelivered = providerObj.deliveredObj == null
        ? 0
        : providerObj.finalTotalDelivered();

    return ListView(
      children: [
        Stack(children: [
          Container(
            height: _mHeight * 0.21,
            width: _mWidth,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [LendenAppTheme.primary, LendenAppTheme.primaryDark],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Row(children: [
                    CircleAvatar(
                        backgroundColor: LendenAppTheme.primaryLight,
                        radius: 45,
                        child:
                            // checkProfilePicLoad()
                            //     ? CircleAvatar(
                            //         radius: 42,
                            //         backgroundImage: NetworkImage(
                            //             PrefsHelper.getProfilePicPrefs())) :
                            CircleImageLoader(
                          radius: 42,
                          fakeImageUrl: userData["profilePicture"],
                          type: "profilePicture",
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      userData["username"],
                      style: _themeConst.textTheme.headline6
                          .copyWith(color: Colors.white),
                    ),
                  ]),
                ),
                SizedBox(
                  height: _mHeight * 0.02,
                ),
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildTripInfo(
                            label: "Time Online", caption: "15h 30min"),
                        _buildTripInfo(
                            label: "Today Trip", caption: "$totalDelivered"),
                        _buildTripInfo(label: "Total Trips", caption: "100"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              height: _mHeight * 0.34,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: VerticalBarLabelChart.withSampleData(),
            ),
          ),
        ),
      ],
    );
  }
}
