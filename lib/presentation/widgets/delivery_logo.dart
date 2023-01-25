import 'package:flutter/material.dart';

import '../../core/theme/assets.dart';
import '../../core/theme/strings.dart';

/// Widget [LendenLogo] : The LendenLogo for showing logo when needed
class LendenLogo extends StatelessWidget {
  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final _mHeight = mediaQuery.size.height;
    final _mWidth = mediaQuery.size.width;
    return Column(
      children: [
        Container(
          child: Image.asset(
            AssetsSource.logoVerticalNorImg,
            height: _mHeight * 0.15,
            width: _mWidth * 0.4,
          ),
        ),
        SizedBox(
          height: _mHeight * 0.012,
        ),
        Text(
          Strings.deliveryTitle,
          style: Theme.of(context).textTheme.headline5.copyWith(
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: Color(0xff223741),
              fontFamily: "Raleway"),
        )
      ],
    );
  }
}
