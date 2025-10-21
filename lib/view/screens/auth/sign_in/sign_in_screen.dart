import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/auth/sign_in/controller/sign_in_controller.dart';

class SignInScreen extends GetWidget<SignInController> {
  const SignInScreen({super.key});

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
                    "Welcome Back",
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
                    "Please enter your details.",
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
                    controller: controller.emailController,
                    focusNode: controller.emailFocusNode,
                    label: "Email",
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress,
                    onChanged: (email) => controller.formKey.currentState?.validate(),
                    validator: Validators.email.call,
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
                      onChanged: (password) => controller.formKey.currentState?.validate(),
                      validator: Validators.password.call,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.w, top: 8.h, right: 8.w, bottom: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Obx(
                              () => Theme(
                                data: Theme.of(context).copyWith(
                                  checkboxTheme: CheckboxThemeData(
                                    side: BorderSide(color: AppColors.textCCD6DD),
                                  ),
                                ),
                                child: Checkbox(
                                  value: controller.isRememberMe.value,
                                  onChanged: (val) => controller.isRememberMe.value = val ?? false,
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "Remember for 30 days",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.text414651,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textF25B39,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Obx(
                    () => controller.isLoadingSignIn.value
                        ? CustomProgressBar()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.signInButtonOnTap,
                              child: const Text("Sign In"),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          "Don’t have an account?",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.text535862,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      GestureDetector(
                        onTap: controller.goToSignUpScreen,
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textF25B39,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}
