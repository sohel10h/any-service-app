import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/sign_in_model.dart';
import 'package:service_la/services/location/location_service.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/services/websocket/websocket_service.dart';
import 'package:service_la/common/notification/notification_service.dart';
import 'package:service_la/common/utils/notification_bottom_sheet_queue.dart';
import 'package:service_la/data/model/network/websocket/websocket_bid_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_vendor_model.dart';
import 'package:service_la/view/screens/chats/controller/chats_room_controller.dart';
import 'package:service_la/data/model/network/websocket/websocket_message_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_response_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_service_request_model.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class AppDIController extends GetxController {
  String authToken = "";
  static Rx<SignInModel> signInDetails = SignInModel().obs;
  late final LocationService locationService;
  final Rx<WebsocketMessageModel> message = WebsocketMessageModel().obs;
  final RxnInt unreadNotificationCount = RxnInt();

  @override
  void onInit() {
    super.onInit();
    _getStorageValue();
    _initServiceRequestNotifications();
    _initBidNotifications();
    _initVendorFoundNotifications();
    _initWebsockets();
    _setupLocationServices();
  }

  void sendWebsocketsConversationJoinData(Map<String, dynamic> joinPayload) async {
    log("WebsocketsMessageSendParams: $joinPayload");
    WebSocketService.to.send(joinPayload);
  }

  Future<void> sendWebsocketsMessageData(Map<String, dynamic> messagePayload) async {
    log("WebsocketsMessageSendParams: $messagePayload");
    WebSocketService.to.send(messagePayload);
  }

  Future<void> _setupLocationServices() async {
    locationService = await LocationService.init();
    bool granted = await locationService.ensureLocationPermission(
      showDialogs: false,
    );
    if (!granted) {
      log("LocationService: Location not granted at startup");
    }
  }

  static SignInModel setSignInDetails(SignInModel signIn) {
    log("SignInResponse: storing signin model response... ${signIn.toJson()}");
    signInDetails.value = signIn;
    return signInDetails.value;
  }

  void _initWebsockets() async {
    if (authToken.isNotEmpty) {
      await HelperFunction.initWebSockets(authToken);
      _checkWebsocketsNotificationData();
      _checkWebsocketsMessageData();
    }
  }

  void _checkWebsocketsMessageData() async {
    WebSocketService.to.on(WebsocketPayloadType.message.name, (payload) async {
      log("WebsocketsMessageResponse from AppDIController: ${payload['raw']}");
      final model = WebsocketMessageModel.fromMap(payload['raw']);
      message.value = model;
      ChatsRoomController controller = Get.find<ChatsRoomController>();
      if (message.value.message != null) {
        controller.onWebsocketReceived(message.value.message!);
      }
    });
  }

  void _checkWebsocketsNotificationData() async {
    WebSocketService.to.on(WebsocketPayloadType.notification.name, (payload) async {
      int? type = HelperFunction.getWebsocketNotificationType(payload['raw']);
      unreadNotificationCount.value = HelperFunction.getWebsocketNotificationUnreadCount(payload['raw']);
      log("WebsocketsResponseType from AppDIController: ${type ?? 0}");
      if (type == NotificationType.serviceRequest.typeValue) {
        final serviceRequest = WebsocketResponseModel.fromApiResponse(
          payload['raw'],
          (json) => WebsocketServiceRequestModel.fromJson(json),
        );
        NotificationQueue.of<WebsocketResponseModel<WebsocketServiceRequestModel>>().add(serviceRequest);
        if (!WebSocketService.to.isForeground) {
          NotificationService.showSimpleNotification(
            title: serviceRequest.notification?.title ?? "",
            body: serviceRequest.notification?.body ?? "",
            payload: serviceRequest.notification?.parsedData?.id ?? "",
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
            title: bid.notification?.title ?? "",
            body: bid.notification?.body ?? "",
            payload: bid.notification?.parsedData?.serviceRequestId ?? "",
          );
        }
      } else if (type == NotificationType.vendorFound.typeValue) {
        final vendor = WebsocketResponseModel.fromApiResponse(
          payload['raw'],
          (json) => WebsocketVendorModel.fromJson(json),
        );
        StorageHelper.setObject(StorageHelper.websocketVendorFoundResponse, vendor.notification?.parsedData);
        NotificationQueue.of<WebsocketResponseModel<WebsocketVendorModel>>().add(vendor);
        if (!WebSocketService.to.isForeground) {
          NotificationService.showSimpleNotification(
            title: vendor.notification?.title ?? "",
            body: vendor.notification?.body ?? "",
            payload: "",
          );
        }
      } else if (type == NotificationType.vendorNotFound.typeValue) {
        final vendor = WebsocketResponseModel.fromApiResponse(
          payload['raw'],
          (json) => WebsocketVendorModel.fromJson(json),
        );
        StorageHelper.setObject(StorageHelper.websocketVendorFoundResponse, vendor.notification?.parsedData);
        NotificationQueue.of<WebsocketResponseModel<WebsocketVendorModel>>().add(vendor);
        if (!WebSocketService.to.isForeground) {
          NotificationService.showSimpleNotification(
            title: vendor.notification?.title ?? "",
            body: vendor.notification?.body ?? "",
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
          title: model.notification?.title ?? "",
          message: model.notification?.parsedData?.data ?? "",
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
          title: model.notification?.title ?? "",
          message: model.notification?.parsedData?.data ?? "",
          actionTitle: "Open",
          onPressed: () {
            Get.back();
            final currentRoute = Get.currentRoute;
            if (currentRoute == AppRoutes.serviceRequestDetailsScreen) {
              ServiceRequestDetailsController controller = Get.find<ServiceRequestDetailsController>();
              controller.onRefresh(serviceRequestIdValue: model.notification?.parsedData?.id);
            } else {
              goToServiceRequestDetails(model.notification?.parsedData?.id ?? "");
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
          title: model.notification?.title ?? "",
          message: model.notification?.parsedData?.message ?? "",
          actionTitle: "View Bid",
          onPressed: () {
            Get.back();
            final currentRoute = Get.currentRoute;
            if (currentRoute == AppRoutes.serviceRequestDetailsScreen) {
              ServiceRequestDetailsController controller = Get.find<ServiceRequestDetailsController>();
              controller.onRefresh(serviceRequestIdValue: model.notification?.parsedData?.serviceRequestId);
            } else {
              goToBidDetails(model.notification?.parsedData?.serviceRequestId ?? "");
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

  @override
  void onClose() {
    Get.delete<LocationService>();
    super.onClose();
  }
}
