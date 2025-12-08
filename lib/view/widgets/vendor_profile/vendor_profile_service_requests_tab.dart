import 'package:get/get.dart';
import 'package:flutter/material.dart';
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
          return NotificationListener<ScrollNotification>(
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
              )
          );
        },
      ),
    );
  }
}
