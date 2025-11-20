import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_la/view/screens/ride_sharing/controller/ride_sharing_map_controller.dart';

class RideSharingMapScreen extends GetWidget<RideSharingMapController> {
  const RideSharingMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _buildMap(context)),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Obx(() {
      final initialCamera = CameraPosition(
        target: const LatLng(34.052235, -118.243683),
        zoom: 13,
      );
      return GoogleMap(
        initialCameraPosition: initialCamera,
        onMapCreated: controller.onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: controller.polylines.toSet(),
        markers: controller.markers.toSet(),
        mapType: MapType.normal,
      );
    });
  }
}
