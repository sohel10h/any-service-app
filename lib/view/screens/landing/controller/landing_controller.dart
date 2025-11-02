import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/view/screens/home/home_screen.dart';
import 'package:service_la/view/screens/settings/settings_screen.dart';
import 'package:service_la/view/widgets/home/service_request_modal.dart';
import 'package:service_la/view/screens/vendor_profile/vendor_profile_screen.dart';

class LandingController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isHideBottomNav = false.obs;

  void changeIndex(int index, BuildContext context) {
    isHideBottomNav.value = false;
    log("Changed tab index: $index");
    currentIndex.value = index;
    if (currentIndex.value == 2) {
      DialogHelper.showServiceRequestModal(context);
    }
    if (currentIndex.value == 4) {
      isHideBottomNav.value = true;
    }
  }

  List<Widget> screens = [
    const HomeScreen(),
    const SizedBox(),
    const ServiceRequestModal(),
    const SettingsScreen(),
    const VendorProfileScreen(),
  ];
}
