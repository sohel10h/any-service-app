import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBadge extends StatelessWidget {
  final String icon;
  final String text;
  final LinearGradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomBadge({
    super.key,
    required this.icon,
    required this.text,
    this.gradient,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 10.w, height: 10.h),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: textColor ?? AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
