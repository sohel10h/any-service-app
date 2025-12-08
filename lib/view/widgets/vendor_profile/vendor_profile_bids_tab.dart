import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bids.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bid_list.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileBidsTab extends GetWidget<VendorProfileController> {
  const VendorProfileBidsTab({super.key});

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
                controller.loadNextPageRequestBids();
              }
              return false;
            },
            child: CustomScrollView(
              key: PageStorageKey("bidsTab"),
              slivers: [
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                VendorProfileBids(),
                VendorProfileBidList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
