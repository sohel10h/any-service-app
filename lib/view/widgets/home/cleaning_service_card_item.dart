import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';

class CleaningServiceCardItem extends StatelessWidget {
  final Map<String, dynamic> service;

  const CleaningServiceCardItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        width: 280.w,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: .2),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      child: NetworkImageLoader(
                        "${service["profileImageUrl"]}",
                        width: 35.w,
                        height: 35.w,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 2,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: AppColors.container00C950,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${service["serviceName"]}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.text101828,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${service["providerName"]}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.text4A5565,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/rating.svg",
                        width: 11.w,
                        height: 11.h,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          "${service["rating"]}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 1,
                  child: Text(
                    "\$${service["price"]}",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "Posted ${service["postedTime"]}",
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
    );
  }
}
