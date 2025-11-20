import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideSharingMapController extends GetxController {
  String googleApiKey = 'AIzaSyDRjM3xxFgdn4_67tNnr_XY91Qw5HXw5AU';
  final googleMapController = Rxn<GoogleMapController>();
  final Rx<LatLng?> from = Rxn<LatLng>();
  final Rx<LatLng?> to = Rxn<LatLng>();
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rxn<LatLng> vehiclePosition = Rxn<LatLng>();
  final RxDouble vehicleRotation = 0.0.obs;
  Timer? _animationTimer;
  final RxList<LatLng> _routePoints = <LatLng>[].obs;
  Duration stepDuration = const Duration(milliseconds: 800);
  double vehicleSpeedMetersPerSecond = 10.0;

  @override
  void onInit() {
    super.onInit();
    _openBottomSheet();
  }

  void _openBottomSheet() {
    if (Get.context != null) {
      DialogHelper.showRideSharingMapBottomSheet(Get.context!);
    }
  }

  void setGoogleApiKey(String key) {
    googleApiKey = key;
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapController.value = controller;
  }

  void clearRoute() {
    _animationTimer?.cancel();
    _routePoints.clear();
    polylines.clear();
    markers.clear();
    vehiclePosition.value = null;
    vehicleRotation.value = 0.0;
  }

  Future<void> setFromTo(LatLng fromLatLng, LatLng toLatLng, {bool animateCamera = true, bool startMove = true}) async {
    clearRoute();
    from.value = fromLatLng;
    to.value = toLatLng;
    markers.add(Marker(
      markerId: const MarkerId('from'),
      position: fromLatLng,
      infoWindow: const InfoWindow(title: 'From'),
    ));
    markers.add(Marker(
      markerId: const MarkerId('to'),
      position: toLatLng,
      infoWindow: const InfoWindow(title: 'To'),
    ));
    if (animateCamera && googleMapController.value != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(min(fromLatLng.latitude, toLatLng.latitude), min(fromLatLng.longitude, toLatLng.longitude)),
        northeast: LatLng(max(fromLatLng.latitude, toLatLng.latitude), max(fromLatLng.longitude, toLatLng.longitude)),
      );
      try {
        await googleMapController.value!.moveCamera(CameraUpdate.newLatLngBounds(bounds, 60));
      } catch (_) {
        // ignore camera movement errors
      }
    }

    // Fetch route from Google Directions (returns encoded polyline) and decode
    final encoded = await fetchEncodedPolyline(fromLatLng, toLatLng);
    log("EncodedMapValue: $encoded");
    if (encoded != null && encoded.isNotEmpty) {
      final points = decodeEncodedPolyline(encoded);
      _routePoints.assignAll(points);
      // Add polyline on map
      polylines.add(Polyline(
        polylineId: const PolylineId('route'),
        color: AppColors.primary,
        points: _routePoints,
        width: 6,
      ));
      // Place vehicle initially at the 'from' point
      if (_routePoints.isNotEmpty) {
        vehiclePosition.value = _routePoints.first;
        markers.add(await _vehicleMarker(vehiclePosition.value!, vehicleRotation.value));
      }
      if (startMove) startVehicleAnimation();
    }
  }

  Future<String?> fetchEncodedPolyline(LatLng origin, LatLng dest) async {
    if (googleApiKey.isEmpty || googleApiKey.contains('<YOUR')) {
      debugPrint('Google API key is not set.');
      return null;
    }
    final url = Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes');
    try {
      final dioObj = dio.Dio();
      final response = await dioObj.post(
        url.toString(), // Dio expects a String URL
        options: dio.Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': googleApiKey,
            'X-Goog-FieldMask': 'routes.polyline.encodedPolyline',
          },
        ),
        data: {
          "origin": {
            "location": {
              "latLng": {
                "latitude": origin.latitude,
                "longitude": origin.longitude,
              }
            }
          },
          "destination": {
            "location": {
              "latLng": {
                "latitude": dest.latitude,
                "longitude": dest.longitude,
              }
            }
          },
          "travelMode": "DRIVE",
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final encoded = data["routes"]?[0]?["polyline"]?["encodedPolyline"];
        return encoded ?? "";
      } else {
        debugPrint("Routes API error: ${response.statusCode} ${response.statusMessage}");
      }
    } catch (e) {
      debugPrint("fetchEncodedPolyline error: $e");
    }
    return null;
  }

  void startVehicleAnimation({bool loop = false}) {
    if (_routePoints.isEmpty) return;
    _animationTimer?.cancel();
    int index = 0;
    _animationTimer = Timer.periodic(stepDuration, (timer) async {
      if (_routePoints.length <= 1) return;
      final nextIndex = (index + 1) % _routePoints.length;
      final current = _routePoints[index];
      final next = _routePoints[nextIndex];
      // update rotation
      vehicleRotation.value = bearingBetweenLatLng(current, next);
      // move vehicle to the next point (for smoother movement you can interpolate)
      vehiclePosition.value = next;
      // update marker set with new vehicle marker
      markers.removeWhere((m) => m.markerId.value == 'vehicle');
      markers.add(await _vehicleMarker(vehiclePosition.value!, vehicleRotation.value));
      index = nextIndex;
      if (!loop && index == _routePoints.length - 1) {
        timer.cancel();
      }
    });
  }

  void stopVehicleAnimation() {
    _animationTimer?.cancel();
  }

  Future<Marker> _vehicleMarker(LatLng pos, double rotation) async {
    final BitmapDescriptor carIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/car_bentley.png',
    );
    return Marker(
      markerId: const MarkerId('vehicle'),
      position: pos,
      rotation: rotation,
      anchor: const Offset(0.5, 0.5),
      flat: true,
      infoWindow: const InfoWindow(title: 'Vehicle'),
      icon: carIcon,
    );
  }

  List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = <LatLng>[];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int shift = 0, result = 0;
      while (true) {
        final int b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
        if (b < 0x20) break;
      }
      final int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;
      shift = 0;
      result = 0;
      while (true) {
        final int b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
        if (b < 0x20) break;
      }
      final int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;
      final point = LatLng(lat / 1e5, lng / 1e5);
      poly.add(point);
    }
    return poly;
  }

  double bearingBetweenLatLng(LatLng a, LatLng b) {
    final lat1 = _toRadians(a.latitude);
    final lon1 = _toRadians(a.longitude);
    final lat2 = _toRadians(b.latitude);
    final lon2 = _toRadians(b.longitude);
    final dLon = lon2 - lon1;
    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    final brng = _toDegrees(math.atan2(y, x));
    return (brng + 360) % 360;
  }

  double _toRadians(double deg) => deg * (math.pi / 180.0);

  double _toDegrees(double rad) => rad * (180.0 / math.pi);
}

double min(double a, double b) => a < b ? a : b;

double max(double a, double b) => a > b ? a : b;
