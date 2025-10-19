import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/screens/settings/controller/settings_controller.dart';

class SettingsScreen extends GetWidget<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Settings"),
      body: Column(
        children: [
          const Spacer(),
          InkWell(
            onTap: controller.logOut,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: AppColors.black.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(Icons.logout),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
