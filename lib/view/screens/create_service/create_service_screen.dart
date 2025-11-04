import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/widgets/create_service/draggable_image_section.dart';
import 'package:service_la/view/screens/create_service/controller/create_service_controller.dart';

class CreateServiceScreen extends GetWidget<CreateServiceController> {
  const CreateServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        isBackButton: true,
        backButton: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 31.w,
              height: 31.w,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: AppColors.containerF3F4F6,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/svgs/arrow_left.svg",
                width: 14.w,
                height: 14.h,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: "Create Service",
        textStyle: TextStyle(
          fontSize: 17.sp,
          color: AppColors.text101828,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextField(
                  controller: controller.serviceNameController,
                  focusNode: controller.serviceNameFocusNode,
                  label: "Service Name",
                  hintText: "Enter service name",
                  onChanged: (serviceName) => controller.formKey.currentState?.validate(),
                  validator: Validators.requiredWithFieldName("Service Name").call,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextField(
                  controller: controller.descriptionController,
                  focusNode: controller.descriptionFocusNode,
                  label: "Description",
                  hintText: "Enter description",
                  maxLines: 4,
                  onChanged: (description) => controller.formKey.currentState?.validate(),
                  validator: Validators.requiredWithFieldName("Description").call,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Provide Price Range",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.text414651,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Obx(
                      () => Transform.scale(
                        scale: 1.1,
                        child: Switch(
                          value: controller.isPriceRange.value,
                          onChanged: (val) => controller.isPriceRange.value = val,
                          activeTrackColor: AppColors.primary.withValues(alpha: 0.9),
                          inactiveThumbColor: AppColors.borderD5D7DA,
                          inactiveTrackColor: AppColors.borderE5E7EB.withValues(alpha: 0.7),
                          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                          splashRadius: 24.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () {
                  if (controller.isPriceRange.value) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: controller.priceFromController,
                              focusNode: controller.priceFromFocusNode,
                              label: "From",
                              hintText: "৳1000",
                              textInputType: TextInputType.number,
                              onChanged: (priceFrom) => controller.formKey.currentState?.validate(),
                              validator: Validators.requiredWithFieldName("Price From").call,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: CustomTextField(
                              controller: controller.priceToController,
                              focusNode: controller.priceToFocusNode,
                              label: "To",
                              hintText: "৳5000",
                              textInputType: TextInputType.number,
                              onChanged: (priceTo) => controller.formKey.currentState?.validate(),
                              validator: Validators.requiredWithFieldName("Price To").call,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: CustomTextField(
                        controller: controller.priceController,
                        focusNode: controller.priceFocusNode,
                        label: "Price",
                        hintText: "৳2000",
                        textInputType: TextInputType.number,
                        onChanged: (price) => controller.formKey.currentState?.validate(),
                        validator: Validators.requiredWithFieldName("Price").call,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  "Service Images",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 150.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: AppColors.borderE3E5E5,
                      dashPattern: [6, 3],
                      strokeWidth: 2,
                      radius: Radius.circular(8.r),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),
                          IconButton(
                            onPressed: controller.pickImages,
                            icon: Container(
                              padding: EdgeInsets.all(16.sp),
                              decoration: BoxDecoration(
                                color: AppColors.borderE3E5E5.withValues(alpha: .5),
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                "assets/svgs/camera.svg",
                                width: 21.w,
                                height: 21.h,
                                colorFilter: ColorFilter.mode(AppColors.text4A5565, BlendMode.srcIn),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Click to upload images",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.text0A0A0A,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "PNG, JPG, JPEG up to 2MB each",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.text101828,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Obx(
                () => controller.selectedImages.isEmpty
                    ? const SizedBox.shrink()
                    : DraggableImageGrid(
                        items: controller.selectedImages,
                        loadingFlags: controller.imageLoadingFlags,
                        onReorder: controller.reorderImages,
                        onRemove: controller.removeImage,
                      ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Obx(
                  () => controller.isLoadingCrateService.value
                      ? CustomProgressBar()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.onTapCreateServiceButton,
                            child: const Text("Create Service"),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
