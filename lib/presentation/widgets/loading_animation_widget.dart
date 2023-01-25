import 'package:flutter/material.dart';
import 'package:lenden_delivery/core/theme/assets.dart';
import 'package:lottie/lottie.dart';

class LoadingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Lottie.asset(AssetsSource.loading,
          height: _mHeight * 0.07, fit: BoxFit.contain, repeat: true),
    );
  }
}
