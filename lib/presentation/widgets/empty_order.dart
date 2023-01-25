import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/assets.dart';

/// Widget [EmptyOrder] : The EmptyOrder for showing empty orders state
class EmptyOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: _height * 0.45,
        child: Column(
          children: [
            Lottie.asset(AssetsSource.emptyBox,
                alignment: Alignment.topCenter,
                height: _height * 0.40,
                fit: BoxFit.fill,
                repeat: false),
            Text(
              "You don't have any orders right now!",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: LendenAppTheme.grey),
            ),
          ],
        ),
      ),
    );
  }
}
