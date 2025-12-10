import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/validators.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/data/model/network/service_me_model.dart';
import 'package:service_la/view/widgets/home/custom_dropdown_chip.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/text_field/custom_text_field.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class ServiceRequestDetailsCreateBids extends GetWidget<ServiceRequestDetailsController> {
  const ServiceRequestDetailsCreateBids({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Services",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text414651,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(
              () => CustomDropdownChip<ServiceMeData>(
                width: double.infinity,
                height: 36.h,
                options: controller.serviceMeDataList,
                selectedValue: controller.selectedServiceMeData,
                hint: "Select services",
                labelBuilder: (serviceMeData) => serviceMeData.name ?? "",
                onChanged: (serviceMeData) {
                  log("SelectedServiceMeData: ${serviceMeData.toJson()}");
                },
                isDisabled: controller.isBidEdit.value,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomTextField(
              controller: controller.descriptionController,
              focusNode: controller.descriptionFocusNode,
              label: "Bids Description",
              labelStyle: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text414651,
                fontWeight: FontWeight.w500,
              ),
              hintText: "Enter description",
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text717680.withValues(alpha: .6),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 4,
              onChanged: (description) => controller.formKey.currentState?.validate(),
              validator: Validators.requiredWithFieldName("Description").call,
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomTextField(
              controller: controller.priceController,
              focusNode: controller.priceFocusNode,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              label: "Price",
              labelStyle: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text414651,
                fontWeight: FontWeight.w500,
              ),
              hintText: "৳2000",
              hintStyle: TextStyle(
                fontSize: 12.sp,
                color: AppColors.text717680.withValues(alpha: .6),
                fontWeight: FontWeight.w500,
              ),
              textInputType: TextInputType.number,
              onChanged: (price) => controller.formKey.currentState?.validate(),
              validator: Validators.requiredWithFieldName("Price").call,
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(
              () => (!controller.isLoadingUpdateBids.value && controller.isBidEdit.value)
                  ? SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => controller.isBidEdit.value = false,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(
              () => controller.isLoadingCrateBids.value || controller.isLoadingUpdateBids.value
                  ? CustomProgressBar()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.onTapServiceRequestBids,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        ),
                        child: Text(
                          controller.isBidEdit.value ? "Edit" : "Submit",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
