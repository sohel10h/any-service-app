import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/model/local/provider_bid_model.dart';
import 'package:service_la/data/repository/service_request_repo.dart';
import 'package:service_la/data/model/network/service_details_model.dart';
import 'package:service_la/view/widgets/service_details/service_details_provider_bids_section.dart';

class ServiceDetailsController extends GetxController {
  String serviceId = "";
  RxInt currentIndex = 0.obs;
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedFilterIndex = 0.obs;
  final List<String> tabs = ["All Bids", "Shortlisted", "Rejected", "Final Bid"];
  List<CustomScrollView> tabViews = [];
  final List<int> tabsCounts = [5, 1, 2, 0];
  final List<String> filters = ["Lowest Price", "Top Rated"];
  final ServiceRequestRepo _serviceRequestRepo = ServiceRequestRepo();
  RxBool isLoadingServiceRequestsDetails = false.obs;
  Rx<ServiceDetailsData> serviceDetailsData = ServiceDetailsData().obs;
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
    _getArguments();
    _addViews();
    _getServiceRequestsDetails();
  }

  Future<void> _getServiceRequestsDetails() async {
    isLoadingServiceRequestsDetails.value = true;
    try {
      var response = await _serviceRequestRepo.getServiceRequestsDetails(serviceId);

      if (response is String) {
        log("ServiceRequestsDetails get failed from controller response: $response");
      } else {
        ServiceDetailsModel serviceDetails = response as ServiceDetailsModel;
        if (serviceDetails.status == 200 || serviceDetails.status == 201) {
          serviceDetailsData.value = serviceDetails.serviceDetailsData ?? ServiceDetailsData();
        } else {
          if (serviceDetails.status == 401 ||
              (serviceDetails.errors != null &&
                  serviceDetails.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().refreshTokenAndRetry(() => _serviceRequestRepo.getServiceRequestsDetails(serviceId));
            if (retryResponse is ServiceDetailsModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              serviceDetailsData.value = serviceDetails.serviceDetailsData ?? ServiceDetailsData();
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("ServiceRequestsDetails get failed from controller: ${serviceDetails.status}");
          return;
        }
      }
    } catch (e) {
      log("ServiceRequestsDetails get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServiceRequestsDetails.value = false;
    }
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

  void _getArguments() {
    if (Get.arguments != null) {
      serviceId = Get.arguments["serviceId"];
    }
  }
}
