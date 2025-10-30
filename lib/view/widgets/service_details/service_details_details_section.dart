import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceDetailsDetailsSection extends StatelessWidget {
  const ServiceDetailsDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Service Details",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.text0A0A0A,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4.h),
            _buildDetailTile(
              imagesPath: "assets/images/checkmark_small.png",
              title: "Description",
              subtitle: "Need a thorough deep cleaning for a 3-bedroom apartment. Including kitchen, "
                  "bathrooms, living areas, and all windows. The apartment is approximately 1,200",
              imageContainerColor: AppColors.containerDCFCE7,
            ),
            _buildDetailTile(
              imagesPath: "assets/images/location_pin.png",
              title: "Location",
              subtitle: "123 Main Street, Downtown",
              imageContainerColor: AppColors.containerDBEAFE,
            ),
            _buildDetailTile(
              imagesPath: "assets/images/dollar_bag.png",
              title: "Budget Range",
              subtitle: "\$80 – \$120",
              imageContainerColor: AppColors.containerFFEDD4,
            ),
            _buildDetailTile(
              imagesPath: "assets/images/timer_clock.png",
              title: "Urgency Level",
              subtitleWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.containerFEF9C2,
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: AppColors.borderFFF085),
                ),
                child: Text(
                  "Medium",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.text894B00,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              imageContainerColor: AppColors.containerFEF9C2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required String imagesPath,
    required String title,
    String? subtitle,
    Widget? subtitleWidget,
    Color? imageContainerColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 17.w,
            height: 17.h,
            decoration: BoxDecoration(
              color: imageContainerColor ?? AppColors.containerDCFCE7,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Image.asset(imagesPath),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text4A5565,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 4.h),
                subtitleWidget ??
                    Text(
                      subtitle ?? "",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.text101828,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
