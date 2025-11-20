import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_la/view/screens/ride_sharing/controller/ride_sharing_map_controller.dart';

class RideSharingMapScreen extends GetWidget<RideSharingMapController> {
  const RideSharingMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: _buildMap(context)),
          Positioned(
            left: 16.w,
            right: 16.w,
            top: 40.h,
            child: TopSearchCard(),
          ),
          Positioned(
            bottom: 20.h,
            right: 12.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "rotationBtn",
                  mini: true,
                  backgroundColor: AppColors.white,
                  child: Icon(Icons.screen_rotation, color: AppColors.primary),
                  onPressed: () async {
                    controller.rotationValue.value += 90.0;
                    if (controller.rotationValue.value > 360.0) {
                      controller.rotationValue.value = 90.0;
                    }
                    final mapCtrl = controller.googleMapController.value;
                    final pos = controller.currentPosition.value;
                    if (mapCtrl != null) {
                      if (pos != null) {
                        mapCtrl.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(pos.latitude, pos.longitude),
                              zoom: 17.0,
                              tilt: 40,
                              bearing: controller.rotationValue.value,
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
                SizedBox(height: 12.h),
                AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: FloatingActionButton(
                    heroTag: "myLocationBtn",
                    mini: true,
                    backgroundColor: AppColors.white,
                    child: Icon(Icons.my_location, color: AppColors.primary),
                    onPressed: () async {
                      final mapCtrl = controller.googleMapController.value;
                      final pos = controller.currentPosition.value;
                      if (mapCtrl != null) {
                        if (pos != null) {
                          mapCtrl.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(pos.latitude, pos.longitude),
                                zoom: 17.0,
                                tilt: 40,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Obx(() {
      if (controller.initialCameraTarget.value == null) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      }
      final initialCamera = CameraPosition(
        target: controller.initialCameraTarget.value!,
        zoom: controller.initialCameraZoom.value,
      );
      return GoogleMap(
        initialCameraPosition: initialCamera,
        onMapCreated: controller.onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        polylines: controller.polylines.toSet(),
        markers: controller.markers.toSet(),
        mapType: MapType.normal,
        compassEnabled: false,
        trafficEnabled: false,
        buildingsEnabled: false,
        indoorViewEnabled: false,
        zoomControlsEnabled: false,
        padding: EdgeInsets.only(bottom: controller.mapBottomPadding.value),
      );
    });
  }
}

class TopSearchCard extends StatelessWidget {
  final _fromFocus = FocusNode();
  final _toFocus = FocusNode();

  TopSearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    final RideSharingMapController controller = Get.find();
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primary),
                SizedBox(width: 8.w),
                Expanded(
                  child: PlaceField(
                    hint: 'From',
                    textController: controller.fromTextController,
                    onTapSuggestion: (place) async {
                      await controller.onPlaceSelected(place, isFrom: true);
                      _toFocus.requestFocus();
                    },
                    focusNode: _fromFocus,
                    suggestionsStream: controller.fromAutoCompleteStream,
                    onSubmitted: (val) => _toFocus.requestFocus(),
                  ),
                ),
                SizedBox(width: 8.w),
                if (controller.from.value != null)
                  GestureDetector(
                    onTap: () => controller.clearFrom(),
                    child: Icon(Icons.close, size: 20.sp),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.place_outlined, color: Colors.black54),
                SizedBox(width: 8.w),
                Expanded(
                  child: PlaceField(
                    hint: 'To',
                    textController: controller.toTextController,
                    onTapSuggestion: (place) async {
                      await controller.onPlaceSelected(place, isFrom: false);
                      controller.openBottomSheet();
                    },
                    focusNode: _toFocus,
                    suggestionsStream: controller.toAutoCompleteStream,
                    onSubmitted: (val) => controller.onBothLocationsReady(),
                  ),
                ),
                SizedBox(width: 8.w),
                if (controller.to.value != null)
                  GestureDetector(
                    onTap: () => controller.clearTo(),
                    child: Icon(Icons.close, size: 20.sp),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceField extends StatelessWidget {
  final String hint;
  final TextEditingController textController;
  final void Function(Map<String, dynamic> place) onTapSuggestion;
  final FocusNode? focusNode;
  final Stream<List<Map<String, dynamic>>> suggestionsStream;
  final void Function(String)? onSubmitted;

  const PlaceField({
    super.key,
    required this.hint,
    required this.textController,
    required this.onTapSuggestion,
    required this.suggestionsStream,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: suggestionsStream,
      builder: (context, snap) {
        final suggestions = snap.data ?? [];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              focusNode: focusNode,
              onChanged: (val) {
                final RideSharingMapController ctrl = Get.find();
                ctrl.onQueryChanged(val, isFrom: hint.toLowerCase() == 'from');
              },
              onSubmitted: onSubmitted,
              decoration: InputDecoration.collapsed(hintText: hint),
            ),
            if (suggestions.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 6.h),
                constraints: BoxConstraints(maxHeight: 180.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8.r)],
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = suggestions[i];
                    return ListTile(
                      dense: true,
                      title: Text(item['description'] ?? ''),
                      onTap: () => onTapSuggestion(item),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
