import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_theme.dart';

/// Widget [Badge] : The Badge is the state showing cancel order info on the top
class Badge extends StatelessWidget {
  final Widget child;
  final Color color;

  const Badge({
    @required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          left: 0,
          top: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color != null ? color : LendenAppTheme.redColor,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: const Icon(
              FontAwesomeIcons.timesCircle,
              color: Colors.white,
              size: 10,
            ),
          ),
        )
      ],
    );
  }
}
