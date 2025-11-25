import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_la/services/di/app_di_controller.dart';

class RideSharingMapLocationSearchController extends GetxController {
  String googleApiKey = 'AIzaSyDRjM3xxFgdn4_67tNnr_XY91Qw5HXw5AU';
  final Rxn<Position> currentPosition = Rxn<Position>();
  final Rxn<LatLng> from = Rxn<LatLng>();
  final Rxn<LatLng> to = Rxn<LatLng>();
  final RxInt tabIndex = 0.obs;
  final TextEditingController locationFromController = TextEditingController();
  final TextEditingController locationToController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  RxBool isPriceToggleOn = false.obs;
  final FocusNode locationFromFocusNode = FocusNode();
  final FocusNode locationToFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  final StreamController<List<Map<String, dynamic>>> _fromSuggestionsController = StreamController.broadcast();
  final StreamController<List<Map<String, dynamic>>> _toSuggestionsController = StreamController.broadcast();
  Timer? _debounceFrom;
  Timer? _debounceTo;
  final dio.Dio _dio = dio.Dio();
  final appDIController = Get.find<AppDIController>();
  RxString userCountryCode = "".obs;
  final RxBool isLocationFromSearch = false.obs;
  final RxBool isSearchingLocation = false.obs;
  final RxBool isLoadingCurrentLocation = false.obs;
  List<Map<String, dynamic>> recentList = [
    {
      "description": "Changi Airport",
      "locality": "Changi",
      "postal_code": "819643",
      "distanceKm": "5.2",
    },
    {
      "description": "Woodlands MRT Station",
      "locality": "Woodlands",
      "postal_code": "738343",
      "distanceKm": "2.8",
    },
    {
      "description": "Bugis Junction",
      "locality": "Bugis",
      "postal_code": "188021",
      "distanceKm": "7.4",
    },
  ];

  List<Map<String, dynamic>> suggestedList = [
    {
      "description": "Golden Village VivoCity",
      "locality": "HarbourFront",
      "postal_code": "098585",
      "distanceKm": "3.1",
    },
    {
      "description": "Singapore Botanic Gardens",
      "locality": "Tanglin",
      "postal_code": "259569",
      "distanceKm": "12.6",
    },
    {
      "description": "ION Orchard Mall",
      "locality": "Orchard",
      "postal_code": "238801",
      "distanceKm": "4.9",
    },
  ];

  List<Map<String, dynamic>> savedList = [
    {
      "description": "Home",
      "locality": "Yishun",
      "postal_code": "760101",
      "distanceKm": "0.0",
    },
    {
      "description": "Office",
      "locality": "Raffles Place",
      "postal_code": "048616",
      "distanceKm": "6.3",
    },
    {
      "description": "Favorite Restaurant",
      "locality": "Tanjong Pagar",
      "postal_code": "088539",
      "distanceKm": "2.5",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
    _initLocation();
  }

  void onLocationItemTap(Map<String, dynamic> item) async {
    await HelperFunction.hideKeyboard();
    _goToRideSharingMapScreen(
      toLatitude: item["lat"] ?? 0.0,
      toLongitude: item["lng"] ?? 0.0,
      description: item["description"] ?? "",
      estimatedTime: item["estimatedTime"] ?? "",
      distanceKm: item["distanceKm"] ?? 0.0,
    );
  }

  void _goToRideSharingMapScreen({
    required double toLatitude,
    required double toLongitude,
    required String description,
    required String estimatedTime,
    required double distanceKm,
  }) =>
      Get.toNamed(
        AppRoutes.rideSharingMapScreen,
        arguments: {
          "fromLatitude": currentPosition.value?.latitude ?? 0.0,
          "fromLongitude": currentPosition.value?.longitude ?? 0.0,
          "fromDescription": locationFromController.text,
          "toLatitude": toLatitude,
          "toLongitude": toLongitude,
          "toDescription": description,
          "estimatedTime": estimatedTime,
          "distanceKm": distanceKm,
          "proposedPrice": priceController.text,
        },
      );

  Stream<List<Map<String, dynamic>>> get fromAutoCompleteStream => _fromSuggestionsController.stream;

  Stream<List<Map<String, dynamic>>> get toAutoCompleteStream => _toSuggestionsController.stream;

  Future<void> _initLocation() async {
    isLoadingCurrentLocation.value = true;
    await appDIController.locationService.startListening();
    final pos = await appDIController.locationService.waitForFirstPosition();
    currentPosition.value = pos;
    locationFromController.text = await appDIController.locationService.getAddressFromLatLng(pos) ?? "";
    isLoadingCurrentLocation.value = false;
    final countryCode = await appDIController.locationService.getCountryCodeFromLatLng(pos) ?? "";
    userCountryCode.value = countryCode.toLowerCase();
    log("Got first runtime location: ${pos.latitude}, ${pos.longitude}");
  }

  void onQueryChanged(String query, {required bool isFrom}) {
    isLocationFromSearch.value = isFrom;
    if (isFrom) {
      _debounceFrom?.cancel();
    } else {
      _debounceTo?.cancel();
    }
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      if (isFrom) {
        _debounceFrom?.cancel();
        _debounceFrom = null;
        _fromSuggestionsController.add([]);
      } else {
        _debounceTo?.cancel();
        _debounceTo = null;
        _toSuggestionsController.add([]);
      }
      isSearchingLocation.value = false;
      return;
    }
    isSearchingLocation.value = true;
    final timer = Timer(const Duration(milliseconds: 350), () async {
      try {
        final list = await _fetchPlaceAutocomplete(
          trimmed,
          currentPosition.value?.latitude,
          currentPosition.value?.longitude,
        );
        if (isFrom) {
          _fromSuggestionsController.add(list);
        } else {
          _toSuggestionsController.add(list);
        }
      } finally {
        isSearchingLocation.value = false;
      }
    });
    if (isFrom) {
      _debounceFrom = timer;
    } else {
      _debounceTo = timer;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPlaceAutocomplete(String input, double? currentLat, double? currentLng) async {
    if (googleApiKey.isEmpty) return [];
    final country = userCountryCode.value;
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    try {
      final response = await _dio.get(url, queryParameters: {
        'input': input,
        'key': googleApiKey,
        'language': 'en',
        'components': 'country:$country',
      });

      if (response.statusCode == 200) {
        final predictions = response.data['predictions'] as List<dynamic>? ?? [];
        log("PlacesResponse: $predictions");
        List<Map<String, dynamic>> results = [];
        for (var p in predictions) {
          final placeId = p['place_id'];
          final detailsUrl = 'https://maps.googleapis.com/maps/api/place/details/json';
          final detailsResponse = await _dio.get(detailsUrl, queryParameters: {
            'place_id': placeId,
            'key': googleApiKey,
            'fields': 'geometry,address_component,formatted_address,name',
          });
          String? locality;
          String? postalCode;
          double? lat;
          double? lng;
          if (detailsResponse.statusCode == 200 && detailsResponse.data['result'] != null) {
            log("PlacesDetailsResponse: $detailsResponse");
            final result = detailsResponse.data['result'];
            final location = result['geometry']['location'];
            lat = location['lat'];
            lng = location['lng'];
            final components = result['address_components'] as List<dynamic>;
            for (var comp in components) {
              final types = comp['types'] as List<dynamic>;
              if (types.contains('locality')) {
                locality = comp['long_name'];
              }
              if (types.contains('postal_code')) {
                postalCode = comp['long_name'];
              }
            }
          }
          double? distanceKm;
          if (currentLat != null && currentLng != null && lat != null && lng != null) {
            distanceKm = _calculateDistance(currentLat, currentLng, lat, lng);
          }
          results.add({
            'place_id': placeId,
            'description': p['description'],
            'locality': locality ?? '',
            'postal_code': postalCode ?? '',
            'lat': lat,
            'lng': lng,
            'distanceKm': distanceKm,
            'estimatedTime': _calculateEstimatedTime(distanceKm),
          });
        }
        return results;
      }
    } catch (e) {
      log('autocomplete error: $e');
    }
    return [];
  }

  String? _calculateEstimatedTime(double? distanceKm) {
    String? estimatedTime;
    if (distanceKm != null && distanceKm > 0) {
      const double averageSpeedKmPerHr = 40.0; // Adjust as needed
      final timeInHours = distanceKm / averageSpeedKmPerHr;
      final totalMinutes = (timeInHours * 60).round();
      if (totalMinutes < 60) {
        estimatedTime = "$totalMinutes ${totalMinutes == 1 ? 'min' : 'mins'}";
      } else {
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;
        if (minutes == 0) {
          estimatedTime = "$hours ${hours == 1 ? 'hr' : 'hrs'}";
        } else {
          estimatedTime = "$hours ${hours == 1 ? 'hr' : 'hrs'} $minutes ${minutes == 1 ? 'min' : 'mins'}";
        }
      }
    }
    return estimatedTime;
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth radius in km
    final dLat = (lat2 - lat1) * (math.pi / 180);
    final dLon = (lon2 - lon1) * (math.pi / 180);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1 * (math.pi / 180)) * math.cos(lat2 * (math.pi / 180)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return (R * c).toPrecision(2);
  }

  void disposeEverything() {
    locationFromController.dispose();
    locationToController.dispose();
    _fromSuggestionsController.close();
    _toSuggestionsController.close();
    priceController.dispose();
    locationFromFocusNode.dispose();
    locationToFocusNode.dispose();
    priceFocusNode.dispose();
  }

  void _addListenerFocusNodes() {
    locationFromFocusNode.addListener(update);
    locationToFocusNode.addListener(update);
    priceFocusNode.addListener(update);
  }

  @override
  void onClose() {
    disposeEverything();
    super.onClose();
  }
}
