import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';

class ServiceRequestBottomSheet extends GetWidget<HomeController> {
  const ServiceRequestBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.4,
      maxChildSize: 0.6,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _bottomOption("assets/svgs/image_outline.svg", "Photo/video", color: Colors.green),
                    _bottomOption("assets/svgs/tag_outline.svg", "Tag service", color: Colors.blue),
                    _bottomOption("assets/svgs/smile.svg", "Service category", color: Colors.amber),
                    _bottomOption("assets/svgs/location_outline.svg", "Check in", color: Colors.red),
                    _bottomOption("assets/svgs/clock_outline.svg", "Urgent request", color: Colors.orange),
                    _bottomOption("assets/svgs/dollar.svg", "Budget range", color: Colors.teal),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomOption(String assetName, String text, {Color? color}) {
    return ListTile(
      leading: SvgPicture.asset(
        assetName,
        width: 20.w,
        height: 20.h,
        colorFilter: ColorFilter.mode(color ?? AppColors.text99A1AF, BlendMode.srcIn),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 15.sp,
          color: AppColors.text101828,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Get.back();
      },
    );
  }
}
