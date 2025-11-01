import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
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
                child: CustomBottomNavBar(
                  currentIndex: controller.currentIndex.value,
                  onTap: (index) => controller.changeIndex(index, context),
                ),
              ),
              /*Positioned(
                bottom: 50.h,
                child: Center(
                  child: SizedBox(
                    width: 68.w,
                    height: 68.h,
                    child: FloatingActionButton(
                      heroTag: "service_request_modal",
                      shape: const CircleBorder(),
                      onPressed: () => DialogHelper.showServiceRequestModal(context),
                      backgroundColor: Colors.transparent,
                      elevation: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(68.r),
                        child: Container(
                          width: 68.w,
                          height: 68.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.containerFF8904,
                                AppColors.containerF54900,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: SvgPicture.asset(
                              "assets/svgs/add.svg",
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
