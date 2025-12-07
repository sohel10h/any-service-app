import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/service_request_details/custom_service_request_bid_filter.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_provider_bids_item.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class ServiceRequestDetailsProviderRejectedBidsSection extends GetWidget<ServiceRequestDetailsController> {
  const ServiceRequestDetailsProviderRejectedBidsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Obx(
            () => CustomServiceRequestBidFilter(
              filters: controller.filters,
              selectedIndex: controller.selectedFilterIndex.value,
              onSelected: (index) {
                controller.selectedFilterIndex.value = index;
                if (controller.selectedFilterIndex.value == 0) {
                  controller.sortBidsByLowestPrice(controller.rejectBids);
                  controller.rejectBids.refresh();
                } else {
                  controller.sortBidsByTopRatedUser(controller.rejectBids);
                  controller.rejectBids.refresh();
                }
              },
            ),
          ),
          SizedBox(height: 20.h),
          Obx(
            () {
              final rejectBids = controller.rejectBids;
              if (rejectBids.isEmpty) {
                return SizedBox(
                  height: Get.height / 3,
                  child: Center(
                    child: Text(
                      "No bids are found!",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.text6A7282,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: rejectBids
                    .map(
                      (bid) => ServiceRequestDetailsProviderBidsItem(
                        bid: bid,
                        onAccept: () {},
                        onShortlist: () {},
                        onReject: () {},
                        onMessage: () {},
                        isApprovedLoading: controller.isApprovedLoadingMap[bid.id] ?? false.obs,
                        isShortlistedLoading: controller.isShortlistedLoadingMap[bid.id] ?? false.obs,
                        isRejectedLoading: controller.isRejectedLoadingMap[bid.id] ?? false.obs,
                        controller: controller,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
