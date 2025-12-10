import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_app_bar.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/common/network_image_loader.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_edit_controller.dart';

class VendorProfileEditScreen extends GetView<VendorProfileEditController> {
  const VendorProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Edit Profile",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: controller.nameController,
                focusNode: controller.nameFocusNode,
                label: "Name",
                hintText: "Enter your name",
                textInputAction: TextInputAction.next,
                onChanged: (name) => controller.formKey.currentState?.validate(),
                validator: Validators.requiredWithFieldName("Name").call,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: controller.phoneController,
                focusNode: controller.phoneFocusNode,
                label: "Phone Number",
                hintText: "Enter your phone number",
                textInputType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                textInputAction: TextInputAction.done,
                onChanged: (email) => controller.formKey.currentState?.validate(),
                validator: Validators.phoneNumber(11).call,
              ),
              SizedBox(height: 30.h),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Obx(() {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            controller.selectedImage.value == null
                ? NetworkImageLoader(
                    controller.user.value.picture?.virtualPath ?? "",
                    width: 110.w,
                    height: 110.w,
                    borderRadius: BorderRadius.circular(80.r),
                    isUserImage: true,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(80.r),
                    child: Image.file(
                      File(controller.selectedImage.value!.path),
                      width: 110.w,
                      height: 110.w,
                      fit: BoxFit.cover,
                    ),
                  ),
            Positioned(
              right: -4,
              bottom: -4,
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset(
                    "assets/svgs/camera.svg",
                    width: 16.w,
                    height: 16.h,
                    colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                  ),
                  onPressed: controller.pickImage,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 48.h,
        child: controller.isLoadingUpdateAdminUser.value
            ? CustomProgressBar()
            : ElevatedButton(
                onPressed: controller.onTapSaveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: controller.isLoadingUpdateAdminUser.value
                    ? SizedBox(
                        width: 22.w,
                        height: 22.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
      );
    });
  }
}
