import 'package:flutter/services.dart';
import 'package:service_la/common/utils/app_colors.dart';

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
}
