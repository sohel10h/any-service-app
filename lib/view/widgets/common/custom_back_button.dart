import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? backButtonPadding;
  final Color? backButtonBackgroundColor;

  const CustomBackButton({
    super.key,
    this.onTap,
    this.backButtonPadding,
    this.backButtonBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: backButtonPadding ?? 0.w),
      child: GestureDetector(
        onTap: onTap ?? () => Get.back(),
        child: Container(
          width: 31.w,
          height: 31.w,
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: backButtonBackgroundColor ?? AppColors.containerF3F4F6,
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
