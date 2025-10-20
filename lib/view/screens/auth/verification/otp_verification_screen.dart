import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:service_la/view/screens/auth/verification/controller/otp_verification_controller.dart';
import 'package:service_la/view/widgets/text_field/custom_otp_field.dart';

class OtpVerificationScreen extends GetWidget<OtpVerificationController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 48.h),
              Container(
                width: 56.w,
                height: 56.h,
                padding: EdgeInsets.all(4.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.dividerE9EAEB),
                ),
                child: Transform.scale(
                  scale: .7,
                  child: SvgPicture.asset(
                    "assets/svgs/email.svg",
                    width: 28.w,
                    height: 28.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Check your email",
                style: TextStyle(
                  fontSize: 24.sp,
                  color: AppColors.text181D27,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "We sent a verification link to\n",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.text535862,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: controller.email,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.text535862,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Form(
                  key: controller.formKey,
                  child: CustomOtpField(
                    label: "Verification Code",
                    controller: controller.otpController,
                    focusNode: controller.otpFocusNode,
                    length: 6,
                    onChanged: (value) => controller.otpNumber = value,
                    validator: Validators.otp.call,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  child: ElevatedButton(
                    onPressed: controller.verifyEmailButtonOnTap,
                    child: const Text("Verify Email"),
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
                        "Didn’t receive the email?",
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
                      onTap: () {},
                      child: Text(
                        "Click to resend",
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
    );
  }
}
