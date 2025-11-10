import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/service_details/controller/service_details_controller.dart';

class ServiceDetailsTab extends GetWidget<ServiceDetailsController> {
  final bool isFromNestedScroll;

  const ServiceDetailsTab({super.key, this.isFromNestedScroll = false});

  @override
  Widget build(BuildContext context) {
    final tabBar = Obx(
      () => SafeArea(
        child: Padding(
          padding: EdgeInsets.zero,
          child: TabBar(
            isScrollable: false,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicatorColor: AppColors.primary,
            dividerColor: Colors.transparent,
            onTap: (index) => controller.selectedTabIndex.value = index,
            tabs: List.generate(controller.tabViews.length, (index) {
              final isSelected = index == controller.selectedTabIndex.value;
              final tabText = controller.tabs[index];

              return Tab(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          tabText,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isSelected ? AppColors.primary : AppColors.text6A7282,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : AppColors.containerF3F4F6,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            "${controller.tabsCounts[index]}",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: isSelected ? AppColors.white : AppColors.text4A5565,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );

    if (isFromNestedScroll) {
      return SizedBox(
        height: 52.h,
        child: Center(child: tabBar),
      );
    }

    return Column(
      children: [
        SizedBox(height: 48.h, child: tabBar),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              controller.tabViews.length,
              (index) => controller.tabViews[index],
            ),
          ),
        ),
      ],
    );
  }
}
