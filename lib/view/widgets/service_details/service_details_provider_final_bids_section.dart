import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/service_details/service_details_provider_bids_item.dart';
import 'package:service_la/view/screens/service_details/controller/service_details_controller.dart';

class ServiceDetailsProviderFinalBidsSection extends GetWidget<ServiceDetailsController> {
  const ServiceDetailsProviderFinalBidsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Final Bids",
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
            child: Obx(
              () => Text(
                "${controller.finalBids.length} received",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.text6A7282,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _buildFilters(),
          SizedBox(height: 20.h),
          Obx(
            () {
              final finalBids = controller.finalBids;
              if (finalBids.isEmpty) {
                return SizedBox(
                  height: Get.height / 3,
                  child: Center(
                    child: Text(
                      "No bids are found!",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.text6A7282,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: finalBids
                    .map(
                      (bid) => ServiceDetailsProviderBidsItem(
                        bid: bid,
                        onAccept: () {},
                        onShortlist: () {},
                        onReject: () {},
                        onMessage: () {},
                        isApprovedLoading: controller.isApprovedLoadingMap[bid.id] ?? false.obs,
                        isShortlistedLoading: controller.isShortlistedLoadingMap[bid.id] ?? false.obs,
                        isRejectedLoading: controller.isRejectedLoadingMap[bid.id] ?? false.obs,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
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
                              colorFilter: ColorFilter.mode(
                                isSelected ? AppColors.white : AppColors.text364153,
                                BlendMode.srcIn,
                              ),
                            ),
                          if (controller.filters[index] == "Top Rated")
                            SvgPicture.asset(
                              "assets/svgs/rating_outline.svg",
                              width: 14.w,
                              height: 14.h,
                              colorFilter: ColorFilter.mode(
                                isSelected ? AppColors.white : AppColors.text364153,
                                BlendMode.srcIn,
                              ),
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
