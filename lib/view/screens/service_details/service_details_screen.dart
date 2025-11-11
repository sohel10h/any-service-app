import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/tab_bar_delegate.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/service_details/service_details_tab.dart';
import 'package:service_la/view/widgets/service_details/service_details_create_bids.dart';
import 'package:service_la/view/widgets/service_details/service_details_image_slider.dart';
import 'package:service_la/view/widgets/service_details/service_details_details_section.dart';
import 'package:service_la/view/widgets/service_details/service_details_vendor_bid_item.dart';
import 'package:service_la/view/screens/service_details/controller/service_details_controller.dart';
import 'package:service_la/view/widgets/service_details/service_details_bid_comparison_section.dart';

class ServiceDetailsScreen extends GetWidget<ServiceDetailsController> {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.isLoadingServiceRequestsDetails.value
            ? const CustomProgressBar()
            : DefaultTabController(
                length: controller.tabs.length,
                initialIndex: controller.selectedTabIndex.value,
                child: _buildServiceDetailsContent(),
              ),
      ),
    );
  }

  Widget _buildServiceDetailsContent() {
    return Obx(() {
      final bids = controller.serviceDetailsData.value.bids;
      final bidData = controller.bidData.value;

      List<Widget> commonChildren = const [
        ServiceDetailsImageSlider(),
        ServiceDetailsDetailsSection(),
        ServiceDetailsBidComparisonSection(),
      ];

      if ((bids?.isEmpty ?? true) && bidData == null) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...commonChildren,
              ...controller.isProvider.value ? [SizedBox(height: 24.h)] : [const ServiceDetailsCreateBids()],
            ],
          ),
        );
      }

      if (bidData != null) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...commonChildren,
              SizedBox(height: 16.h),
              const ServiceDetailsVendorBidItem(),
            ],
          ),
        );
      }

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: const ServiceDetailsImageSlider()),
          SliverToBoxAdapter(child: const ServiceDetailsDetailsSection()),
          SliverToBoxAdapter(child: const ServiceDetailsBidComparisonSection()),
          SliverPersistentHeader(
            pinned: true,
            delegate: TabBarDelegate(
              child: const ServiceDetailsTab(isFromNestedScroll: true),
            ),
          ),
        ],
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(
            controller.tabs.length,
            (index) => controller.tabViews[index],
          ),
        ),
      );
    });
  }
}
