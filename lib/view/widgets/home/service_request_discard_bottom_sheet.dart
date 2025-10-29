import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';

class ServiceRequestDiscardBottomSheet extends GetWidget<HomeController> {
  const ServiceRequestDiscardBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Want to discard your post?",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.text101828,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "You’ve added some content. Do you want to discard it?",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.text6A7282,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Column(
            children: [
              TextButton(
                onPressed: () {
                  controller.clearDraft();
                  Get.back();
                  Get.back();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 24.sp,
                      color: AppColors.black,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Discard Post",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => Get.back(),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 24.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Continue Editing",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
