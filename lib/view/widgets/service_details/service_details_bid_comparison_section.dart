import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceDetailsBidComparisonSection extends StatelessWidget {
  const ServiceDetailsBidComparisonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.containerFAF5FF,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                "assets/svgs/trending_down.svg",
                width: 17.w,
                height: 17.h,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  "Best Value from 5 Bids",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text59168B,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildBidBox(
                  label: "Average Bid",
                  value: "\$93.00",
                  valueColor: AppColors.text59168B,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildBidBox(
                  label: "Lowest Bid",
                  value: "\$75.00",
                  valueColor: AppColors.text00A63E,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber, size: 18.sp),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  "You can save up to \$18 from the average bid",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.text8200DB,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBidBox({required String label, required String value, required Color valueColor}) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.text4A5565,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
