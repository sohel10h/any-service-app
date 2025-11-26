import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: AppColors.primary,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      brightness: Brightness.light,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: AppBarTheme(
        foregroundColor: AppColors.black,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0.0,
        titleTextStyle: TextStyle(
          fontSize: 20.sp,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
          side: BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.white,
        textStyle: TextStyle(color: AppColors.black),
      ),
      iconTheme: const IconThemeData(color: AppColors.text101828),
    );
  }
}
