import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/strings.dart';
import '../../../core/utilities/constants.dart';
import '../../../core/utilities/validators.dart';
import '../../../features/auth/auth_provider.dart';
import '../../../features/logistic/logistic_provider.dart';
import '../../widgets/bezier_container.dart';
import '../../widgets/delivery_logo.dart';
import '../../widgets/log_reg_for_button.dart';
import '../main_overview_screen.dart';

/// Screen [LoginScreen] : The LoginScreen to login and get user info
class LoginScreen extends StatefulWidget {
  static const String routeName = "/login_screen";

  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //UI
  var _mHeight, _mWidth;
  ThemeData _themeConst;

  // VARS
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _passwordFocusNode = FocusNode();
  bool _hidePassword = true;
  String _username, _password;
  bool _isLoading = false;

  // ======================== TOP/ BOTTOM UI ==============================

  /// UI [_bottomLayout] : Show the bottom layout to go to register
  Widget _bottomLayout() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            Strings.registerFormLabelQ,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: _mHeight * 0.015,
          ),
          InkWell(
            onTap: () async {
              // open lenden from play store
              // try {
              //   await AppAvailability.launchApp(
              //     Strings.playStoreId,
              //   );
              // } catch (error) {
              //   LaunchReview.launch(
              //       writeReview: false,
              //       androidAppId: Strings.playStoreId,
              //       iOSAppId: Strings.appStoreId);
              // }
            },
            child: const Text(
              Strings.registerFormLabel,
              style: TextStyle(
                  color: LendenAppTheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ======================== FORM UI ==============================

  /// UI [_loginWidget] : The form of the layout
  Widget _loginWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: (value) => Validators.validateMobile(value),
              onSaved: (value) {
                _username = value;
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: kPhoneLoginInputDeco.copyWith(
                  labelText: Strings.phoneFormLabel)),
          SizedBox(
            height: _mHeight * 0.020,
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              TextFormField(
                style: const TextStyle(color: Colors.black),
                obscureText: _hidePassword,
                focusNode: _passwordFocusNode,
                decoration: kPasswordInputDeco.copyWith(
                    labelText: Strings.passwordFormLabel),
                validator: (value) => Validators.validatePassword(value),
                onFieldSubmitted: (_) {
                  _saveForm();
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              IconButton(
                padding: const EdgeInsets.only(bottom: 5),
                icon: _hidePassword
                    ? const Icon(
                        FontAwesomeIcons.eyeSlash,
                        size: 20,
                      )
                    : const Icon(
                        FontAwesomeIcons.eye,
                        size: 20,
                      ),
                onPressed: _togglePassword,
              ),
              SizedBox(
                width: _mWidth * 0.01,
              )
            ],
          )
        ],
      ),
    );
  }

  /// FUNC [_togglePassword] : Helps to show/hide password
  void _togglePassword() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  // ======================== FORM FUNCTIONS ==============================

  /// FUNC : Dispose elements
  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
  }

  /// FUNC [_saveForm] : Save form
  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AuthProvider>(context, listen: false)
          .authenticate(_username, _password);
      Provider.of<LogisticProvider>(context, listen: false).setLogiModel();
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, MainOverviewScreen.routeName);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      //show error snack bar
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Sorry, couldn't login! " + error.toString(),
            textAlign: TextAlign.center,
            style: _themeConst.textTheme.subtitle1.copyWith(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 4),
          backgroundColor: _themeConst.errorColor,
        ),
      );
    }
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _mHeight = mediaQuery.size.height;
    _mWidth = mediaQuery.size.width;
    _themeConst = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: _mHeight,
          child: Stack(
            children: <Widget>[
              mediaQuery.orientation != Orientation.landscape
                  ? Positioned(
                      top: -_mHeight * .15,
                      right: -_mWidth * .4,
                      child: BezierContainer())
                  : Container(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: _mHeight * .2),
                      LendenLogo(),
                      SizedBox(height: _mHeight * 0.05),
                      _loginWidget(),
                      SizedBox(height: _mHeight * 0.02),
                      LogRegForButton(
                        onTap: _saveForm,
                        title: Strings.loginFormTitle,
                        showProgress: _isLoading,
                      ),
                      _bottomLayout(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
