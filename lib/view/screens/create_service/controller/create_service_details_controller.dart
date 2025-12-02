import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/data/repository/admin_repo.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/data/model/network/create_service_details_model.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';

class CreateServiceDetailsController extends GetxController {
  String serviceId = "";
  RxInt currentIndex = 0.obs;
  final AdminRepo _adminRepo = AdminRepo();
  RxBool isLoadingServicesDetails = false.obs;
  Rx<CreateServiceDetailsData> createServiceDetailsData = CreateServiceDetailsData().obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _getAdminServicesDetails();
  }

  Future<void> onRefresh() async {
    await _getAdminServicesDetails();
  }

  void goToProfileScreen(String? userId) {
    Get.delete<VendorProfileController>();
    Get.toNamed(
      AppRoutes.vendorProfileScreen,
      arguments: {
        "userId": userId,
      },
    );
  }

  void goToChatsRoomScreen({
    required String username,
    required String conversationId,
    required String userId,
  }) {
    Get.toNamed(
      AppRoutes.chatsRoomScreen,
      arguments: {
        "chatUsername": username,
        "conversationId": conversationId,
        "chatUserId": userId,
        "isInsideChat": false,
      },
    );
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
            final retryResponse = await ApiService().postRefreshTokenAndRetry(() => _adminRepo.getAdminServicesDetails(serviceId));
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
