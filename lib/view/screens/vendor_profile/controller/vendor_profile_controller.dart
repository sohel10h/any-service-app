import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/local/vendor_profile_bid_model.dart';
import 'package:service_la/data/model/local/vendor_profile_service_model.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_bids.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';
import 'package:service_la/view/widgets/vendor_profile/vendor_profile_services.dart';

class VendorProfileController extends GetxController {
  LandingController landingController = Get.find<LandingController>();
  RxInt currentIndex = 0.obs;
  RxInt selectedTabIndex = 0.obs;
  final List<String> tabs = ["All Bids", "Services", "Completed", "Reviews"];
  final List<int> tabsCounts = [5, 1, 2, 0];
  List<CustomScrollView> tabViews = [];
  final bids = [
    VendorProfileBidModel(
      title: 'Deep Home Cleaning Service',
      customer: 'John Davis',
      location: 'Downtown',
      time: '2 hours ago',
      status: 'Active',
      amount: '\$89',
      statusColor: AppColors.containerFFEDD4,
      statusTextColor: AppColors.textCA3500,
    ),
    VendorProfileBidModel(
      title: 'Office Cleaning - Weekly',
      customer: 'Tech Corp',
      location: 'Financial District',
      time: '5 hours ago',
      status: 'Active',
      amount: '\$150',
      statusColor: AppColors.containerFFEDD4,
      statusTextColor: AppColors.textCA3500,
    ),
    VendorProfileBidModel(
      title: 'Move-in Cleaning',
      customer: 'Emily Chen',
      location: 'Mission Bay',
      time: '1 day ago',
      status: 'Pending',
      amount: '\$120',
      statusColor: AppColors.containerF3F4F6,
      statusTextColor: AppColors.text364153,
    ),
    VendorProfileBidModel(
      title: 'Post-Construction Cleaning',
      customer: 'BuildRight LLC',
      location: 'SOMA',
      time: '2 days ago',
      status: 'Accepted',
      amount: '\$200',
      statusColor: AppColors.containerDCFCE7,
      statusTextColor: AppColors.text008236,
    ),
  ];

  final services = [
    VendorProfileServiceModel(
      title: 'Deep Home Cleaning',
      category: 'Residential',
      price: '\$80–120/service',
      status: 'Active',
      statusColor: AppColors.containerDCFCE7,
      statusTextColor: AppColors.text008236,
      image: HelperFunction.placeholderImageUrl70,
    ),
    VendorProfileServiceModel(
      title: 'Office Cleaning',
      category: 'Commercial',
      price: '\$150–250/service',
      status: 'Active',
      statusColor: AppColors.containerDCFCE7,
      statusTextColor: AppColors.text008236,
      image: HelperFunction.placeholderImageUrl70,
    ),
    VendorProfileServiceModel(
      title: 'Move-in/Move-out Cleaning',
      category: 'Specialized',
      price: '\$100–180/service',
      status: 'Active',
      statusColor: AppColors.containerDCFCE7,
      statusTextColor: AppColors.text008236,
      image: HelperFunction.placeholderImageUrl70,
    ),
    VendorProfileServiceModel(
      title: 'Window Cleaning',
      category: 'Additional Services',
      price: '\$50–90/service',
      status: 'Inactive',
      statusColor: AppColors.containerF3F4F6,
      statusTextColor: AppColors.text364153,
      image: HelperFunction.placeholderImageUrl70,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _addViews();
  }

  void goToCreateServiceScreen() => Get.toNamed(AppRoutes.createServiceScreen);

  void _addViews() {
    tabViews = [
      CustomScrollView(
        slivers: [
          VendorProfileBids(),
        ],
      ),
      CustomScrollView(
        slivers: [
          VendorProfileServices(),
        ],
      ),
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Text("Tab 3")),
        ],
      ),
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Text("Tab 4")),
        ],
      ),
    ];
  }
}
