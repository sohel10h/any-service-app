import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/view/widgets/home/custom_dropdown_chip.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';

class ServiceRequestModal extends GetWidget<HomeController> {
  const ServiceRequestModal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Hero(
      tag: "service_request_modal",
      createRectTween: (begin, end) {
        return MaterialRectCenterArcTween(begin: begin, end: end);
      },
      child: Material(
        color: Colors.transparent,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: 1,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(color: Colors.black.withValues(alpha: 0.3)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  height: size.height * 0.85,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      _header(),
                      Divider(color: AppColors.containerE5E7EB, height: 1),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: _body(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(
              "assets/svgs/close.svg",
              width: 21.w,
              height: 21.h,
            ),
          ),
          Text(
            "Create request",
            style: TextStyle(
              fontSize: 17.sp,
              color: AppColors.text101828,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.containerE5E7EB,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Post",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.text99A1AF,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16.r,
              child: NetworkImageLoader(
                HelperFunction.placeholderImageUrl30,
                height: 35.w,
                width: 35.w,
                radius: 32.r,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Individual Request",
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.text101828,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            CustomDropdownChip<String>(
              options: controller.requestTypeOptions,
              selectedValue: controller.requestType,
              iconPath: "assets/svgs/person_small.svg",
              labelBuilder: (v) => v,
              onChanged: (val) {
                // handle change
              },
            ),
            CustomDropdownChip<String>(
              options: controller.urgencyOptions,
              selectedValue: controller.urgency,
              iconPath: "assets/svgs/clock_small.svg",
              labelBuilder: (v) => v,
            ),
            CustomDropdownChip<String>(
              options: controller.budgetOptions,
              selectedValue: controller.budget,
              iconPath: "assets/svgs/dollar_small.svg",
              labelBuilder: (v) => v,
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextField(
          maxLines: null,
          decoration: InputDecoration(
            hintText: "What service do you need?",
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _bottomOption(Icons.image_outlined, "Photo/video", color: Colors.green),
        _bottomOption(Icons.sell_outlined, "Tag service", color: Colors.blue),
        _bottomOption(Icons.category_outlined, "Service category", color: Colors.amber),
        _bottomOption(Icons.location_on_outlined, "Check in", color: Colors.redAccent),
        _bottomOption(Icons.access_time_outlined, "Urgent request", color: Colors.deepOrange),
        _bottomOption(Icons.attach_money_outlined, "Budget range", color: Colors.green),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _bottomOption(IconData icon, String text, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black54),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
      onTap: () {},
    );
  }
}
