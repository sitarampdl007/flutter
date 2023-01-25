import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../core/theme/app_theme.dart';

/// Widget [LogRegForButton] : The LendenLogo for showing logo when needed
class LogRegForButton extends StatelessWidget {
  final String title;
  final Function onTap;
  final bool showProgress;

  LogRegForButton(
      {@required this.title, @required this.onTap, this.showProgress = false});

// =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: showProgress ? null : onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [LendenAppTheme.primaryDark, LendenAppTheme.primary],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          width: double.infinity,
          alignment: Alignment.center,
          child: showProgress
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
