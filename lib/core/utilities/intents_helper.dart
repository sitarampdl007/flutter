import 'package:url_launcher/url_launcher.dart';

import '../../features/order/order_model.dart';

/// Helper [IntentsHelper] : Help to launch various actions from the app
class IntentsHelper {
  static Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewWithJavaScript(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchInWebViewWithDomStorage(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableDomStorage: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  static Future<void> makePhoneCall(String number) async {
    String phoneUrl = "tel:" + number;
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

  static Future<void> navigateFromTo(Location from, Location to) async {
    // String navigationUrl =
    //     "geo:${from.latitude},${from.longitude}?q=${to.latitude},${to.longitude}";
    String nav =
        'http://maps.google.com/maps?saddr=${from.latitude},${from.longitude}&daddr=${to.latitude},${to.longitude}';
    if (await canLaunch(nav)) {
      await launch(nav);
    } else {
      throw 'Could not launch $nav';
    }
  }
}
