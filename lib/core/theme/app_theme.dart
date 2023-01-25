import 'package:flutter/material.dart';

/// Helper [LendenAppTheme] : LendenAppTheme having the theme constants of the app
class LendenAppTheme {
  static const Color primary = Color(0xFF3D5CCA);
  static const Color primaryTry = Color(0xFF5593E6);
  static const Color primaryDark = Color(0xFF003C83);
  static const Color primaryLight = Color(0xFFE7EFFD);
  static const Color accent = Color(0xFF5593E6);
  static const Color redColor = Color(0xFFE35055);
  static const Color pinkColor = Color(0xFFEE3E71);

  static const Color background = Color(0xFFF2F3F8);
  static const Color commentBackground = Color(0xFFF7F4F4);
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color nearlyBlue = Color(0xFF00B6F0);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);

  static const Color spacer = Color(0xFFF2F2F2);
  static const Color recentItemText = Color(0xFF454545);
  static const Color ratingColor = Color(0xFFEE9A4D);
  static const Color greenColor = Color(0xFF00A86B);

  /// FUNC [primaryThemeData] : get the primary theme for app
  ThemeData get primaryThemeData => ThemeData(
        primaryColor: LendenAppTheme.primary,
        accentColor: LendenAppTheme.accent,
        primaryColorDark: LendenAppTheme.primary,
        primaryColorLight: LendenAppTheme.primaryLight,
        fontFamily: "Graphik",
        appBarTheme: AppBarTheme(
          textTheme: const TextTheme(
            headline6: const TextStyle(
                fontFamily: "Graphik",
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}
