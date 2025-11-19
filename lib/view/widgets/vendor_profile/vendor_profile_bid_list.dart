import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bid_item.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileBidList extends GetWidget<VendorProfileController> {
  const VendorProfileBidList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingServiceRequestBids.value) {
        return const SliverFillRemaining(
          child: CustomProgressBar(),
        );
      }
      if (controller.serviceRequestBids.isEmpty) {
        return SliverFillRemaining(
          child: NoDataFound(
            message: "No bids found!",
            isRefresh: true,
            onPressed: () => controller.refreshServiceRequestBids(isLoadingEmpty: true),
          ),
        );
      }
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < controller.serviceRequestBids.length) {
                final item = controller.serviceRequestBids[index];
                return VendorProfileBidItem(
                  bid: item,
                  controller: controller,
                );
              }
              return Obx(
                () => controller.isLoadingMoreServiceRequestBids.value
                    ? Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: const CustomProgressBar(),
                      )
                    : const SizedBox.shrink(),
              );
            },
            childCount: controller.serviceRequestBids.length + 1,
          ),
        ),
      );
    });
  }
}
