import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          width: 31.w,
          height: 31.w,
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: AppColors.containerF3F4F6,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/svgs/arrow_left.svg",
            width: 14.w,
            height: 14.h,
          ),
        ),
      ),
    );
  }
}
