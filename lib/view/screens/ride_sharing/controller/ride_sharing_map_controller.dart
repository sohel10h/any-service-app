import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_la/services/di/app_di_controller.dart';

class RideSharingMapController extends GetxController {
  String googleApiKey = 'AIzaSyDRjM3xxFgdn4_67tNnr_XY91Qw5HXw5AU';
  final googleMapController = Rxn<GoogleMapController>();
  final Rxn<Position> currentPosition = Rxn<Position>();
  final Rxn<LatLng> initialCameraTarget = Rxn<LatLng>();
  final RxDouble initialCameraZoom = 15.0.obs;
  final RxDouble mapBottomPadding = 200.0.obs;
  final RxBool isBottomCardVisible = true.obs;
  final Rxn<LatLng> from = Rxn<LatLng>();
  final Rxn<LatLng> to = Rxn<LatLng>();
  final RxSet<Polyline> polylines = <Polyline>{}.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rxn<LatLng> vehiclePosition = Rxn<LatLng>();
  final RxDouble vehicleRotation = 0.0.obs;
  final RxList<LatLng> _routePoints = <LatLng>[].obs;
  Timer? _animationTimer;
  Duration stepDuration = const Duration(milliseconds: 800);
  double vehicleSpeedMetersPerSecond = 10.0;
  final TextEditingController fromTextController = TextEditingController();
  final TextEditingController toTextController = TextEditingController();
  final StreamController<List<Map<String, dynamic>>> _fromSuggestionsController = StreamController.broadcast();
  final StreamController<List<Map<String, dynamic>>> _toSuggestionsController = StreamController.broadcast();

  Stream<List<Map<String, dynamic>>> get fromAutoCompleteStream => _fromSuggestionsController.stream;

  Stream<List<Map<String, dynamic>>> get toAutoCompleteStream => _toSuggestionsController.stream;
  Timer? _debounceFrom;
  Timer? _debounceTo;
  final RxString driverImageUrl = 'https://i.pravatar.cc/150?img=12'.obs;
  final RxString carImageUrl = 'https://pngimg.com/uploads/audi/audi_PNG1764.png'.obs;
  final String mastercardLogoUrl = 'https://pngimg.com/uploads/mastercard/mastercard_PNG1.png';
  final dio.Dio _dio = dio.Dio();
  final appDIController = Get.find<AppDIController>();
  final RxDouble rotationValue = 0.0.obs;
  RxBool isPriceToggleOn = false.obs;
  final TextEditingController priceTextController = TextEditingController();
  final FocusNode priceFocusNode = FocusNode();
  RxString userCountryCode = "".obs;
  final List<Map<String, dynamic>> rideOptions = [
    {
      "avatar": "https://i.pravatar.cc/150?img=12",
      "plate": "BGK-5623",
      "car": "Toyota Sienna",
      "carImage": "https://pngimg.com/d/toyota_PNG1917.png",
      "paymentLogo": "https://pngimg.com/uploads/mastercard/mastercard_PNG1.png",
      "paymentMethod": "Mastercard",
      "balance": "\$500",
      "bookingText": "Book MoveEasy\n\$15.90",
    },
    {
      "avatar": "https://i.pravatar.cc/150?img=4",
      "plate": "XYZ-1234",
      "car": "Honda Civic",
      "carImage": "https://pngimg.com/uploads/honda/small/honda_PNG102938.png",
      "paymentLogo": "https://pngimg.com/uploads/visa/visa_PNG17.png",
      "paymentMethod": "Visa",
      "balance": "\$300",
      "bookingText": "Book QuickRide\n\$12.50",
    },
    {
      "avatar": "https://i.pravatar.cc/150?img=7",
      "plate": "LMN-9876",
      "car": "BMW X5",
      "carImage": "https://pngimg.com/uploads/mustang/small/mustang_PNG40655.png",
      "paymentLogo": "https://pngimg.com/uploads/paypal/paypal_PNG22.png",
      "paymentMethod": "PayPal",
      "balance": "\$800",
      "bookingText": "Book LuxuryRide\n\$25.00",
    },
    {
      "avatar": "https://i.pravatar.cc/150?img=1",
      "plate": "JKL-3456",
      "car": "Tesla Model 3",
      "carImage": "https://pngimg.com/uploads/taxi/small/taxi_PNG74.png",
      "paymentLogo": "https://pngimg.com/uploads/mastercard/mastercard_PNG1.png",
      "paymentMethod": "Amex",
      "balance": "\$1000",
      "bookingText": "Book EcoRide\n\$18.75",
    },
    {
      "avatar": "https://i.pravatar.cc/150?img=60",
      "plate": "PQR-2468",
      "car": "Hyundai Sonata",
      "carImage": "https://pngimg.com/uploads/bmw/small/bmw_PNG99566.png",
      "paymentLogo": "https://pngimg.com/uploads/visa/visa_PNG17.png",
      "paymentMethod": "Discover",
      "balance": "\$450",
      "bookingText": "Book SmartRide\n\$14.20",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
    _initLocation();
  }

  Future<void> _initLocation() async {
    await appDIController.locationService.startListening();
    final pos = await appDIController.locationService.waitForFirstPosition();
    currentPosition.value = pos;
    fromTextController.text = await appDIController.locationService.getAddressFromLatLng(pos) ?? "";
    final countryCode = await appDIController.locationService.getCountryCodeFromLatLng(pos) ?? "";
    userCountryCode.value = countryCode.toLowerCase();
    initialCameraTarget.value = LatLng(pos.latitude, pos.longitude);
    log("Got first runtime location: ${pos.latitude}, ${pos.longitude}");
  }

  void onMapCreated(GoogleMapController controller) async {
    googleMapController.value = controller;
    await Future.delayed(const Duration(milliseconds: 200));
    mapBottomPadding.value = 280.0;
    if (initialCameraTarget.value != null) {
      controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: initialCameraTarget.value!, zoom: initialCameraZoom.value),
        ),
      );
    }
  }

  void onQueryChanged(String query, {required bool isFrom}) {
    if ((isFrom && _debounceFrom != null) || (!isFrom && _debounceTo != null)) {
      (isFrom ? _debounceFrom : _debounceTo)!.cancel();
    }
    final timer = Timer(const Duration(milliseconds: 300), () {
      if (query.trim().isEmpty) {
        if (isFrom) {
          _fromSuggestionsController.add([]);
        } else {
          _toSuggestionsController.add([]);
        }
        return;
      }
      _fetchPlaceAutocomplete(query).then((list) {
        if (isFrom) {
          _fromSuggestionsController.add(list);
        } else {
          _toSuggestionsController.add(list);
        }
      });
    });
    if (isFrom) {
      _debounceFrom = timer;
    } else {
      _debounceTo = timer;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPlaceAutocomplete(String input) async {
    if (googleApiKey.isEmpty) return [];
    final country = userCountryCode.value;
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    try {
      final response = await _dio.get(url, queryParameters: {
        'input': input,
        'key': googleApiKey,
        'language': 'en',
        'components': 'country:$country',
        'types': 'geocode',
      });
      if (response.statusCode == 200) {
        final data = response.data;
        final predictions = data['predictions'] as List<dynamic>? ?? [];
        return predictions.map<Map<String, dynamic>>((p) {
          return {
            'place_id': p['place_id'],
            'description': p['description'],
            'structured_formatting': p['structured_formatting'],
          };
        }).toList();
      }
    } catch (e) {
      log('autocomplete error: $e');
    }
    return [];
  }

  Future<LatLng?> _getLatLngFromPlaceId(String placeId) async {
    if (googleApiKey.isEmpty) return null;
    final url = 'https://maps.googleapis.com/maps/api/place/details/json';
    try {
      final response = await _dio.get(url, queryParameters: {
        'place_id': placeId,
        'key': googleApiKey,
        'fields': 'geometry,name,formatted_address',
      });
      if (response.statusCode == 200) {
        final result = response.data['result'];
        final location = result?['geometry']?['location'];
        if (location != null) {
          final lat = (location['lat'] as num).toDouble();
          final lng = (location['lng'] as num).toDouble();
          return LatLng(lat, lng);
        }
      }
    } catch (e) {
      log('place details error: $e');
    }
    return null;
  }

  Future<void> onPlaceSelected(Map<String, dynamic> place, {required bool isFrom}) async {
    final placeId = place['place_id'] as String?;
    final description = place['description'] as String?;
    if (placeId == null) return;
    final latLng = await _getLatLngFromPlaceId(placeId);
    if (latLng == null) return;
    if (isFrom) {
      from.value = latLng;
      fromTextController.text = description ?? '';
      _fromSuggestionsController.add([]);
      _addMarkerAt(latLng, id: 'from', title: description ?? 'From');
    } else {
      to.value = latLng;
      toTextController.text = description ?? '';
      _toSuggestionsController.add([]);
      _addMarkerAt(latLng, id: 'to', title: description ?? 'To');
    }
    // if both ready, trigger route fetch
    if (from.value != null && to.value != null) {
      await setFromTo(from.value!, to.value!, animateCamera: true, startMove: true);
    }
  }

  void clearFrom() {
    from.value = null;
    fromTextController.clear();
    _fromSuggestionsController.add([]);
    markers.removeWhere((m) => m.markerId.value == 'from');
    polylines.clear();
    stopVehicleAnimation();
  }

  void clearTo() {
    to.value = null;
    toTextController.clear();
    _toSuggestionsController.add([]);
    markers.removeWhere((m) => m.markerId.value == 'to');
    polylines.clear();
    stopVehicleAnimation();
  }

  void _addMarkerAt(LatLng pos, {required String id, String? title}) {
    markers.removeWhere((m) => m.markerId.value == id);
    markers.add(Marker(markerId: MarkerId(id), position: pos, infoWindow: InfoWindow(title: title ?? id)));
  }

  Future<void> setFromTo(LatLng fromLatLng, LatLng toLatLng, {bool animateCamera = true, bool startMove = true}) async {
    clearRoute();
    from.value = fromLatLng;
    to.value = toLatLng;
    _addMarkerAt(fromLatLng, id: 'from', title: 'From');
    _addMarkerAt(toLatLng, id: 'to', title: 'To');
    if (animateCamera && googleMapController.value != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(min(fromLatLng.latitude, toLatLng.latitude), min(fromLatLng.longitude, toLatLng.longitude)),
        northeast: LatLng(max(fromLatLng.latitude, toLatLng.latitude), max(fromLatLng.longitude, toLatLng.longitude)),
      );
      try {
        await googleMapController.value!.moveCamera(CameraUpdate.newLatLngBounds(bounds, 60));
      } catch (_) {}
    }
    final encoded = await fetchEncodedPolyline(fromLatLng, toLatLng);
    log("EncodedMapValue: $encoded");
    if (encoded != null && encoded.isNotEmpty) {
      final points = decodeEncodedPolyline(encoded);
      _routePoints.assignAll(points);
      polylines.add(Polyline(polylineId: const PolylineId('route'), color: AppColors.primary, points: _routePoints, width: 6));
      if (_routePoints.isNotEmpty) {
        vehiclePosition.value = _routePoints.first;
        final marker = await _vehicleMarker(vehiclePosition.value!, vehicleRotation.value);
        markers.removeWhere((m) => m.markerId.value == 'vehicle');
        markers.add(marker);
      }
      if (startMove) startVehicleAnimation();
    }
  }

  void clearRoute() {
    _animationTimer?.cancel();
    _routePoints.clear();
    polylines.clear();
    markers.removeWhere((m) => m.markerId.value == 'vehicle' || m.markerId.value == 'from' || m.markerId.value == 'to');
    vehiclePosition.value = null;
    vehicleRotation.value = 0.0;
  }

  Future<String?> fetchEncodedPolyline(LatLng origin, LatLng dest) async {
    if (googleApiKey.isEmpty || googleApiKey.contains('<YOUR')) {
      debugPrint('Google API key is not set.');
      return null;
    }
    final url = Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes');
    try {
      final response = await _dio.post(
        url.toString(),
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
      vehicleRotation.value = bearingBetweenLatLng(current, next);
      vehiclePosition.value = next;
      markers.removeWhere((m) => m.markerId.value == 'vehicle');
      final marker = await _vehicleMarker(vehiclePosition.value!, vehicleRotation.value);
      markers.add(marker);
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
    try {
      final String path = 'assets/images/car_bentley.png';
      final BitmapDescriptor carIcon = await BitmapDescriptor.asset(const ImageConfiguration(size: Size(48, 48)), path);
      return Marker(
        markerId: const MarkerId('vehicle'),
        position: pos,
        rotation: rotation,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        infoWindow: const InfoWindow(title: 'Vehicle'),
        icon: carIcon,
      );
    } catch (e) {
      return Marker(
        markerId: const MarkerId('vehicle'),
        position: pos,
        rotation: rotation,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
    }
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

  double min(double a, double b) => a < b ? a : b;

  double max(double a, double b) => a > b ? a : b;

  Future<void> onBothLocationsReady() async {
    if (from.value != null && to.value != null) {
      await setFromTo(from.value!, to.value!, animateCamera: true, startMove: true);
    }
  }

  void disposeEverything() {
    _animationTimer?.cancel();
    _fromSuggestionsController.close();
    _toSuggestionsController.close();
    priceTextController.dispose();
    priceFocusNode.dispose();
  }

  void _addListenerFocusNodes() {
    priceFocusNode.addListener(update);
  }

  @override
  void onClose() {
    disposeEverything();
    super.onClose();
  }
}
