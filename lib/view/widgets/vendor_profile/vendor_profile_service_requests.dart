import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_request_item.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileServiceRequests extends GetWidget<VendorProfileController> {
  const VendorProfileServiceRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Service Requests",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.text101828,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Obx(
                    () => Text(
                      "${controller.serviceRequests.length} total",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.text4A5565,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Obx(() {
              final serviceRequests = controller.serviceRequests;
              if (controller.isLoadingServiceRequests.value) {
                return SizedBox(
                  height: Get.height / 1.3,
                  child: const CustomProgressBar(),
                );
              }
              if (serviceRequests.isEmpty) {
                return SizedBox(
                  height: Get.height / 1.3,
                  child: NoDataFound(
                    message: "No service requests found!",
                    isRefresh: true,
                    onPressed: controller.refreshServiceRequestsMe,
                  ),
                );
              }

              return Column(
                children: serviceRequests
                    .map(
                      (serviceRequest) => VendorProfileServiceRequestItem(serviceRequest: serviceRequest, controller: controller),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
