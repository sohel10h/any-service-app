import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/data/repository/admin_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/model/network/create_service_details_model.dart';

class CreateServiceDetailsController extends GetxController {
  String serviceId = "";
  RxInt currentIndex = 0.obs;
  final AdminRepo _adminRepo = AdminRepo();
  RxBool isLoadingServicesDetails = false.obs;
  Rx<CreateServiceDetailsData> createServiceDetailsData = CreateServiceDetailsData().obs;
  final List<Map<String, dynamic>> reviews = [
    {
      "image": HelperFunction.userImage1,
      "name": "Jay Johnson",
      "timeAgo": "2 days ago",
      "rating": 3,
      "review": "Excellent service! They fixed my AC quickly and professionally. Very satisfied with the work.",
    },
    {
      "image": HelperFunction.userImage2,
      "name": "Michael Chen",
      "timeAgo": "2 weeks ago",
      "rating": 4,
      "review": "Great technician! Arrived on time and explained everything clearly. Highly recommend!",
    },
    {
      "image": HelperFunction.userImage3,
      "name": "Rock Russel",
      "timeAgo": "1 week ago",
      "rating": 5,
      "review": "Good service overall. The AC is working perfectly now. Price was fair.",
    },
    {
      "image": HelperFunction.userImage2,
      "name": "Francky Jhu",
      "timeAgo": "3 weeks ago",
      "rating": 4,
      "review": "Great technician! Arrived on time and explained everything clearly. Highly recommend!",
    },
    {
      "image": HelperFunction.userImage3,
      "name": "Philips Dilli",
      "timeAgo": "1 hour ago",
      "rating": 4,
      "review": "Excellent service! They fixed my AC quickly and professionally. Very satisfied with the work.",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _getAdminServicesDetails();
  }

  Future<void> _getAdminServicesDetails() async {
    isLoadingServicesDetails.value = true;
    try {
      var response = await _adminRepo.getAdminServicesDetails(serviceId);

      if (response is String) {
        log("AdminServicesDetails get failed from controller response: $response");
      } else {
        CreateServiceDetailsModel createServiceDetails = response as CreateServiceDetailsModel;
        if (createServiceDetails.status == 200 || createServiceDetails.status == 201) {
          createServiceDetailsData.value = createServiceDetails.createServiceDetailsData ?? CreateServiceDetailsData();
        } else {
          if (createServiceDetails.status == 401 ||
              (createServiceDetails.errors != null &&
                  createServiceDetails.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().refreshTokenAndRetry(() => _adminRepo.getAdminServicesDetails(serviceId));
            if (retryResponse is CreateServiceDetailsModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              createServiceDetailsData.value = createServiceDetails.createServiceDetailsData ?? CreateServiceDetailsData();
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("AdminServicesDetails get failed from controller: ${createServiceDetails.status}");
          return;
        }
      }
    } catch (e) {
      log("AdminServicesDetails get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingServicesDetails.value = false;
    }
  }

  void _getArguments() {
    if (Get.arguments != null) {
      serviceId = Get.arguments["serviceId"];
    }
  }
}
