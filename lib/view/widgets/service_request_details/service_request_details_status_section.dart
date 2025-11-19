import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class ServiceRequestDetailsStatusSection extends GetWidget<ServiceRequestDetailsController> {
  const ServiceRequestDetailsStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color bgColor;
      IconData icon;
      String message;
      Widget? actionButton;

      final serviceDetailsData = controller.serviceDetailsData.value;
      final status = serviceDetailsData.status ?? 0;
      final serviceRequestId = serviceDetailsData.id ?? "";
      final vendor = !controller.isProvider.value;

      if (status == ServiceRequestStatus.inProgress.typeValue) {
        bgColor = AppColors.yellow;
        icon = Icons.hourglass_top;
        message = "This service request is currently in progress and awaiting further action.";
        actionButton = vendor
            ? null
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  textStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () => controller.onTapFinalizeButton(serviceRequestId, ServiceRequestStatus.completed.typeValue),
                child: const Text("Finalize"),
              );
      } else if (status == ServiceRequestStatus.completed.typeValue) {
        bgColor = AppColors.green;
        icon = Icons.check_circle;
        message = "This service request has been completed successfully.";
        actionButton = null;
      } else {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bgColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (actionButton != null) ...[
              SizedBox(width: 12.w),
              controller.isLoadingServiceRequestStatus.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      child: CustomProgressBar(color: AppColors.white, size: 24, strokeWidth: 2),
                    )
                  : actionButton,
            ],
          ],
        ),
      );
    });
  }
}
