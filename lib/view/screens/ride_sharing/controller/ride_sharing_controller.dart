import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';

class RideSharingController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RxList<String> timeOptions = ["Now", "Later"].obs;
  final Rx<String?> selectedTime = Rx<String?>(null);

  @override
  void onInit() {
    // statement
    super.onInit();
  }

  void goToRideSharingMapLocationSearchScreen(String vehicleIconPath) => Get.toNamed(
        AppRoutes.rideSharingMapLocationSearchScreen,
        arguments: {"vehicleIconPath": vehicleIconPath},
      );
}
