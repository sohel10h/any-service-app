import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/service_request_details/custom_service_request_bid_filter.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_provider_bids_item.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class ServiceRequestDetailsProviderBidsSection extends GetWidget<ServiceRequestDetailsController> {
  const ServiceRequestDetailsProviderBidsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Obx(
                () =>
                CustomServiceRequestBidFilter(
                  filters: controller.filters,
                  selectedIndex: controller.selectedFilterIndex.value,
                  onSelected: (index) {
                    controller.selectedFilterIndex.value = index;
                    if (controller.selectedFilterIndex.value == 0) {
                      controller.sortBidsByLowestPrice(controller.serviceDetailsData.value.bids);
                      controller.serviceDetailsData.update((val) {
                        val?.bids = List.from(controller.serviceDetailsData.value.bids ?? []);
                      });
                    } else {
                      controller.sortBidsByTopRatedUser(controller.serviceDetailsData.value.bids);
                      controller.serviceDetailsData.update((val) {
                        val?.bids = List.from(controller.serviceDetailsData.value.bids ?? []);
                      });
                    }
                  },
                ),
          ),
          SizedBox(height: 20.h),
          Obx(
                () {
              final allBids = controller.serviceDetailsData.value.bids;
              if ((allBids?.isEmpty ?? true)) {
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
                children: allBids
                    ?.map(
                      (bid) =>
                      ServiceRequestDetailsProviderBidsItem(
                        bid: bid,
                        onAccept: () => controller.onTapAcceptBidButton(bid.id ?? "", !(bid.userApproved ?? false)),
                        onShortlist: () => controller.onTapShortlistButton(bid.id ?? "", !(bid.isShortlisted ?? false)),
                        onReject: () => controller.onTapRejectBidButton(bid.id ?? "", ServiceRequestBidStatus.rejected.typeValue),
                        onMessage: () {},
                        isApprovedLoading: controller.isApprovedLoadingMap[bid.id] ?? false.obs,
                        isShortlistedLoading: controller.isShortlistedLoadingMap[bid.id] ?? false.obs,
                        isRejectedLoading: controller.isRejectedLoadingMap[bid.id] ?? false.obs,
                        controller: controller,
                      ),
                )
                    .toList() ??
                    [],
              );
            },
          ),
        ],
      ),
    );
  }
}
