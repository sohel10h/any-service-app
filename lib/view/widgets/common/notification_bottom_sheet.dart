import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';

class NotificationBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onPressed;
  final String? actionTitle;
  final String? imageUrl;

  const NotificationBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.onPressed,
    this.actionTitle,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close, size: 22.sp, color: AppColors.text101828),
                  ),
                ],
              ),
              if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: NetworkImageLoader(
                      imageUrl ?? "",
                      height: 160.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.text101828,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.text6A7282,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPressed ?? () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        actionTitle ?? "OK",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
