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
      appBar: CustomAppbar(
        title: "Settings",
        centerTitle: false,
        leadingWidth: 2.w,
        backButton: const SizedBox.shrink(),
      ),
      body: Center(
        child: Text(
          "Settings",
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.text6A7282,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
