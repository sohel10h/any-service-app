import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class ServiceRequestDetailsDetailsSection extends GetWidget<ServiceRequestDetailsController> {
  const ServiceRequestDetailsDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Service Details",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.text0A0A0A,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              _buildDetailTile(
                imagesPath: "assets/images/checkmark_small.png",
                title: "Description",
                subtitle: controller.serviceDetailsData.value.description ?? "",
                imageContainerColor: AppColors.containerDCFCE7,
              ),
              _buildDetailTile(
                imagesPath: "assets/images/location_pin.png",
                title: "Location",
                subtitle: "123 Main Street, Downtown", //TODO: need to get this data from API
                imageContainerColor: AppColors.containerDBEAFE,
              ),
              _buildDetailTile(
                imagesPath: "assets/images/dollar_bag.png",
                title: "Budget Range",
                subtitle: "\$${controller.serviceDetailsData.value.budgetMin ?? "0"}"
                    " – \$${controller.serviceDetailsData.value.budgetMax ?? "0"}",
                imageContainerColor: AppColors.containerFFEDD4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required String imagesPath,
    required String title,
    String? subtitle,
    Widget? subtitleWidget,
    Color? imageContainerColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 17.w,
            height: 17.h,
            decoration: BoxDecoration(
              color: imageContainerColor ?? AppColors.containerDCFCE7,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Image.asset(imagesPath),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.text4A5565,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                subtitleWidget ??
                    Text(
                      subtitle ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.text101828,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
