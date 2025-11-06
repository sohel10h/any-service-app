import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/create_service_details/create_service_details_service_info_section.dart';

class CreateServiceDetailsDetailsSection extends StatelessWidget {
  const CreateServiceDetailsDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.containerEFF6FF,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: AppColors.container2B7FFF,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "AC Repair",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.text1447E6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Professional AC Repair & Installation",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.text101828,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/rating.svg",
                  width: 14.w,
                  height: 14.h,
                ),
                SizedBox(width: 4.w),
                Flexible(
                  flex: 1,
                  child: RichText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "4.84",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.text101828,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: " "),
                        TextSpan(
                          text: "(156 reviews)",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.text6A7282,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  width: 3.5.w,
                  height: 3.5.h,
                  decoration: BoxDecoration(
                    color: AppColors.containerD1D5DC,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  flex: 1,
                  child: Text(
                    "1240 jobs completed",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.text4A5565,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  "\$89.9",
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 12.w),
                Text(
                  "\$120",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.text99A1AF,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: AppColors.text99A1AF,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(width: 8.w),
                Text(
                  "starting price",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text4A5565,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Price range: \$89 - \$200",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text6A7282,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.containerF3F4F6),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CreateServiceDetailsServiceInfoSection(),
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.containerF3F4F6),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Description",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.text101828,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Expert air conditioning repair and installation services. "
              "Our certified technicians provide fast, reliable service "
              "for all AC brands. We handle everything from routine maintenance "
              "to complete system installations.",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text4A5565,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.containerF3F4F6),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}
