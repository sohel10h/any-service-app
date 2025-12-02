import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileTab extends GetWidget<VendorProfileController> {
  final bool isFromNestedScroll;

  const VendorProfileTab({super.key, this.isFromNestedScroll = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Obx(() {
        return TabBar(
          controller: controller.tabController,
          isScrollable: false,
          indicatorColor: AppColors.container155DFC,
          dividerColor: Colors.transparent,
          padding: EdgeInsets.zero,
          labelPadding: EdgeInsets.zero,
          onTap: (index) {
            controller.selectedTabIndex.value = index;
          },
          tabs: List.generate(controller.tabs.length, (index) {
            final isSelected = index == controller.selectedTabIndex.value;
            final tabText = controller.tabs[index];
            return SizedBox(
              height: 52.h,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tabText,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: isSelected ? AppColors.container155DFC : AppColors.text6A7282,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.containerFB2C36 : AppColors.containerF3F4F6,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        "${controller.tabsCounts[index]}",
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: isSelected ? AppColors.white : AppColors.text4A5565,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
