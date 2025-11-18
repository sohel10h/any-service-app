import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/sign_in_model.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/services/websocket/websocket_service.dart';
import 'package:service_la/common/notification/notification_service.dart';
import 'package:service_la/common/utils/notification_bottom_sheet_queue.dart';
import 'package:service_la/data/model/network/websocket/websocket_bid_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_vendor_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_response_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_service_request_model.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

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
    if (authToken.isNotEmpty) {
      await HelperFunction.initWebSockets(authToken);
      _checkWebsocketsData();
    }
  }

  void _checkWebsocketsData() async {
    WebSocketService.to.on('notification', (payload) async {
      int? type = HelperFunction.getWebsocketNotificationType(payload['raw']);
      log("WebsocketsResponseType from AppDIController: ${type ?? 0}");
      if (type == NotificationType.serviceRequest.typeValue) {
        final serviceRequest = WebsocketResponseModel.fromApiResponse(
          payload['raw'],
          (json) => WebsocketServiceRequestModel.fromJson(json),
        );
        NotificationQueue.of<WebsocketResponseModel<WebsocketServiceRequestModel>>().add(serviceRequest);
        if (!WebSocketService.to.isForeground) {
          NotificationService.showSimpleNotification(
            title: serviceRequest.title ?? "",
            body: serviceRequest.parsedData?.data ?? "",
            payload: serviceRequest.parsedData?.id ?? "",
          );
        }
      } else if (type == NotificationType.bid.typeValue) {
        final bid = WebsocketResponseModel.fromApiResponse(
          payload['raw'],
          (json) => WebsocketBidModel.fromJson(json),
        );
        NotificationQueue.of<WebsocketResponseModel<WebsocketBidModel>>().add(bid);
        if (!WebSocketService.to.isForeground) {
          NotificationService.showSimpleNotification(
            title: bid.title ?? "",
            body: bid.parsedData?.message ?? "",
            payload: bid.parsedData?.serviceRequestId ?? "",
          );
        }
      } else if (type == NotificationType.vendorFound.typeValue) {
        final vendor = WebsocketResponseModel.fromApiResponse(
          payload['raw'],
          (json) => WebsocketVendorModel.fromJson(json),
        );
        StorageHelper.setObject(StorageHelper.websocketVendorFoundResponse, vendor.parsedData);
        NotificationQueue.of<WebsocketResponseModel<WebsocketVendorModel>>().add(vendor);
        if (!WebSocketService.to.isForeground) {
          NotificationService.showSimpleNotification(
            title: vendor.title ?? "",
            body: vendor.parsedData?.data ?? "",
            payload: "",
          );
        }
      }
    });
  }

  void _initVendorFoundNotifications() {
    NotificationQueue.of<WebsocketResponseModel<WebsocketVendorModel>>().configure(
      builder: (model, close) {
        DialogHelper.showNotificationBottomSheet(
          Get.context!,
          title: model.title ?? "",
          message: model.parsedData?.data ?? "",
          onClosed: close,
        );
      },
    );
  }

  void _initServiceRequestNotifications() {
    NotificationQueue.of<WebsocketResponseModel<WebsocketServiceRequestModel>>().configure(
      builder: (model, close) {
        DialogHelper.showNotificationBottomSheet(
          Get.context!,
          title: model.title ?? "",
          message: model.parsedData?.data ?? "",
          actionTitle: "Open",
          onPressed: () {
            Get.back();
            final currentRoute = Get.currentRoute;
            if (currentRoute == AppRoutes.serviceRequestDetailsScreen) {
              ServiceRequestDetailsController controller = Get.find<ServiceRequestDetailsController>();
              controller.onRefresh(serviceRequestIdValue: model.parsedData?.id);
            } else {
              goToServiceRequestDetails(model.parsedData?.id ?? "");
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
      AppRoutes.serviceRequestDetailsScreen,
      arguments: {"serviceRequestId": id},
    )?.then((_) {
      queue.allowedRoute = null;
      queue.resume();
    });
  }

  void _initBidNotifications() {
    NotificationQueue.of<WebsocketResponseModel<WebsocketBidModel>>().configure(
      builder: (model, close) {
        DialogHelper.showNotificationBottomSheet(
          Get.context!,
          title: model.title ?? "",
          message: model.parsedData?.message ?? "",
          actionTitle: "View Bid",
          onPressed: () {
            Get.back();
            final currentRoute = Get.currentRoute;
            if (currentRoute == AppRoutes.serviceRequestDetailsScreen) {
              ServiceRequestDetailsController controller = Get.find<ServiceRequestDetailsController>();
              controller.onRefresh(serviceRequestIdValue: model.parsedData?.serviceRequestId);
            } else {
              goToBidDetails(model.parsedData?.serviceRequestId ?? "");
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
      AppRoutes.serviceRequestDetailsScreen,
      arguments: {"serviceRequestId": id},
    )?.then((_) {
      queue.allowedRoute = null;
      queue.resume();
    });
  }

  void _getStorageValue() {
    authToken = StorageHelper.getValue(StorageHelper.authToken) ?? "";
    dynamic websocketVendorFoundResponse = StorageHelper.getObject(StorageHelper.websocketVendorFoundResponse);
    log("WebsocketVendorFoundResponse: $websocketVendorFoundResponse");
  }
}
