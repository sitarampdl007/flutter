import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';
import '../theme/strings.dart';

// ------------------- PROFILE ---------------------------

const kProfileEmailInputDeco = InputDecoration(
    errorStyle: TextStyle(
      color: Colors.red,
    ),
    prefixIcon: Icon(
      FontAwesomeIcons.envelope,
    ),
    border: InputBorder.none,
    labelText: "Email",
    labelStyle: TextStyle(
      color: Colors.grey,
      fontSize: 18,
    ));

const kNameInputDeco = InputDecoration(
    errorStyle: TextStyle(
      color: Colors.red,
    ),
    prefixIcon: Icon(
      FontAwesomeIcons.user,
    ),
    border: InputBorder.none,
    labelText: "Name",
    labelStyle: TextStyle(color: Colors.grey, fontSize: 18));

const kPhoneInputDeco = InputDecoration(
  errorStyle: TextStyle(
    color: Colors.red,
  ),
  prefixIcon: Icon(
    FontAwesomeIcons.phoneAlt,
    size: 20,
  ),
  border: InputBorder.none,
  labelText: "Phone",
  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
);

const kCollegeInputDeco = InputDecoration(
    errorStyle: TextStyle(
      color: Colors.red,
    ),
    prefixIcon: Icon(
      FontAwesomeIcons.university,
    ),
    border: InputBorder.none,
    labelText: "College Name",
    labelStyle: TextStyle(color: Colors.grey, fontSize: 18));

// ------------------- REGISTER ---------------------------

const kRegisterNameInputDeco = InputDecoration(
  errorStyle: TextStyle(
    color: Colors.red,
  ),
  prefixIcon: Icon(
    Icons.person,
  ),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  labelText: "Full Name",
);

const kRegisterPhoneInputDeco = InputDecoration(
  errorStyle: TextStyle(
    color: Colors.red,
  ),
  prefixIcon: Icon(
    Icons.phone_android,
  ),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  labelText: "Mobile Number",
);

const kReportInputDeco = InputDecoration(
  errorStyle: TextStyle(
    color: Colors.red,
  ),
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  labelText: "Add a note",
);

const kEmailInputDeco = InputDecoration(
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    errorStyle: TextStyle(
      color: Colors.red,
    ),
    labelText: "Email Address",
    prefixIcon: Icon(
      Icons.mail,
    ),
    focusColor: LendenAppTheme.primaryDark);

const kPhoneLoginInputDeco = InputDecoration(
    border:
        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    errorStyle: TextStyle(
      color: Colors.red,
    ),
    labelText: Strings.phoneFormLabel,
    prefixIcon: Icon(
      Icons.call,
    ),
    focusColor: LendenAppTheme.primaryDark);

const kPasswordInputDeco = InputDecoration(
  border:
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
  errorStyle: TextStyle(
    color: Colors.red,
  ),
  prefixIcon: Icon(Icons.lock),
  labelText: "Password",
);

// ------------------- LOADING SPINNERS ---------------------------

final kLoadingSpinNormal = SpinKitFadingCube(
  size: 30,
  color: LendenAppTheme.primary,
);

final kLoadingSpinWhite = SpinKitFadingCube(
  size: 30,
  color: LendenAppTheme.nearlyWhite,
);

final kLoadingSpinNormalRed = SpinKitFadingCube(
  size: 35,
  color: LendenAppTheme.primary,
);

final kLoadingSpinLarge = SpinKitFadingCube(
  color: LendenAppTheme.primary,
);

final kLoadingSpinLargeRed = SpinKitFoldingCube(
  color: LendenAppTheme.primary,
  size: 50.0,
);

final kLoadingSpinSmall = SpinKitFadingCube(
  size: 10,
  color: LendenAppTheme.primary,
);

final kLoadingPdf = SpinKitFoldingCube(
  color: LendenAppTheme.primary,
  size: 50.0,
);

// ------------------- TEXT STYLES ---------------------------

const kTextStyleTitle = TextStyle(
  fontFamily: "OpenSans",
  fontWeight: FontWeight.bold,
  fontSize: 24,
);

const kTextStyleMedium =
    TextStyle(fontSize: 16, color: Colors.black, fontFamily: "OpenSans");

const kTextStyleMissingItem = TextStyle(
    fontSize: 18,
    color: LendenAppTheme.primaryDark,
    fontFamily: "OpenSans",
    fontWeight: FontWeight.w400);
