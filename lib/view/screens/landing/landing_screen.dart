import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';

class LandingScreen extends GetWidget<LandingController> {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.currentIndex.value == 0,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop && controller.currentIndex.value != 0) {
            controller.changeIndex(0);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Obx(() {
              return controller.screens[controller.currentIndex.value];
            }),
          ),
          bottomNavigationBar: Obx(() {
            return BottomNavigationBar(
              backgroundColor: AppColors.white,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeIndex,
              items: controller.bottomNavigationBarItems,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: AppColors.primary,
              selectedLabelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            );
          }),
        ),
      ),
    );
  }
}
