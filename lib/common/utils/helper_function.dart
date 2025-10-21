import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelperFunction {
  static String placeholderImageUrl42 = "https://placehold.co/42x42.png";
  static String placeholderImageUrl48 = "https://placehold.co/48x48.png";
  static String placeholderImageUrl17 = "https://placehold.co/17x17.png";
  static String placeholderImageUrl30 = "https://placehold.co/30x30.png";

  static void changeStatusBarColor() => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      );

  static void hideKeyboard() => FocusScope.of(Get.context!).unfocus();

  static void snackbar(String message, {String? title, Color? textColor, Color? backgroundColor, IconData? icon, Color? iconColor}) {
    Get.snackbar(
      title ?? "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor ?? AppColors.red,
      colorText: textColor ?? AppColors.white,
      icon: Icon(icon ?? Icons.error, color: iconColor ?? AppColors.white),
      borderRadius: 10.r,
      margin: EdgeInsets.all(8.sp),
      duration: Duration(seconds: 3),
    );
  }
}
