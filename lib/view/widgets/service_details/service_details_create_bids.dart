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
import 'package:service_la/view/screens/service_details/controller/service_details_controller.dart';

class ServiceDetailsCreateBids extends GetWidget<ServiceDetailsController> {
  const ServiceDetailsCreateBids({super.key});

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
                fontSize: 14.sp,
                color: AppColors.text414651,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomDropdownChip<ServiceMeData>(
              width: double.infinity,
              height: 48.h,
              options: controller.serviceMeDataList,
              selectedValue: controller.selectedServiceMeData,
              hint: "Select services",
              labelBuilder: (serviceMeData) => serviceMeData.name ?? "",
              onChanged: (serviceMeData) {
                log("SelectedServiceMeData: ${serviceMeData.toJson()}");
              },
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomTextField(
              controller: controller.descriptionController,
              focusNode: controller.descriptionFocusNode,
              label: "Bids Description",
              hintText: "Enter description",
              maxLines: 4,
              onChanged: (description) => controller.formKey.currentState?.validate(),
              validator: Validators.requiredWithFieldName("Description").call,
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
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
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(
              () => controller.isLoadingCrateBids.value
                  ? CustomProgressBar()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.onTapServiceRequestBids,
                        child: const Text("Submit"),
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
