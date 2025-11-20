import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/view/screens/home/home_screen.dart';
import 'package:service_la/services/location/location_service.dart';
import 'package:service_la/view/screens/settings/settings_screen.dart';
import 'package:service_la/view/widgets/home/service_request_modal.dart';
import 'package:service_la/view/screens/ride_sharing/ride_sharing_screen.dart';
import 'package:service_la/view/screens/vendor_profile/vendor_profile_screen.dart';

class LandingController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isHideBottomNav = false.obs;

  void changeIndex(int index, BuildContext context) async {
    isHideBottomNav.value = false;
    log("Trying to change tab index: $index");
    if (index == 2) {
      isHideBottomNav.value = true;
      DialogHelper.showServiceRequestModal(context);
      await Future.delayed(const Duration(microseconds: 100));
      if (context.mounted) {
        DialogHelper.showBottomSheet(context);
      }
      return;
    }
    if (index == 3) {
      final granted = await _checkIsLocationEnabled();
      if (!granted) {
        Get.snackbar("Permission Required", "Please allow location permission to continue.");
        return;
      }
    }
    if (index == 4) {
      isHideBottomNav.value = true;
    }
    currentIndex.value = index;
    log("Changed tab index: $index");
  }

  Future<bool> _checkIsLocationEnabled() async {
    final svc = LocationService.to;
    final granted = await svc.ensureLocationPermission();
    return granted;
  }

  List<Widget> screens = [
    const HomeScreen(),
    const SettingsScreen(),
    const ServiceRequestModal(),
    const RideSharingScreen(),
    const VendorProfileScreen(),
  ];
}
