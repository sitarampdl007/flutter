import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:http/http.dart' as http;

import '../../features/client/client_model.dart';
import '../../features/order/order_model.dart';

const GOOGLE_API_KEY = "AIzaSyAZxBrAT2bQZg_KIIhx109DvUWrFl_XzYQ";

/// Helper [LocationHelper] : Help to carry out various location queries
class LocationHelper {
  static const String googleStaticMapUrl =
      "https://maps.googleapis.com/maps/api/staticmap";
  static const String pickUpMarker = "&markers=color:blue%7Clabel:P%7C";
  static const String userMarker = "&markers=color:red%7Clabel:U%7C";
  static const String dropUpMarker = "&markers=color:green%7Clabel:D%7C";
  static const String mapSettings = "?zoom=12&size=600x400&maptype=roadmap";

  /// FUNC [getUserLocation] : Get user location and check permission
  static Future<geo.Position> getUserLocation() async {
    return geo.Geolocator.getCurrentPosition(
      desiredAccuracy: geo.LocationAccuracy.medium,
    );
  }

  /// FUNC [getBytesFromAsset] : Get bytes from markers icon
  static Future<Uint8List> getBytesFromAsset(
      String path, int height, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: height, targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  /// FUNC [getLocationPreviewImg] : Get static image of the map
  static String getLocationPreviewImg(
      {@required Location pickup,
      @required DoubleLocation dropOff,
      @required String type}) {
    String url;
    //parse to double
    double pLat = double.parse(pickup.latitude);
    double pLong = double.parse(pickup.longitude);
    // double dLat = double.parse(dropOff.latitude);
    // double dLong = double.parse(dropOff.longitude);
    if (type == "UserPickup") {
      url = LocationHelper.googleStaticMapUrl +
          mapSettings +
          userMarker +
          '$pLat,$pLong' +
          pickUpMarker +
          '${dropOff.latitude},${dropOff.longitude}&key=$GOOGLE_API_KEY';
    } else if (type == "UserDelivery") {
      url = dropOff == null
          ? LocationHelper.googleStaticMapUrl +
              mapSettings +
              userMarker +
              '$pLat,$pLong' +
              '&key=$GOOGLE_API_KEY'
          : LocationHelper.googleStaticMapUrl +
              mapSettings +
              userMarker +
              '$pLat,$pLong' +
              dropUpMarker +
              '${dropOff.latitude},${dropOff.longitude}&key=$GOOGLE_API_KEY';
    } else {
      url = dropOff == null
          ? LocationHelper.googleStaticMapUrl +
              mapSettings +
              pickUpMarker +
              '$pLat,$pLong' +
              '&key=$GOOGLE_API_KEY'
          : LocationHelper.googleStaticMapUrl +
              mapSettings +
              pickUpMarker +
              '$pLat,$pLong' +
              dropUpMarker +
              '${dropOff.latitude},${dropOff.longitude}&key=$GOOGLE_API_KEY';
    }

    return url;
  }

  /// FUNC [getMultipleLocationPreviewImg] : Get static image with multiple markers map
  static String getMultipleLocationPreviewImg(
      {String pickup, String delivery}) {
    String url = LocationHelper.googleStaticMapUrl +
        mapSettings +
        pickup +
        delivery +
        '&key=$GOOGLE_API_KEY';
    return url;
  }

  /// FUNC [getLocationAddress] : Get static image of the map
  static Future<String> getLocationAddress(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY";
    final response = await http.get(Uri(scheme: url));
    print(response.body);
    final extractedData =
        json.decode(response.body)['results'][0]['formatted_address'];
    return extractedData;
  }
}
