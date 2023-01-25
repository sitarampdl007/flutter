import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/theme/assets.dart';
import '../../../core/utilities/intents_helper.dart';
import '../../../core/utilities/location_helper.dart';
import '../../../features/client/client_model.dart';
import '../../../features/order/order_model.dart';

/// [MapScreen] : The MapScreen shows the map with pickup and drop off
class MapScreen extends StatefulWidget {
  //Route
  static const String routeName = "/map_screen";

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  //vars
  BitmapDescriptor _pickUpIcon, _dropOffIcon, _userIcon;
  Set<Marker> _markers = {};
  List<DoubleLocation> _deliveryLocations = [];
  List<Location> _pickUpLocations = [];
  bool _isInit = true;
  Location _pickUpLocation;
  DoubleLocation _deliveryLocation;
  String _pickUpAddress, _deliveryAddress;
  Location _userLocation;
  String _mapType;

  @override
  void initState() {
    super.initState();
    setCustomPin();
  }
  // =========================== Marker Function ===========================

  /// FUNC [setCustomPin] : Help setting icons to the map
  void setCustomPin() async {
    final Uint8List pickUpByte = await LocationHelper.getBytesFromAsset(
        AssetsSource.pickUpMarker, 125, 125);
    _pickUpIcon = BitmapDescriptor.fromBytes(pickUpByte);
    final Uint8List dropOffByte = await LocationHelper.getBytesFromAsset(
        AssetsSource.deliveryMarker, 125, 125);
    _dropOffIcon = BitmapDescriptor.fromBytes(dropOffByte);
    final Uint8List userByte = await LocationHelper.getBytesFromAsset(
        AssetsSource.userMarker, 125, 125);
    _userIcon = BitmapDescriptor.fromBytes(userByte);
  }

  /// FUNC [deliveryMarker] : Help setting delivery icons
  Marker deliveryMarker(DoubleLocation delivery, int index) {
    return Marker(
      markerId: MarkerId("p$index"),
      icon: _dropOffIcon,
      infoWindow: InfoWindow(
        title: "Delivery",
        snippet: _deliveryAddress,
      ),
      position: LatLng(delivery.latitude, delivery.longitude),
    );
  }

  /// FUNC [pickUpMarker] : Help setting pickup icons
  Marker pickUpMarker(Location pickup, int index) {
    return Marker(
      markerId: MarkerId("d$index"),
      icon: _pickUpIcon,
      infoWindow: InfoWindow(
        title: "Pickup",
        snippet: _pickUpAddress,
      ),
      position:
          LatLng(double.parse(pickup.latitude), double.parse(pickup.longitude)),
    );
  }

  /// FUNC [pickUpMarker] : Help setting pickup icons
  Marker userMarker(Location user, int index) {
    return Marker(
      markerId: MarkerId("u$index"),
      icon: _userIcon,
      infoWindow: InfoWindow(
        title: "Your Location",
        snippet: "",
      ),
      position:
          LatLng(double.parse(user.latitude), double.parse(user.longitude)),
    );
  }

  /// FUNC [addMarkersToMap] : Help setting multiple markers to the map
  void addMarkersToMap() {
    setState(() {
      if (_pickUpLocations.isNotEmpty) {
        int i = 0;
        _pickUpLocations.forEach((pickUpLocation) {
          Marker pickUp = pickUpMarker(pickUpLocation, i);
          _markers.add(pickUp);
          i++;
        });
      }
      if (_deliveryLocations.isNotEmpty) {
        int j = 0;
        _deliveryLocations.forEach((deliveryLocation) {
          Marker dropOff = deliveryMarker(deliveryLocation, j);
          _markers.add(dropOff);
          j++;
        });
      }
    });
  }

  /// FUNC [addMarkersToMap] : Help setting multiple markers to the map
  void addNormalMarkerToMap() {
    setState(() {
      _markers.add(pickUpMarker(_pickUpLocation, 0));
      _markers.add(deliveryMarker(_deliveryLocation, 0));
    });
  }

  /// FUNC [addUserPickupMarkerToMap] : Help setting multiple markers to the map
  void addUserPickupMarkerToMap() {
    setState(() {
      setState(() {
        _markers.add(userMarker(_userLocation, 0));
        _markers.add(pickUpMarker(_pickUpLocation, 0));
      });
    });
  }

  /// FUNC [addUserDeliveryMarkerToMap] : Help setting multiple markers to the map
  void addUserDeliveryMarkerToMap() {
    setState(() {
      setState(() {
        if (_userLocation != null) {
          _markers.add(userMarker(_userLocation, 0));
        }
        if (_deliveryLocation != null) {
          _markers.add(deliveryMarker(_deliveryLocation, 0));
        }
      });
    });
  }

  // FUNC: for accessing route arguments
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final Map<String, dynamic> locationMap =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _mapType = locationMap['mapType'];
      switch (_mapType) {
        case "Normal":
          _pickUpLocation = locationMap['from'];
          _pickUpAddress = locationMap['fromAddress'];
          _deliveryLocation = locationMap['to'];
          _deliveryAddress = locationMap['toAddress'];
          break;
        case "UserPickup":
          _userLocation = locationMap['from'];
          _pickUpLocation = locationMap['to'];
          break;
        case "UserDelivery":
          _userLocation = locationMap['from'];
          _deliveryLocation = locationMap['to'];
          break;
        case "Multiple":
          _deliveryLocations = locationMap.containsKey('deliveryList')
              ? locationMap['deliveryList']
              : [];
          _pickUpLocations = locationMap.containsKey('pickupList')
              ? locationMap['pickupList']
              : [];
          break;
        default:
          _pickUpLocation = locationMap['from'];
          _deliveryLocation = locationMap['to'];
          break;
      }
    }
    _isInit = false;
  }

  // =========================== Build Function ===========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
        actions: [
          if (_mapType == "UserPickup" || _mapType == "UserDelivery")
            IconButton(
              padding: const EdgeInsets.only(right: 20),
              icon: Icon(FontAwesomeIcons.locationArrow),
              onPressed: () async {
                if (_mapType == "UserPickup") {
                  await IntentsHelper.navigateFromTo(
                      _userLocation, _pickUpLocation);
                } else {
                  Location delLocation = Location(
                      _deliveryLocation.latitude.toString(),
                      _deliveryLocation.longitude.toString());
                  await IntentsHelper.navigateFromTo(
                      _userLocation, delLocation);
                }
              },
            )
        ],
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        onMapCreated: (controller) {
          switch (_mapType) {
            case "Normal":
              addNormalMarkerToMap();
              break;
            case "UserPickup":
              addUserPickupMarkerToMap();
              break;
            case "UserDelivery":
              addUserDeliveryMarkerToMap();
              break;
            case "Multiple":
              addMarkersToMap();
              break;
            default:
              addNormalMarkerToMap();
              break;
          }
        },
        myLocationButtonEnabled: true,
        onTap: null,
        initialCameraPosition:
            CameraPosition(target: LatLng(27.7172, 85.3240), zoom: 14),
        markers: _markers,
      ),
    );
  }
}
