import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/view/screens/home/home_screen.dart';
import 'package:service_la/view/screens/settings/settings_screen.dart';
import 'package:service_la/view/widgets/home/service_request_modal.dart';

class LandingController extends GetxController {
  RxInt currentIndex = 0.obs;

  void changeIndex(int index, BuildContext context) {
    log("Changed tab index: $index");
    currentIndex.value = index;
    if (currentIndex.value == 2) {
      DialogHelper.showServiceRequestModal(context);
    }
  }

  List<Widget> screens = [
    const HomeScreen(),
    const SizedBox(),
    const ServiceRequestModal(),
    const SettingsScreen(),
    const SizedBox(),
  ];
}
