import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/local/provider_bid_model.dart';
import 'package:service_la/view/widgets/service_details/service_details_provider_bids_section.dart';

class ServiceDetailsController extends GetxController {
  RxList<String> imageUrls = <String>[].obs;
  RxInt currentIndex = 0.obs;
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedFilterIndex = 0.obs;
  final List<String> tabs = ["All Bids", "Shortlisted", "Rejected", "Final Bid"];
  List<CustomScrollView> tabViews = [];
  final List<int> tabsCounts = [5, 1, 2, 0];
  final List<String> filters = ["Lowest Price", "Top Rated"];
  final RxList<ProviderBidModel> bids = [
    ProviderBidModel(
      name: "David Martinez",
      title: "General Cleaning",
      price: 75,
      rating: 4.7,
      jobsCount: 189,
      timeAgo: "1 hour ago",
      description: "Affordable and reliable cleaning service. I have 3 years "
          "of experience and great references. Can work around your schedule.",
      availability: "Available next week",
      duration: "4–5 hours",
      isBest: true,
      belowBudget: true,
      shortlisted: false,
      imageUrl: HelperFunction.userImage1,
    ),
    ProviderBidModel(
      name: "Sarah Johnson",
      title: "Deep Cleaning Expert",
      price: 89,
      rating: 4.9,
      jobsCount: 456,
      timeAgo: "5 mins ago",
      description: "I specialize in deep cleaning and have over 5 years of experience. "
          "I use eco-friendly products and guarantee excellent results.",
      availability: "Available tomorrow",
      duration: "3–4 hours",
      isBest: false,
      belowBudget: true,
      shortlisted: true,
      imageUrl: HelperFunction.userImage2,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _addImagesUrls();
    _addViews();
  }

  void _addViews() {
    tabViews = [
      CustomScrollView(
        slivers: [
          ServiceDetailsProviderBidsSection(),
        ],
      ),
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Text("Tab 2")),
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

  void _addImagesUrls() {
    imageUrls.clear();
    imageUrls.value = [
      HelperFunction.imageUrl1,
      HelperFunction.imageUrl2,
      HelperFunction.placeholderImageUrl412_320,
    ];
  }
}
