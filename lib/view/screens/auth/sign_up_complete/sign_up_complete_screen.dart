import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/auth/sign_up_complete/controller/sign_up_complete_controller.dart';

class SignUpCompleteScreen extends GetWidget<SignUpCompleteController> {
  const SignUpCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                SizedBox(height: 48.h),
                SvgPicture.asset(
                  "assets/svgs/logo.svg",
                  width: 40.w,
                  height: 56.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: AppColors.text181D27,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "Complete your details.",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.text535862,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomTextField(
                    controller: controller.nameController,
                    focusNode: controller.nameFocusNode,
                    label: "Name",
                    hintText: "Enter your name",
                    onChanged: (email) => controller.formKey.currentState?.validate(),
                    validator: Validators.requiredWithFieldName("Name").call,
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => CustomTextField(
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocusNode,
                      label: "Password",
                      hintText: "Enter your password",
                      obscureText: !controller.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        onPressed: () => controller.isPasswordVisible.toggle(),
                        icon: SvgPicture.asset(
                          controller.isPasswordVisible.value ? "assets/svgs/logo.svg" : "assets/svgs/close_eye.svg",
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                            controller.isPasswordVisible.value ? AppColors.primary : AppColors.lightBlack,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      onChanged: (password) {
                        controller.password.value = password;
                        controller.formKey.currentState?.validate();
                      },
                      validator: Validators.password.call,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => CustomTextField(
                      controller: controller.confirmPasswordController,
                      focusNode: controller.confirmPasswordFocusNode,
                      label: "Confirm Password",
                      hintText: "Enter your confirm password",
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          controller.isConfirmPasswordVisible.value ? "assets/svgs/logo.svg" : "assets/svgs/close_eye.svg",
                          width: 24.w,
                          height: 24.h,
                          colorFilter: ColorFilter.mode(
                            controller.isConfirmPasswordVisible.value ? AppColors.primary : AppColors.lightBlack,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () => controller.isConfirmPasswordVisible.toggle(),
                      ),
                      onChanged: (confirmPassword) => controller.formKey.currentState?.validate(),
                      validator: Validators.confirmPassword(controller.password.value).call,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Obx(
                    () => controller.isLoading.value
                        ? CustomProgressBar()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.submitButtonOnTap,
                              child: const Text("Submit"),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
