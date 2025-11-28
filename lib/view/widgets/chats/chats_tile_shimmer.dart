import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_shimmer_widget.dart';

class ChatsTileShimmer extends StatelessWidget {
  const ChatsTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomShimmerWidget(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          leading: Container(
            height: 44.w,
            width: 44.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          title: Container(
            height: 12.h,
            width: 120.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 6.h),
            height: 10.h,
            width: 180.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 10.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                height: 18.w,
                width: 18.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
