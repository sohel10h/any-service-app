import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileHeader extends GetWidget<VendorProfileController> {
  const VendorProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        SizedBox(height: 16.h),
        _buildStatsRow(),
        SizedBox(height: 16.h),
        _buildContactInfo(),
        SizedBox(height: 16.h),
        _buildMembershipBadge(),
        SizedBox(height: 16.h),
        Divider(color: AppColors.containerF3F4F6, thickness: 5.h),
        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final user = controller.adminUser.value;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    NetworkImageLoader(
                      user.picture?.virtualPath ?? "",
                      width: 84.w,
                      height: 84.w,
                      borderRadius: BorderRadius.circular(60.r),
                    ),
                    Positioned(
                      right: -6,
                      bottom: -4,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: AppColors.container155DFC,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.white, width: 2),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: SvgPicture.asset(
                            "assets/svgs/camera.svg",
                            width: 16.w,
                            height: 16.h,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.container155DFC,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/edit.svg",
                        width: 14.w,
                        height: 14.h,
                        colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? AppDIController.signInDetails.value.data?.userName ?? "",
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: AppColors.text101828,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Deep Cleaning Expert", //TODO: need to get this field value from API
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text4A5565,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svgs/location_outline.svg",
                      width: 14.w,
                      height: 14.h,
                      colorFilter: ColorFilter.mode(AppColors.text4A5565, BlendMode.srcIn),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "San Francisco, CA", //TODO: need to get this field value from API
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.text4A5565,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsRow() {
    return Obx(() {
      final user = controller.adminUser.value;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatBox("${user.rating ?? 0}", "Rating", AppColors.containerEFF6FF, iconPath: "assets/svgs/rating.svg"),
            _buildStatBox("${user.serviceCompletedCount ?? 0}", "Jobs", AppColors.containerF0FDF4),
            _buildStatBox("${user.totalReview ?? 0}", "Reviews", AppColors.containerFAF5FF),
          ],
        ),
      );
    });
  }

  Widget _buildStatBox(String value, String label, Color color, {String? iconPath}) {
    final ratingText = Text(
      value,
      style: TextStyle(
        fontSize: 14.sp,
        color: AppColors.text101828,
        fontWeight: FontWeight.w700,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconPath != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        iconPath,
                        width: 12.w,
                        height: 12.h,
                      ),
                      SizedBox(width: 2.w),
                      ratingText,
                    ],
                  )
                : ratingText,
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.text4A5565,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Obx(() {
      final user = controller.adminUser.value;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/email.svg",
                  width: 14.w,
                  height: 14.h,
                  colorFilter: ColorFilter.mode(AppColors.text364153, BlendMode.srcIn),
                ),
                SizedBox(width: 8.w),
                Text(
                  user.email ?? AppDIController.signInDetails.value.data?.userEmail ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text364153,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/phone.svg",
                  width: 14.w,
                  height: 14.h,
                  colorFilter: ColorFilter.mode(AppColors.text364153, BlendMode.srcIn),
                ),
                SizedBox(width: 8.w),
                Text(
                  user.mobile ?? "",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text364153,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/calendar_outline.svg",
                  width: 14.w,
                  height: 14.h,
                  colorFilter: ColorFilter.mode(AppColors.text364153, BlendMode.srcIn),
                ),
                SizedBox(width: 8.w),
                Text(
                  HelperFunction.formatMemberSince(user.createdAt ?? ""),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text364153,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMembershipBadge() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.containerF0FDF4,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderB9F8CF),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/svgs/check_circle.svg",
              width: 14.w,
              height: 14.h,
            ),
            SizedBox(width: 8.w),
            Text(
              "Verified Provider", //TODO: need to get this field value from API
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text008236,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
