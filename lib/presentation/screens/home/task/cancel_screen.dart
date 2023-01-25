import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/assets.dart';
import '../../../../core/utilities/constants.dart';
import '../../../../core/utilities/validators.dart';
import '../../../../features/logistic/logistic_provider.dart';
import '../../../../features/order/order_provider.dart';

class CancelScreen extends StatefulWidget {
  static const String routeName = "/cancel_screen";

  final String orderId;

  CancelScreen(this.orderId);

  @override
  _CancelScreenState createState() => _CancelScreenState();
}

class _CancelScreenState extends State<CancelScreen> {
  //ui
  ThemeData _themeConst;
  var _mHeight, _mWidth;
  MediaQueryData _mediaQueryData;

  //vars
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedIssue;
  String _selectedNote;
  bool _isLoading = false;

  List<String> _issuesDropDown = [
    "Vendor Issue",
    "Customer Issue",
    "Delivery Issue",
  ];

  Widget _buildIssueDropDown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Specify issue",
        errorStyle: TextStyle(
          color: Colors.red,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
      ),
      icon: Icon(FontAwesomeIcons.caretDown),
      iconSize: 24,
      elevation: 16,
      style: _themeConst.textTheme.subtitle1,
      validator: (value) => Validators.validateIssue(value),
      disabledHint: Text("Specify Issue"),
      onChanged: (String newValue) {
        setState(() {
          _selectedIssue = newValue;
        });
      },
      items: _issuesDropDown.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
          ),
        );
      }).toList(),
    );
  }

  void _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final logisticHeaders =
          Provider.of<LogisticProvider>(context, listen: false)
              .getLogisticsHeader();
      final updateResponse =
          await Provider.of<OrderProvider>(context, listen: false)
              .cancelOrderState(
        orderId: widget.orderId,
        logiHeaders: logisticHeaders,
        deliveryIssue: _selectedIssue,
        deliveryFailureNote: _selectedNote,
      );
      _selectedIssue = "";
      _formKey.currentState.reset();
      Navigator.pop(context, "DELIVERY_FAILURE");
    } catch (error) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Sorry, could not cancel the order. Please try again!",
          textAlign: TextAlign.center,
          style: _themeConst.textTheme.subtitle1.copyWith(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: 4),
        backgroundColor: _themeConst.errorColor,
      ));
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
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
        title: Text("Cancel Delivery"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Lottie.asset(AssetsSource.failureLottie,
              width: 100, height: 100, fit: BoxFit.contain),
          SizedBox(
            height: _mHeight * 0.02,
          ),
          Text(
            "Report Delivery Issue",
            style: _themeConst.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: _mHeight * 0.05,
          ),
          Text(
            "Please choose the reasonable option and specify your note as well.",
            style: _themeConst.textTheme.subtitle1,
          ),
          SizedBox(
            height: _mHeight * 0.03,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildIssueDropDown(),
                  SizedBox(
                    height: _mHeight * 0.018,
                  ),
                  TextFormField(
                    decoration: kReportInputDeco,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    onSaved: (value) {
                      _selectedNote = value;
                    },
                    validator: (value) => Validators.validateNote(value),
                    maxLines: 6,
                  ),
                ],
              )),
          SizedBox(
            height: _mHeight * 0.02,
          ),
          Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: LendenAppTheme.redColor,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            ),
                          )
                        : Text("Cancel Delivery",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white)),
                    onPressed: _isLoading ? null : _saveForm),
              ),
              Spacer(),
            ],
          )
        ],
      ),
    );
  }
}
