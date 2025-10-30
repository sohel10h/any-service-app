import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/view/widgets/service_details/service_details_image_slider.dart';
import 'package:service_la/view/widgets/service_details/service_details_details_section.dart';
import 'package:service_la/view/widgets/service_details/service_details_provider_bids_section.dart';
import 'package:service_la/view/screens/service_details/controller/service_details_controller.dart';
import 'package:service_la/view/widgets/service_details/service_details_bid_comparison_section.dart';

class ServiceDetailsScreen extends GetWidget<ServiceDetailsController> {
  const ServiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ServiceDetailsImageSlider(),
          ServiceDetailsDetailsSection(),
          ServiceDetailsBidComparisonSection(),
          ServiceDetailsProviderBidsSection(),
        ],
      ),
    );
  }
}
