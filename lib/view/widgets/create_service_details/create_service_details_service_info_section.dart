import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateServiceDetailsServiceInfoSection extends StatelessWidget {
  const CreateServiceDetailsServiceInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _infoBox(
                iconPath: "assets/svgs/verified_outline.svg",
                title: "Licensed & Insured",
                subtitle: "Verified",
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _infoBox(
                iconPath: "assets/svgs/clock_outline.svg",
                title: "Response Time",
                subtitle: "< 2 hours",
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _infoBox(
                iconPath: "assets/svgs/rating_outline.svg",
                title: "Satisfaction Rate",
                subtitle: "99%",
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _infoBox(
                iconPath: "assets/svgs/location_outline.svg",
                title: "Service Area",
                subtitle: "San Francisco, CA",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _infoBox({required String iconPath, required String title, required String subtitle}) {
    return Container(
      height: 75.h,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.containerF9FAFB,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.sp),
            width: 28.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: SvgPicture.asset(
              iconPath,
              width: 14.w,
              height: 14.h,
              colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.text4A5565,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text101828,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
