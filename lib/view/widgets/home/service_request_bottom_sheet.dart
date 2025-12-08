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
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 10.r,
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
                    _bottomOption(
                      "assets/svgs/image_outline.svg",
                      "Photo/video",
                      onTap: () {
                        Get.back();
                        controller.pickImages();
                      },
                    ),
                    _bottomOption(
                      "assets/svgs/tag_outline.svg",
                      "Tag service",
                      onTap: () {},
                    ),
                    _bottomOption(
                      "assets/svgs/location_outline.svg",
                      "Check in",
                      onTap: () {},
                    ),
                    _bottomOption(
                      "assets/svgs/clock_outline.svg",
                      "Urgent request",
                      onTap: () {},
                    ),
                    _bottomOption(
                      "assets/svgs/dollar.svg",
                      "Budget range",
                      onTap: () {
                        Get.back();
                        controller.openBudgetRangeBottomSheet(context);
                      },
                    ),
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

  Widget _bottomOption(String assetName, String text, {required VoidCallback onTap}) {
    return ListTile(
      leading: SvgPicture.asset(
        assetName,
        width: 18.w,
        height: 18.h,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.text101828,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
