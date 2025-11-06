import 'dart:io';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class HelperFunction {
  static String placeholderImageUrl42 = "https://placehold.co/42x42.png";
  static String placeholderImageUrl48 = "https://placehold.co/48x48.png";
  static String placeholderImageUrl17 = "https://placehold.co/17x17.png";
  static String placeholderImageUrl30 = "https://placehold.co/30x30.png";
  static String placeholderImageUrl35 = "https://placehold.co/35x35.png";
  static String placeholderImageUrl70 = "https://placehold.co/70x70.png";
  static String placeholderImageUrl178_84 = "https://placehold.co/178x84.png";
  static String placeholderImageUrl412_320 = "https://placehold.co/412x320.png";
  static String imageUrl1 = "https://i.imgur.com/mqtYQc6.png";
  static String imageUrl2 = "https://i.imgur.com/uCa4vK8.png";
  static String userImage1 = "https://i.pravatar.cc/150?img=2";
  static String userImage2 = "https://i.pravatar.cc/150?img=4";
  static String userImage3 = "https://i.pravatar.cc/150?img=60";

  static void changeStatusBarColor() => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      );

  static Future<void> hideKeyboard() async {
    await Future.delayed(const Duration(milliseconds: 100));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(Get.context!).unfocus();
    });
  }

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

  static Future<XFile> getImageXFile(XFile picked) async {
    File imageFile = File(picked.path);
    int originalSize = await imageFile.length();
    log("📸 Original image path: ${imageFile.path}");
    log("📦 Original image size: ${originalSize / (1024 * 1024)} MB");

    // If image is larger than 2 MB
    if (originalSize > 2 * 1024 * 1024) {
      log("⚠️ Image exceeds 2 MB, starting compression...");

      final compressed = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        minWidth: 1080,
        minHeight: 1080,
        quality: 70,
      );

      if (compressed != null) {
        final compressedFile = await _writeToTempFile(compressed);
        int compressedSize = await compressedFile.length();
        log("✅ Compression complete.");
        log("📦 Compressed image path: ${compressedFile.path}");
        log("📦 Compressed image size: ${compressedSize / (1024 * 1024)} MB");

        return XFile(compressedFile.path);
      } else {
        log("❌ Compression failed. Using original image.");
      }
    } else {
      log("✅ Image is under 2 MB. No compression needed.");
    }
    return picked;
  }

  static Future<File> _writeToTempFile(Uint8List bytes) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    return await tempFile.writeAsBytes(bytes);
  }
}
