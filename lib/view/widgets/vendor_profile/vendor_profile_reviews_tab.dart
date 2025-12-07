import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_reviews.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_review_list.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileReviewsTab extends GetWidget<VendorProfileController> {
  const VendorProfileReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.white,
            onRefresh: () => controller.refreshVendorReviews(isRefresh: true),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
                  controller.loadNextPageVendorReviews();
                }
                return false;
              },
              child: CustomScrollView(
                key: PageStorageKey("vendorReviewsTab"),
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  VendorProfileReviews(),
                  VendorProfileReviewList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
