import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/common/tab_bar_delegate.dart';
import 'package:service_la/view/widgets/service_details/service_details_tab.dart';
import 'package:service_la/view/widgets/service_details/service_details_image_slider.dart';
import 'package:service_la/view/widgets/service_details/service_details_details_section.dart';
import 'package:service_la/view/screens/service_details/controller/service_details_controller.dart';
import 'package:service_la/view/widgets/service_details/service_details_bid_comparison_section.dart';

class ServiceDetailsScreen extends GetWidget<ServiceDetailsController> {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: controller.tabs.length,
        initialIndex: controller.selectedTabIndex.value,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: ServiceDetailsImageSlider(),
            ),
            SliverToBoxAdapter(
              child: ServiceDetailsDetailsSection(),
            ),
            SliverToBoxAdapter(
              child: ServiceDetailsBidComparisonSection(),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: TabBarDelegate(
                child: ServiceDetailsTab(isFromNestedScroll: true),
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
        ),
      ),
    );
  }
}
