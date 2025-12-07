import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/no_data_found.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_review_item.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileReviewList extends GetWidget<VendorProfileController> {
  const VendorProfileReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingVendorReviews.value) {
        return const SliverFillRemaining(
          child: CustomProgressBar(),
        );
      }
      if (controller.vendorReviews.isEmpty) {
        return SliverFillRemaining(
          child: NoDataFound(
            message: "No reviews found!",
            isRefresh: true,
            onPressed: () => controller.refreshVendorReviews(isLoadingEmpty: true),
          ),
        );
      }
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index < controller.vendorReviews.length) {
                final item = controller.vendorReviews[index];
                return VendorProfileReviewItem(
                  review: item,
                  controller: controller,
                );
              }
              return Obx(
                () => controller.isLoadingMoreVendorReviews.value
                    ? Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: const CustomProgressBar(),
                      )
                    : const SizedBox.shrink(),
              );
            },
            childCount: controller.vendorReviews.length + 1,
          ),
        ),
      );
    });
  }
}
