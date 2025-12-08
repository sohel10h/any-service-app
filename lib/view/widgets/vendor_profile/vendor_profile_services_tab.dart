import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_services.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class VendorProfileServicesTab extends GetWidget<VendorProfileController> {
  const VendorProfileServicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (context) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              //TODO: for further implementation of pagination
              return false;
            },
            child: CustomScrollView(
              key: PageStorageKey("servicesTab"),
              slivers: [
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                VendorProfileServices(),
              ],
            ),
          );
        },
      ),
    );
  }
}
