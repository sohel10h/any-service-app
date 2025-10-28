import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/screens/home/home_screen.dart';
import 'package:service_la/view/screens/settings/settings_screen.dart';

class LandingController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    log("Changed tab index: $index");
    currentIndex.value = index;
  }

  List<Widget> screens = [
    const HomeScreen(),
    const SizedBox(), // Charity placeholder
    const SettingsScreen(),
    const SizedBox(), // Profile placeholder
  ];
}
