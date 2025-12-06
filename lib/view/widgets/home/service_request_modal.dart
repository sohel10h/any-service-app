import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';
import 'package:service_la/view/widgets/home/service_request_budget_item.dart';
import 'package:service_la/view/widgets/home/service_request_toggle_button.dart';

class ServiceRequestModal extends GetWidget<HomeController> {
  const ServiceRequestModal({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewInsets = MediaQuery.of(context).viewInsets.bottom;
      controller.isKeyboardVisible.value = viewInsets > 0;
    });

    return Material(
      color: Colors.transparent,
      child: Obx(() {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            if (controller.hasUnsavedChanges.value) {
              DialogHelper.showDiscardWarning(context);
            } else {
              controller.isIndividualSelected.value = true;
              Get.back();
              controller.landingController.changeIndex(0, context);
            }
          },
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
                        _header(context),
                        Divider(color: AppColors.containerE5E7EB, height: 0.h, thickness: 5),
                        Expanded(
                          child: SingleChildScrollView(child: _body(context)),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () {
                    if (!controller.isKeyboardVisible.value) return SizedBox.shrink();
                    return Positioned(
                      bottom: 0.h,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: AppColors.containerF4F4F4,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: controller.fileOptions.map((option) {
                              return IconButton(
                                onPressed: option.onTap,
                                icon: SvgPicture.asset(
                                  option.image ?? "",
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _header(BuildContext context) {
    const double rightWidgetWidth = 70;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: SizedBox(
        height: 40.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: Get.width / 1.9,
              child: Text(
                "Create request",
                style: TextStyle(
                  fontSize: 17.sp,
                  color: AppColors.text101828,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () {
                  if (controller.hasUnsavedChanges.value) {
                    DialogHelper.showDiscardWarning(context);
                  } else {
                    controller.isIndividualSelected.value = true;
                    Get.back();
                    controller.landingController.changeIndex(0, context);
                  }
                },
                icon: SvgPicture.asset(
                  "assets/svgs/close.svg",
                  width: 21.w,
                  height: 21.h,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Obx(() {
                final isLoading = controller.isLoadingServiceRequests.value;
                final isIndividual = controller.isIndividualSelected.value;
                final desc = controller.serviceDescription.value;
                final company = controller.companyName.value;
                final isDisabled = isIndividual ? desc.isEmpty : desc.isEmpty || company.isEmpty;
                return SizedBox(
                  width: rightWidgetWidth.w,
                  child: isLoading
                      ? const CustomProgressBar(size: 24, strokeWidth: 2)
                      : Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ElevatedButton(
                            onPressed: isDisabled ? null : () => controller.onTapPostButton(context),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            child: Text(
                              "Post",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                );
              }),
            ),
          ],
        ),
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
                    AppDIController.adminUser.value.picture?.virtualPath ?? "",
                    height: 35.w,
                    width: 35.w,
                    radius: 32.r,
                    isUserImage: true,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  AppDIController.signInDetails.value.data?.userName ?? "",
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
          child: ServiceRequestToggleButton(
            onValueChanged: (isIndividualSelected) {
              controller.isIndividualSelected.value = isIndividualSelected;
            },
          ),
        ),
        Obx(
          () => controller.isIndividualSelected.value
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),
                      CustomTextField(
                        controller: controller.companyNameController,
                        focusNode: controller.companyNameFocusNode,
                        hintText: "Enter your company name",
                        onChanged: (companyName) => controller.onCompanyNameTextChanged(companyName),
                      ),
                    ],
                  ),
                ),
        ),
        SizedBox(height: 8.h),
        CustomTextField(
          controller: controller.serviceController,
          focusNode: controller.serviceFocusNode,
          hintText: "What service do you need?",
          labelStyle: TextStyle(
            fontSize: 15.sp,
            color: AppColors.text414651,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            fontSize: 18.sp,
            color: AppColors.text99A1AF,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 5,
          textInputType: TextInputType.multiline,
          onChanged: (service) => controller.onServiceTextChanged(service),
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
        SizedBox(height: 16.h),
        controller.minBudget.value.isEmpty || controller.maxBudget.value.isEmpty
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ServiceRequestBudgetItem(),
              ),
        controller.isKeyboardVisible.value ? SizedBox(height: 70.h) : SizedBox(height: 20.h),
      ],
    );
  }
}
