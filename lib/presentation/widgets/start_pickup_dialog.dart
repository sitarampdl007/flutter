import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/assets.dart';

class StartPickupDialog extends StatefulWidget {
  final ThemeData themeConst;
  final double mHeight;
  final Function startPickup;
  final BuildContext buildContext;

  const StartPickupDialog(
      {@required this.themeConst,
      @required this.mHeight,
      @required this.startPickup,
      @required this.buildContext});

  @override
  _StartPickupDialogState createState() => _StartPickupDialogState();
}

class _StartPickupDialogState extends State<StartPickupDialog> {
  bool _isLoading = false;
  bool _hasError = false;

  void _updateStatus() async {
    try {
      //change state of ready for pickup to picking up
      setState(() {
        _isLoading = true;
      });
      await widget.startPickup();
      Navigator.pop(widget.buildContext, true);
    } catch (error) {
      setState(() {
        _hasError = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: LendenAppTheme.chipBackground,
      title: Text("Start Pickup Process?",
          style: widget.themeConst.textTheme.headline6),
      content: Container(
        height: widget.mHeight * 0.32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 8, bottom: 10, left: 10, right: 10),
              child: Lottie.asset(AssetsSource.rider,
                  height: widget.mHeight * 0.18,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  repeat: true),
            ),
            Text(
              "This will start the Pickup process and you can access it from homepage.",
              style: widget.themeConst.textTheme.caption.copyWith(
                  color: LendenAppTheme.grey, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: widget.mHeight * 0.015,
            ),
            _isLoading
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  ])
                : _hasError
                    ? Container(
                        color: LendenAppTheme.greenColor,
                        width: double.infinity,
                        child: Text(
                          "Sorry! Couldnot start the pickup process. Please try again!",
                          style: widget.themeConst.textTheme.subtitle2
                              .copyWith(color: widget.themeConst.errorColor),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.all(0),
                              color: LendenAppTheme.greenColor,
                              onPressed: _updateStatus,
                              child: Text(
                                "Yes",
                                style: widget.themeConst.textTheme.subtitle2
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              padding: const EdgeInsets.all(0),
                              color: LendenAppTheme.redColor,
                              onPressed: () {
                                Navigator.pop(widget.buildContext, false);
                              },
                              textColor: Colors.white,
                              child: Text(
                                "No",
                                style: widget.themeConst.textTheme.subtitle2
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
          ],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
