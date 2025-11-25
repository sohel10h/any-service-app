import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_la/view/widgets/ride_sharing/ride_sharing_map_rider_item.dart';
import 'package:service_la/view/screens/ride_sharing/controller/ride_sharing_map_controller.dart';

class RideSharingMapBottomSheet extends GetWidget<RideSharingMapController> {
  const RideSharingMapBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.15,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(50.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(
                width: 60.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 12.h),
              Flexible(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final from = LatLng(34.052235, -118.243683);
                        final to = LatLng(34.062235, -118.253683);
                        await controller.setFromTo(from, to);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.white, size: 22.sp),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Estimate to destination",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: controller.estimatedTime,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(text: " "),
                                        TextSpan(
                                          text: "(${controller.distanceKm}km)",
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(40.r),
                              ),
                              child: Text(
                                "Share",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildTabsAndLists(),
                    SizedBox(height: 10.h),
                    _tabContent(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tabContent() {
    return Obx(
      () {
        return controller.tabIndex.value == 0
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0.h),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.rideOptions.length,
                itemBuilder: (context, index) {
                  final rideOption = controller.rideOptions[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: RideSharingMapRiderItem(rideOption: rideOption),
                    ),
                  );
                },
              )
            : ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0.h),
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Text(
                    "Trip Details:",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildDetailsItems("Pickup: ${controller.fromDescription}"),
                  _buildDetailsItems("Drop-off: ${controller.toDescription}"),
                  _buildDetailsItems("Estimated Time: ${controller.estimatedTime}"),
                  _buildDetailsItems("Distance: ${controller.distanceKm} km"),
                ],
              );
      },
    );
  }

  Widget _buildDetailsItems(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 12.sp,
        color: AppColors.white,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildTabsAndLists() {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _tab("Riders", 0)),
            Expanded(child: _tab("Details", 1)),
          ],
        ),
      ],
    );
  }

  Widget _tab(String label, int index) {
    return Obx(() {
      final isSelected = controller.tabIndex.value == index;
      return GestureDetector(
        onTap: () => controller.tabIndex.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? Colors.grey.shade300 : AppColors.primary,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? AppColors.primary : AppColors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}
