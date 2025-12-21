import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';

class ServiceRequestBudgetRangeBottomSheet extends GetWidget<HomeController> {
  const ServiceRequestBudgetRangeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.containerE5E7EB,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Set Your Budget Range",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text101828,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Please enter your desired budget range below.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.text6A7282,
                  ),
                ),
                SizedBox(height: 20.h),
                Form(
                  key: controller.budgetFormKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: CustomTextField(
                            controller: controller.budgetFromController,
                            focusNode: controller.budgetFromFocusNode,
                            label: "From",
                            hintText: "৳1000",
                            textInputType: TextInputType.number,
                            decimalRange: 2,
                            onChanged: (from) => controller.budgetFormKey.currentState?.validate(),
                            validator: Validators.requiredWithFieldName("From").call,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: CustomTextField(
                            controller: controller.budgetToController,
                            focusNode: controller.budgetToFocusNode,
                            label: "To",
                            hintText: "৳5000",
                            textInputType: TextInputType.number,
                            decimalRange: 2,
                            onChanged: (to) => controller.budgetFormKey.currentState?.validate(),
                            validator: Validators.requiredWithFieldName("To").call,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.addBudgetRange,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: const Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
