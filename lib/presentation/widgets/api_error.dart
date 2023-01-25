import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/assets.dart';

/// Widget [APIError] : The APIError is the state showing error of the api
class APIError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: _height * 0.35,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Lottie.asset(AssetsSource.apiError,
                fit: BoxFit.fill, repeat: true),
          ),
          SizedBox(
            height: _height * 0.0015,
          ),
          Text(
            "Sorry! Something went wrong.\n Please try again!",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: LendenAppTheme.grey),
          )
        ],
      ),
    );
  }
}
