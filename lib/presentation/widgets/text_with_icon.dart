import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// Widget [TextWithIcon] : The TextWithIcon for displaying text with icon
class TextWithIcon extends StatelessWidget {
  final Icon icon;
  final String text;
  final MainAxisAlignment mainAxisAlignment;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double spacing;

  const TextWithIcon(
      {@required this.icon,
      @required this.text,
      this.mainAxisAlignment,
      @required this.textStyle,
      this.spacing,
      this.padding});

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    ThemeData _themeConst = Theme.of(context);
    var _mHeight = _mediaQuery.size.height;
    var _mWidth = _mediaQuery.size.width;
    return Padding(
      padding: padding == null
          ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10)
          : padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment == null
            ? MainAxisAlignment.start
            : mainAxisAlignment,
        children: [
          icon,
          SizedBox(
            width: spacing == null ? _mWidth * 0.03 : spacing,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              text,
              maxLines: 2,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
