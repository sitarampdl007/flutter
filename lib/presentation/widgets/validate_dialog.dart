import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lenden_delivery/core/theme/app_theme.dart';
import 'package:lenden_delivery/core/utilities/crypto_helper.dart';

class ValidateDialog extends StatefulWidget {
  final ThemeData themeConst;
  final double mHeight;
  final Function validateOrder;
  final String orderId;
  final String orderNo;
  final BuildContext buildContext;

  const ValidateDialog(
      {@required this.themeConst,
      @required this.mHeight,
      @required this.validateOrder,
      @required this.buildContext,
      @required this.orderId,
      @required this.orderNo});

  @override
  _ValidateDialogState createState() => _ValidateDialogState();
}

class _ValidateDialogState extends State<ValidateDialog> {
  //vars
  var _scanResult;
  String _validateOrderNo = "";
  final _validateFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isQR = false;
  bool _gotError = false;
  String _errorText;

  /// FUNC [scan] : Scan using QR Code
  Future _scan(BuildContext dialogCtx) async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      _scanResult = barcode;
      Map<String, dynamic> scanMap = jsonDecode(barcode.rawContent);
      print("The scan result is $_scanResult");
      String id = scanMap["id"];
      print("The map result is $id");
      setState(() {
        _isQR = true;
        _errorText = "";
      });
      print("the order id is ${widget.orderId}");
      String decryptedId = CryptoHelper.decryptAESCryptoJS(id);
      print("the decryptedId  is $decryptedId");
      if (widget.orderId == decryptedId) {
        await widget.validateOrder();
      } else {
        setState(() {
          _gotError = true;
          _errorText = "Sorry, the scanned code is not correct!";
        });
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          _errorText =
              "The QR code needs camera permission. Please allow for permission!";
        });
      }
    } on FormatException {
      setState(() {
        _errorText = "Sorry, couldnt get the QR. Please try again!";
      });
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
    Navigator.pop(dialogCtx);
  }

  // FUNC [_validateOrder] : Validate Order Number and Proceed
  Future<void> _validateOrder(BuildContext dialogCtx) async {
    final isValid = _validateFormKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _validateFormKey.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.validateOrder();
      _validateFormKey.currentState.reset();
    } catch (error) {
      setState(() {
        _errorText =
            "Sorry, couldnot proceed to update the order. Please try again!";
      });
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(dialogCtx);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Validate Pickup",
        textAlign: TextAlign.center,
        style: widget.themeConst.textTheme.headline6,
      ),
      content: Container(
        height: widget.mHeight * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Please Validate your Pickup either by scanning QR or using Order No.',
              textAlign: TextAlign.start,
              style: widget.themeConst.textTheme.caption,
            ),
            Form(
              key: _validateFormKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Order No.",
                ),
                style: widget.themeConst.textTheme.subtitle2,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a order number";
                  }
                  if ("OR$value" != widget.orderNo) {
                    return "The order number didnt match.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _validateOrderNo = value;
                },
              ),
            ),
            RaisedButton(
                color: LendenAppTheme.greenColor,
                onPressed: _isQR ? null : () => _scan(context),
                textColor: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  child: _isQR
                      ? Center(
                          child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                              )),
                        )
                      : const Text('Scan QR'),
                )),
            RaisedButton(
                color: LendenAppTheme.ratingColor,
                disabledColor: LendenAppTheme.deactivatedText,
                onPressed: _isLoading
                    ? null
                    : () async {
                        await _validateOrder(context);
                      },
                textColor: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  child: _isLoading
                      ? Center(
                          child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                              )),
                        )
                      : const Text('Validate with Order No.'),
                )),
            _gotError
                ? Text(
                    _errorText,
                    textAlign: TextAlign.center,
                    style: widget.themeConst.textTheme.subtitle1.copyWith(
                      color: Colors.red,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
