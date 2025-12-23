import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends GetxService {
  static LocationService get to => Get.find<LocationService>();
  final Rxn<Position> currentPosition = Rxn<Position>();
  final StreamController<Position> _positionStreamController = StreamController<Position>.broadcast();

  Stream<Position> get onPositionChanged => _positionStreamController.stream;
  StreamSubscription<Position>? _positionSubscription;
  LocationSettings _locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 5, // meters
    timeLimit: null,
  );

  static Future<LocationService> init() async {
    if (!Get.isRegistered<LocationService>()) {
      final svc = LocationService();
      Get.put<LocationService>(svc, permanent: true);
      return svc;
    } else {
      return Get.find<LocationService>();
    }
  }

  Future<bool> ensureLocationPermission({
    bool showDialogs = true,
    VoidCallback? onDeniedForever,
  }) async {
    LocationPermission status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      status = await Geolocator.requestPermission();
    }
    if (status == LocationPermission.denied) return false;
    if (status == LocationPermission.deniedForever) {
      if (onDeniedForever != null) {
        onDeniedForever();
      } else if (showDialogs) {
        await _showPermissionDeniedForeverDialog();
      }
      return false;
    }
    return status == LocationPermission.whileInUse || status == LocationPermission.always;
  }

  Future<void> _showPermissionDeniedForeverDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text("Location Required"),
        content: const Text("Please enable location permission from Settings."),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await Geolocator.openAppSettings();
              Get.back();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<Position?> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeout = const Duration(seconds: 10),
    bool forceAndroidLocationManager = false,
  }) async {
    try {
      final isGranted = await ensureLocationPermission();
      if (!isGranted) return null;
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeout,
          distanceFilter: 5,
        ),
      );
      currentPosition.value = pos;
      _positionStreamController.add(pos);
      return pos;
    } catch (e) {
      return null;
    }
  }

  Future<Position?> getLastKnownPosition() => Geolocator.getLastKnownPosition().then((p) {
        if (p != null) {
          currentPosition.value = p;
          _positionStreamController.add(p);
        }
        return p;
      });

  Future<Position> waitForFirstPosition() async {
    if (currentPosition.value != null) {
      return currentPosition.value!;
    }
    return currentPosition.stream.firstWhere((p) => p != null).then((p) => p!);
  }

  Future<void> startListening({
    LocationAccuracy accuracy = LocationAccuracy.best,
    int distanceFilterMeters = 5,
    Duration? intervalDuration,
  }) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.always && permission != LocationPermission.whileInUse) {
      return;
    }
    stopListening();
    _locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilterMeters,
    );
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: _locationSettings,
    ).listen((pos) {
      if (pos == null) return;
      final last = currentPosition.value;
      if (intervalDuration == null) {
        currentPosition.value = pos;
        _positionStreamController.add(pos);
        return;
      }
      if (last == null || pos.timestamp == null || last.timestamp == null || pos.timestamp.difference(last.timestamp) >= intervalDuration) {
        currentPosition.value = pos;
        _positionStreamController.add(pos);
      }
    });
  }

  void stopListening() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<String?> getCountryCodeFromLatLng(Position pos) async {
    try {
      final places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (places.isNotEmpty) {
        final p = places.first;
        return p.isoCountryCode;
      }
    } catch (e) {
      // ignore
    }
    return null;
  }

  Future<String?> getAddressFromLatLng(Position pos) async {
    try {
      final places = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (places.isEmpty) return null;
      final p = places.first;
      bool isPlusCode(String? value) {
        if (value == null) return false;
        final regex = RegExp(
          r'^[23456789CFGHJMPQRVWX]{4}\+[23456789CFGHJMPQRVWX]{2,}$',
        );
        return regex.hasMatch(value);
      }

      final List<String> parts = [];
      void add(String? value) {
        if (value == null) return;
        final v = value.trim();
        if (v.isEmpty) return;
        if (isPlusCode(v)) return;
        if (parts.any((e) => e.toLowerCase() == v.toLowerCase())) return;
        parts.add(v);
      }

      add(p.street ?? p.name);
      add(p.subLocality);
      add(p.locality);
      add(p.postalCode);
      final address = parts.join(', ');
      log("DeviceLocationAddress: $address");
      return address;
    } catch (e) {
      log("Address error: $e");
      return null;
    }
  }

  void disposeService() {
    stopListening();
    _positionStreamController.close();
  }

  @override
  void onClose() {
    disposeService();
    super.onClose();
  }
}
