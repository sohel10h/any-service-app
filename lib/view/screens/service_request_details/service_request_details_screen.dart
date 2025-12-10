import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/view/widgets/common/tab_bar_delegate.dart';
import 'package:service_la/view/widgets/common/custom_progress_bar.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_tab.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_create_bids.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_image_slider.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_status_section.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_details_section.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_vendor_bid_item.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';
import 'package:service_la/view/widgets/service_request_details/service_request_details_bid_comparison_section.dart';

class ServiceRequestDetailsScreen extends GetWidget<ServiceRequestDetailsController> {
  const ServiceRequestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.white,
        onRefresh: controller.onRefresh,
        child: Obx(
          () => controller.isLoadingServiceRequestsDetails.value
              ? const CustomProgressBar()
              : DefaultTabController(
                  length: controller.tabs.length,
                  initialIndex: controller.selectedTabIndex.value,
                  child: _buildServiceDetailsContent(),
                ),
        ),
      ),
    );
  }

  Widget _buildServiceDetailsContent() {
    return Obx(() {
      final serviceDetails = controller.serviceDetailsData.value;
      final bids = controller.serviceDetailsData.value.bids;
      final bidData = controller.bidData.value;
      final isBidEdit = controller.isBidEdit.value;

      List<Widget> commonChildren = const [
        ServiceRequestDetailsImageSlider(),
        ServiceRequestDetailsStatusSection(),
        ServiceRequestDetailsDetailsSection(),
        ServiceRequestDetailsBidComparisonSection(),
      ];

      if (isBidEdit || ((bids?.isEmpty ?? true) && bidData == null)) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...commonChildren,
              ...controller.isProvider.value || serviceDetails.status == ServiceRequestStatus.completed.typeValue
                  ? []
                  : [
                      const ServiceRequestDetailsCreateBids(),
                    ],
            ],
          ),
        );
      }

      if (bidData != null) {
        return SingleChildScrollView(
          child: Column(
            children: [
              ...commonChildren,
              SizedBox(height: 24.h),
              const ServiceRequestDetailsVendorBidItem(),
            ],
          ),
        );
      }

      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: const ServiceRequestDetailsImageSlider()),
          SliverToBoxAdapter(child: const ServiceRequestDetailsStatusSection()),
          SliverToBoxAdapter(child: const ServiceRequestDetailsDetailsSection()),
          SliverToBoxAdapter(child: const ServiceRequestDetailsBidComparisonSection()),
          SliverPersistentHeader(
            pinned: true,
            delegate: TabBarDelegate(
              child: const ServiceRequestDetailsTab(isFromNestedScroll: true),
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
