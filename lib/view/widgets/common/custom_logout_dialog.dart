import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';

class CustomLogoutDialog extends StatelessWidget {
  const CustomLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: Get.width / 1.2,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            color: AppColors.white.withValues(alpha: 0.98),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.15),
                blurRadius: 40,
                spreadRadius: 4,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.redAccent.withValues(alpha: 0.18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.redAccent.withValues(alpha: 0.25),
                      blurRadius: 25,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: SvgPicture.asset(
                  "assets/svgs/logout.svg",
                  width: 30.w,
                  height: 30.h,
                  colorFilter: ColorFilter.mode(AppColors.redAccent, BlendMode.srcIn),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                "Log Out?",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.text101828,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Logging out will end your current session.\nDo you want to proceed?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.text6A7282,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 28.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 11.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        HelperFunction.logOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.redAccent,
                        foregroundColor: AppColors.white,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
