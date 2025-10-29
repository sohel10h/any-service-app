import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/home/custom_dropdown_chip.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';
import 'package:service_la/view/widgets/home/service_request_bottom_sheet.dart';

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
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  height: size.height * 1,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 16.h),
                      _header(),
                      Divider(color: AppColors.containerE5E7EB, height: 0.h, thickness: 5),
                      Expanded(
                        child: SingleChildScrollView(child: _body(context)),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: SvgPicture.asset(
              "assets/svgs/close.svg",
              width: 21.w,
              height: 21.h,
            ),
          ),
          Expanded(
            child: Text(
              "Create request",
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.text101828,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Flexible(
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Post",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.text9AA0B8,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
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
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                height: 30.h,
                child: CustomDropdownChip<String>(
                  options: controller.requestTypeOptions,
                  selectedValue: controller.requestType,
                  iconPath: "assets/svgs/person_small.svg",
                  labelBuilder: (v) => v,
                  onChanged: (val) {
                    // handle change
                  },
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showBottomSheet(context),
                icon: SvgPicture.asset(
                  "assets/svgs/image_outline.svg",
                  width: 22.w,
                  height: 22.h,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: controller.searchController,
          focusNode: controller.searchFocusNode,
          hintText: "What service do you need?",
          labelStyle: TextStyle(
            fontSize: 15.sp,
            color: AppColors.text414651,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            fontSize: 15.sp,
            color: AppColors.text99A1AF,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 5,
          textInputType: TextInputType.multiline,
          onChanged: (service) {},
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => SizedBox(
            height: 120.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: controller.selectedImages.length,
              itemBuilder: (context, index) {
                final image = controller.selectedImages[index];
                final isLoading = controller.imageLoadingFlags.length > index ? controller.imageLoadingFlags[index] : false;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.file(
                          File(image.path),
                          width: 120.w,
                          height: 120.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isLoading)
                        Positioned.fill(
                          child: CustomProgressBar(),
                        ),
                      isLoading
                          ? SizedBox.shrink()
                          : Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => controller.removeImage(index),
                                child: Icon(Icons.cancel, color: AppColors.red),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  void _showBottomSheet(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 50));

    await Get.bottomSheet(
      const ServiceRequestBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
