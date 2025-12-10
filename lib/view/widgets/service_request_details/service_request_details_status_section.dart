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
        bgColor = AppColors.yellowDark;
        icon = Icons.hourglass_top;
        message = "This service request is currently in progress and awaiting further action.";
        actionButton = vendor
            ? null
            : OutlinedButton(
                style: OutlinedButton.styleFrom(
                  elevation: 0,
                  foregroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () => controller.onTapFinalizeButton(serviceRequestId, ServiceRequestStatus.completed.typeValue),
                child: Text(
                  "Finalize",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bgColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 15.sp),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (actionButton != null) ...[
              SizedBox(width: 12.w),
              controller.isLoadingServiceRequestStatus.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      child: CustomProgressBar(color: AppColors.white, size: 20.sp, strokeWidth: 2),
                    )
                  : actionButton,
            ],
          ],
        ),
      );
    });
  }
}
