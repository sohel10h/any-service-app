import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
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
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned.fill(
                child: controller.screens[controller.currentIndex.value],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 8.h,
                child: _CustomBottomNavBar(
                  currentIndex: controller.currentIndex.value,
                  onTap: controller.changeIndex,
                ),
              ),
              Positioned(
                bottom: 75.h,
                child: Center(
                  child: SizedBox(
                    width: 56.w,
                    height: 56.h,
                    child: FloatingActionButton(
                      heroTag: "service_request_modal",
                      shape: const CircleBorder(),
                      onPressed: () => DialogHelper.showServiceRequestModal(context),
                      backgroundColor: AppColors.primary,
                      elevation: 4,
                      child: SvgPicture.asset(
                        "assets/svgs/add.svg",
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem("Home", "assets/svgs/home.svg"),
      _NavItem("Bidding", "assets/svgs/charity.svg"),
      _NavItem("Services", "assets/svgs/configuration.svg"),
      _NavItem("Profile", "assets/svgs/user.svg"),
    ];

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(40.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppColors.borderE3E7EC),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;

          return GestureDetector(
            onTap: () => onTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          AppColors.containerFF8904,
                          AppColors.containerF54900,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    item.iconPath,
                    width: 22.w,
                    height: 22.h,
                    colorFilter: ColorFilter.mode(
                      isSelected ? AppColors.white : AppColors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 6.w),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String iconPath;

  const _NavItem(this.label, this.iconPath);
}
