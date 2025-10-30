import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/service_details/service_details_provide_bids_item.dart';
import 'package:service_la/view/screens/service_details/controller/service_details_controller.dart';

class ServiceDetailsProviderBidsSection extends GetWidget<ServiceDetailsController> {
  const ServiceDetailsProviderBidsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32.h),
        _buildTabs(),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "Provider Bids",
            style: TextStyle(
              fontSize: 18.sp,
              color: AppColors.text101828,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            "5 received",
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.text6A7282,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        _buildFilters(),
        SizedBox(height: 20.h),
        Obx(
          () => SizedBox(
            height: Get.height / 1.45,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              shrinkWrap: true,
              itemCount: controller.bids.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final bid = controller.bids[index];
                return ServiceDetailsProviderBidsItem(
                  bid: bid,
                  onAccept: () {},
                  onShortlist: () {},
                  onReject: () {},
                  onMessage: () {},
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Obx(
      () => SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            controller.tabs.length,
            (index) {
              final isSelected = index == controller.selectedTabIndex.value;
              final tabText = controller.tabs[index];
              final count = controller.tabsCounts[index];

              return GestureDetector(
                onTap: () => controller.selectedTabIndex.value = index,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            tabText,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: isSelected ? AppColors.primary : AppColors.text6A7282,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 6.w),
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.containerF3F4F6,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              "$count",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isSelected ? AppColors.white : AppColors.text4A5565,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      if (isSelected)
                        Container(
                          height: 2.h,
                          width: _calculateUnderlineWidth(tabText, count),
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateUnderlineWidth(String text, int? count) {
    final textLength = text.length;
    final countLength = count != null ? count.toString().length + 2 : 0;
    final totalCharWidth = (textLength + countLength) * 7.w;
    return totalCharWidth.clamp(40.w, 100.w);
  }

  Widget _buildFilters() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          children: List.generate(
            controller.filters.length,
            (index) {
              final isSelected = index == controller.selectedFilterIndex.value;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.selectedFilterIndex.value = index,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.container155DFC : AppColors.containerF3F4F6,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (controller.filters[index] == "Lowest Price")
                            SvgPicture.asset(
                              "assets/svgs/trending_down.svg",
                              width: 14.w,
                              height: 14.h,
                              colorFilter: ColorFilter.mode(isSelected ? AppColors.white : AppColors.text364153, BlendMode.srcIn),
                            ),
                          if (controller.filters[index] == "Top Rated")
                            SvgPicture.asset(
                              "assets/svgs/rating_outline.svg",
                              width: 14.w,
                              height: 14.h,
                              colorFilter: ColorFilter.mode(isSelected ? AppColors.white : AppColors.text364153, BlendMode.srcIn),
                            ),
                          SizedBox(width: 6.w),
                          Text(
                            controller.filters[index],
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: isSelected ? AppColors.white : AppColors.text364153,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
