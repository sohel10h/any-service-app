import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_requests.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_service_request_list.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileServiceRequestsTab extends GetWidget<VendorProfileController> {
  const VendorProfileServiceRequestsTab({super.key});

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
            onRefresh: () => controller.refreshServiceRequestsMe(isRefresh: true),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 100) {
                  controller.loadNextPageServiceRequests();
                }
                return false;
              },
              child: CustomScrollView(
                key: PageStorageKey("serviceRequestsTab"),
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  VendorProfileServiceRequests(),
                  VendorProfileServiceRequestList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
