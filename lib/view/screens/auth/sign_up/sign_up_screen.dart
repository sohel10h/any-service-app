import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/auth/sign_up/controller/sign_up_controller.dart';

class SignUpScreen extends GetWidget<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 48.h),
                      Center(
                        child: SvgPicture.asset(
                          "assets/svgs/logo.svg",
                          width: 40.w,
                          height: 56.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColors.text181D27,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Start turning your ideas into reality.",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.text535862,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      Form(
                        key: controller.formKey,
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
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
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
                            "Google",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textA1A1A1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.containerFAFAFA,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            side: BorderSide(color: AppColors.borderD5D7DA),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            "assets/svgs/apple.svg",
                            width: 22.w,
                            height: 22.h,
                          ),
                          label: Text(
                            "Apple",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textA1A1A1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.containerFAFAFA,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            side: BorderSide(color: AppColors.borderD5D7DA),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(color: AppColors.dividerE9EAEB),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.text181D27,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: AppColors.dividerE9EAEB),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.registerButtonOnTap,
                      child: const Text("Register"),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: GestureDetector(
                      onTap: controller.goToSignInScreen,
                      child: Text(
                        "Already have an account",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.text414651,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.text414651,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
