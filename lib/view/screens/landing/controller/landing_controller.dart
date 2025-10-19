import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/home/home_screen.dart';
import 'package:service_la/view/screens/settings/settings_screen.dart';

class LandingController extends GetxController {
  var currentIndex = 0.obs;
  final RxBool isFabExpanded = false.obs;

  @override
  void onInit() {
    // statement
    super.onInit();
  }

  void toggleFabMenu() => isFabExpanded.toggle();

  void changeIndex(int index) {
    log("message index $index");
    currentIndex.value = index;
  }

  List<Widget> screens = [
    HomeScreen(),
    SettingsScreen(),
  ];

  var bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        "assets/svgs/logo.svg",
        width: 24.w,
        height: 24.h,
      ),
      label: "Home",
      tooltip: "Home",
      activeIcon: SvgPicture.asset(
        "assets/svgs/logo.svg",
        width: 24.w,
        height: 24.h,
      ),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        "assets/svgs/logo.svg",
        width: 24.w,
        height: 24.h,
      ),
      label: "Settings",
      tooltip: "Settings",
      activeIcon: SvgPicture.asset(
        "assets/svgs/logo.svg",
        width: 24.w,
        height: 24.h,
      ),
    ),
  ];
}
