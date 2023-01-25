import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'app_theme.dart';

// ------------------- Assign Status ---------------------------

enum DeliveryStatus {
  Pickup,
  Validate,
  Delivery,
  Payment,
  Completed,
  Cancelled
}

/// Helper [OrderHelper] : OrderHelper for getting the values for the status
class OrderHelper {
  /// FUNC [getIconForOrder] : Get the Icon according to status
  static Icon getIconForOrder({@required String orderState, Color iconColor}) {
    Color color = iconColor == null ? Colors.white : iconColor;
    switch (orderState) {
      case "READYFORPICKUP":
        return Icon(
          FontAwesomeIcons.clock,
          color: color,
          size: 20,
        );
      case "PICKINGUP":
        return Icon(
          FontAwesomeIcons.truck,
          color: color,
          size: 18,
        );
      case "DELIVERED":
        return Icon(
          FontAwesomeIcons.checkSquare,
          color: color,
          size: 20,
        );
      case "DELIVERY_FAILURE":
        return Icon(
          FontAwesomeIcons.times,
          color: color,
          size: 20,
        );
      case "CANCELLED":
        return Icon(
          FontAwesomeIcons.times,
          color: color,
          size: 20,
        );
      default:
        return Icon(
          FontAwesomeIcons.clock,
          color: color,
          size: 20,
        );
    }
  }

  /// Color [getColorForAssign] : Get the color for status
  static Color getColorForOrder(String orderState) {
    switch (orderState) {
      case "READYFORPICKUP":
        return LendenAppTheme.accent;
      case "PICKINGUP":
        return LendenAppTheme.ratingColor;
      case "INTRANSIT":
        return LendenAppTheme.ratingColor;
      case "DELIVERED":
        return LendenAppTheme.greenColor;
      case "DELIVERY_FAILURE":
        return Colors.redAccent;
      case "CANCELLED":
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  /// String [getStringForOrder] : Get the string text for status
  static String getStringForOrder(String orderState) {
    switch (orderState) {
      case "READYFORPICKUP":
        return "Ready for Pickup";
      case "DELIVERED":
        return "Delivered";
      case "PICKINGUP":
        return "Picking Up";
      case "CANCELLED":
        return "Cancelled";
      case "DELIVERY_FAILURE":
        return "Delivery Failure";
      default:
        return "Assigned";
    }
  }

  /// String [getStringForOrder] : Get the string text for status
  static String getStringForDelivery(String orderStatus) {
    switch (orderStatus) {
      case "READYFORPICKUP":
        return "Ready for Pickup";
      case "DELIVERED":
        return "Delivered";
      case "PICKINGUP":
        return "Picking Up";
      case "PICKEDUP":
        return "Picked Up";
      case "INTRANSIT":
        return "In-Transit";
      case "CANCELLED":
        return "Cancelled";
      case "DELIVERY_FAILURE":
        return "Delivery Failure";
      default:
        return "READYFORPICKUP";
    }
  }
}
