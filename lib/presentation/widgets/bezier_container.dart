import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'custom_clipper.dart';

/// Widget [BezierContainer] : The BezierContainer helps build the top curve paint UI for login
class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
        child: Transform.rotate(
      angle: -pi / 3.5,
      child: ClipPath(
        clipper:  ClipPainter(),
        child: Container(
          height: mediaQuery.size.height * .5,
          width: mediaQuery.size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                LendenAppTheme.primaryDark,
                LendenAppTheme.primary
              ])),
        ),
      ),
    ));
  }
}
