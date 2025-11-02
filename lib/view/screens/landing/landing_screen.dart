import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/landing/custom_bottom_nav_bar.dart';
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
            controller.changeIndex(0, context);
          }
        },
        child: Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: controller.screens[controller.currentIndex.value],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 16.h,
                child: controller.isHideBottomNav.value
                    ? SizedBox.shrink()
                    : CustomBottomNavBar(
                        currentIndex: controller.currentIndex.value,
                        onTap: (index) => controller.changeIndex(index, context),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
