import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/auth/custom_auth_clipper.dart';
import 'package:service_la/view/widgets/text_field/custom_phone_field.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/auth/sign_up/controller/sign_up_controller.dart';

class SigUpScreen extends GetWidget<SignUpController> {
  const SigUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: CustomAuthClipper(),
                    child: Container(
                      height: 170.h,
                      width: double.infinity,
                      color: AppColors.containerB63B1F,
                    ),
                  ),
                  Positioned(
                    bottom: -10.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 60.r,
                        backgroundColor: Colors.white,
                        child: SvgPicture.asset(
                          "assets/svgs/logo.svg",
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.text9AA0B8,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "Service La",
                style: TextStyle(
                  fontSize: 28.sp,
                  color: AppColors.text0C174B,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextField(
                  controller: controller.firstNameController,
                  focusNode: controller.firstNameFocusNode,
                  label: "First Name",
                  hintText: "Enter your first name",
                  onChanged: (email) => controller.formKey.currentState?.validate(),
                  validator: Validators.requiredWithFieldName("First Name").call,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextField(
                  controller: controller.lastNameController,
                  focusNode: controller.lastNameFocusNode,
                  label: "Last Name",
                  hintText: "Enter your last name",
                  onChanged: (email) => controller.formKey.currentState?.validate(),
                  validator: Validators.requiredWithFieldName("Last Name").call,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextField(
                  controller: controller.emailController,
                  focusNode: controller.emailFocusNode,
                  label: "Email Address",
                  hintText: "Enter your email address",
                  textInputType: TextInputType.emailAddress,
                  onChanged: (email) => controller.formKey.currentState?.validate(),
                  validator: Validators.email.call,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomPhoneField(
                  controller: controller.phoneController,
                  focusNode: controller.phoneFocusNode,
                  label: "Phone Number",
                  hintText: "Phone number",
                  readOnly: false,
                  initialCountryCode: "BD",
                  onChanged: (phone) => controller.formKey.currentState?.validate(),
                ),
              ),
              SizedBox(height: 12.h),
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
                    onChanged: (password) => controller.formKey.currentState?.validate(),
                    validator: Validators.password.call,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: CustomTextField(
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
              Padding(
                padding: EdgeInsets.only(left: 4.w, top: 8.h, right: 8.w, bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Theme(
                        data: Theme.of(context).copyWith(
                          checkboxTheme: CheckboxThemeData(
                            side: BorderSide(color: AppColors.textCCD6DD),
                          ),
                        ),
                        child: Checkbox(
                          value: controller.isAgreeWithTAndC.value,
                          onChanged: (val) => controller.isAgreeWithTAndC.value = val ?? false,
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "I agree with the Terms & Condition",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textCCD6DD,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!(controller.formKey.currentState?.validate() ?? true)) {
                        return;
                      }
                    },
                    child: const Text("Sign Up"),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Text(
                  "- OR -",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textA1A1A1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Image.asset(
                          "assets/images/google.png",
                          width: 25.w,
                          height: 25.h,
                        ),
                        label: Text(
                          "Continue Google",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textA1A1A1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          side: BorderSide(color: AppColors.borderE8E8E8),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/svgs/facebook.svg",
                          width: 22.w,
                          height: 22.h,
                        ),
                        label: Text(
                          "Continue Facebook",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textA1A1A1,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          side: BorderSide(color: AppColors.borderE8E8E8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.text524B6B,
                          fontWeight: FontWeight.w400,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: controller.goToSignInScreen,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textFF9228,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
