import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/sign_in_model.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/services/websocket/websocket_service.dart';
import 'package:service_la/common/utils/notification_bottom_sheet_queue.dart';
import 'package:service_la/data/model/network/websocket/websocket_bid_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_vendor_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_service_request_model.dart';
import 'package:service_la/view/screens/service_details/controller/service_details_controller.dart';

class AppDIController extends GetxController {
  String authToken = "";
  static Rx<SignInModel> signInDetails = SignInModel().obs;

  @override
  void onInit() {
    super.onInit();
    _getStorageValue();
    _initServiceRequestNotifications();
    _initBidNotifications();
    _initVendorFoundNotifications();
    _initWebsockets();
  }

  static SignInModel setSignInDetails(SignInModel signIn) {
    log("SignInResponse: storing signin model response... ${signIn.toJson()}");
    signInDetails.value = signIn;
    return signInDetails.value;
  }

  void _initWebsockets() async {
    await HelperFunction.initWebSockets(authToken);
    _checkWebsocketsData();
  }

  void _checkWebsocketsData() async {
    WebSocketService.to.on('notification', (payload) async {
      int? type = HelperFunction.getWebsocketNotificationType(payload['raw']);
      log("WebsocketsResponseType from AppDIController: ${type ?? 0}");
      if (type == NotificationType.serviceRequest.typeValue) {
        WebsocketServiceRequestModel serviceRequest = WebsocketServiceRequestModel.fromApiResponse(payload['raw']);
        NotificationQueue.of<WebsocketServiceRequestModel>().add(serviceRequest);
      } else if (type == NotificationType.bid.typeValue) {
        WebsocketBidModel bid = WebsocketBidModel.fromApiResponse(payload['raw']);
        NotificationQueue.of<WebsocketBidModel>().add(bid);
      } else if (type == NotificationType.vendorFound.typeValue) {
        WebsocketVendorModel vendor = WebsocketVendorModel.fromApiResponse(payload['raw']);
        StorageHelper.setObject(StorageHelper.websocketVendorFoundResponse, vendor);
        NotificationQueue.of<WebsocketVendorModel>().add(vendor);
      }
    });
  }

  void _initVendorFoundNotifications() {
    NotificationQueue.of<WebsocketVendorModel>().configure(
      builder: (model, close) {
        DialogHelper.showNotificationBottomSheet(
          Get.context!,
          title: "New Vendor Found",
          message: model.data ?? "",
          onClosed: close,
        );
      },
    );
  }

  void _initServiceRequestNotifications() {
    NotificationQueue.of<WebsocketServiceRequestModel>().configure(
      builder: (model, close) {
        DialogHelper.showNotificationBottomSheet(
          Get.context!,
          title: "New Service Request",
          message: model.data ?? "",
          actionTitle: "Open",
          onPressed: () {
            Get.back();
            final currentRoute = Get.currentRoute;
            if (currentRoute == AppRoutes.serviceDetailsScreen) {
              ServiceDetailsController controller = Get.find<ServiceDetailsController>();
              controller.onRefresh(serviceRequestIdValue: model.id);
            } else {
              goToServiceRequestDetails(model.id ?? "");
            }
          },
          onClosed: close,
        );
      },
    );
  }

  void goToServiceRequestDetails(String id) {
    final queue = NotificationQueue.of<WebsocketServiceRequestModel>();
    queue.allowedRoute = AppRoutes.landingScreen;

    Get.toNamed(
      AppRoutes.serviceDetailsScreen,
      arguments: {"serviceRequestId": id},
    )?.then((_) {
      queue.allowedRoute = null;
      queue.resume();
    });
  }

  void _initBidNotifications() {
    NotificationQueue.of<WebsocketBidModel>().configure(
      builder: (model, close) {
        DialogHelper.showNotificationBottomSheet(
          Get.context!,
          title: "New bid received",
          message: model.message ?? "",
          actionTitle: "View Bid",
          onPressed: () {
            Get.back();
            final currentRoute = Get.currentRoute;
            if (currentRoute == AppRoutes.serviceDetailsScreen) {
              ServiceDetailsController controller = Get.find<ServiceDetailsController>();
              controller.onRefresh(serviceRequestIdValue: model.serviceRequestId);
            } else {
              goToBidDetails(model.serviceRequestId ?? "");
            }
          },
          onClosed: close,
        );
      },
    );
  }

  void goToBidDetails(String id) {
    final queue = NotificationQueue.of<WebsocketBidModel>();
    queue.allowedRoute = AppRoutes.landingScreen;

    Get.toNamed(
      AppRoutes.serviceDetailsScreen,
      arguments: {"serviceRequestId": id},
    )?.then((_) {
      queue.allowedRoute = null;
      queue.resume();
    });
  }

  void _getStorageValue() {
    authToken = StorageHelper.getValue(StorageHelper.authToken);
    dynamic websocketVendorFoundResponse = StorageHelper.getObject(StorageHelper.websocketVendorFoundResponse);
    log("WebsocketVendorFoundResponse: $websocketVendorFoundResponse");
  }
}
