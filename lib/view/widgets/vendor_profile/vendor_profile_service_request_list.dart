import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_request_item.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileServiceRequestList extends GetWidget<VendorProfileController> {
  const VendorProfileServiceRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingServiceRequests.value) {
        return const SliverFillRemaining(
          child: CustomProgressBar(),
        );
      }
      if (controller.serviceRequests.isEmpty) {
        return SliverFillRemaining(
          child: NoDataFound(
            message: "No service requests found!",
            isRefresh: true,
            onPressed: () => controller.refreshServiceRequestsMe(isLoadingEmpty: true),
          ),
        );
      }
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < controller.serviceRequests.length) {
                final item = controller.serviceRequests[index];
                return VendorProfileServiceRequestItem(
                  serviceRequest: item,
                  controller: controller,
                );
              }

              return Obx(
                () => controller.isLoadingMoreServiceRequests.value
                    ? Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: const CustomProgressBar(),
                      )
                    : const SizedBox.shrink(),
              );
            },
            childCount: controller.serviceRequests.length + 1,
          ),
        ),
      );
    });
  }
}
