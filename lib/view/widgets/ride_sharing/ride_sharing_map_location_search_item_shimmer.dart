import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_shimmer_widget.dart';

class RideSharingMapLocationSearchItemShimmer extends StatelessWidget {
  const RideSharingMapLocationSearchItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: CustomShimmerWidget(
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12.h,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 10.h,
                    width: 80.w,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 16.w,
              height: 16.h,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
