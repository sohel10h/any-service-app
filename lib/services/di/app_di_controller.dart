import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/data/repository/fcm_repo.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/data/repository/admin_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/sign_in_model.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/services/location/location_service.dart';
import 'package:service_la/data/model/network/admin_user_model.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/services/websocket/websocket_service.dart';
import 'package:service_la/common/notification/notification_service.dart';
import 'package:service_la/data/model/network/user_device_token_model.dart';
import 'package:service_la/common/utils/notification_bottom_sheet_queue.dart';
import 'package:service_la/data/model/network/websocket/websocket_bid_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_vendor_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_message_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_response_model.dart';
import 'package:service_la/data/model/network/websocket/websocket_service_request_model.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class AppDIController extends GetxController with WidgetsBindingObserver {
  static Rx<AppLifecycleState> appLifecycleState = AppLifecycleState.resumed.obs;
  static String authToken = "";
  static String loginUserId = "";
  static String loginUsername = "";
  static Rx<SignInModel> signInDetails = SignInModel().obs;
  late final LocationService locationService;
  static final Rx<WebsocketMessageModel> message = WebsocketMessageModel().obs;
  static final RxnInt unreadNotificationCount = RxnInt();
  static RxString lastChatRoomUserId = "".obs;
  static final AdminRepo _adminRepo = AdminRepo();
  static RxBool isLoadingAdminUser = false.obs;
  static Rx<AdminUser> adminUser = AdminUser().obs;
  static final FcmRepo _fcmRepo = FcmRepo();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    getStorageValue();
    _initServiceRequestNotifications();
    _initBidNotifications();
    _initVendorFoundNotifications();
    initWebsockets();
    _setupLocationServices();
    _postUserDeviceTokens();
    _getAdminUser();
  }

  static Future<void> _postUserDeviceTokens() async {
    try {
      dynamic params = {
        ApiParams.deviceToken: await FirebaseMessaging.instance.getToken() ?? "",
        ApiParams.deviceType: Platform.isAndroid ? AppDeviceType.android.typeValue : AppDeviceType.ios.typeValue,
      };
      log("UserDeviceTokens POST Params: $params");
      var response = await _fcmRepo.postUserDeviceTokens(params);
      if (response is String) {
        log("UserDeviceTokens failed from controller response: $response");
      } else {
        UserDeviceTokenModel userDeviceToken = response as UserDeviceTokenModel;
        if (userDeviceToken.status == 200 || userDeviceToken.status == 201) {
          log("UserDeviceTokens submitted successfully from controller: ${userDeviceToken.status} ${userDeviceToken.data?.userId}");
        } else {
          log("UserDeviceTokens failed from controller: ${userDeviceToken.status}");
        }
      }
    } catch (e) {
      log("UserDeviceTokens catch error from controller: ${e.toString()}");
    } finally {
      // statement
    }
  }

  static Future<void> refreshAdminUser({String? userId}) async {
    await _getAdminUser(userId: userId);
  }

  static Future<void> _getAdminUser({String? userId}) async {
    isLoadingAdminUser.value = true;
    try {
      var response = await _adminRepo.getAdminUser(userId ?? AppDIController.loginUserId);
      if (response is String) {
        log("AdminUser get failed from controller response: $response");
      } else {
        AdminUserModel adminUserModel = response as AdminUserModel;
        if (adminUserModel.status == 200 || adminUserModel.status == 201) {
          adminUser.value = adminUserModel.adminUser ?? AdminUser();
        } else {
          if (adminUserModel.status == 401 ||
              (adminUserModel.errors != null &&
                  adminUserModel.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _adminRepo.getAdminUser(userId ?? AppDIController.loginUserId),
            );
            if (retryResponse is AdminUserModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              adminUser.value = retryResponse.adminUser ?? AdminUser();
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("AdminUser get failed from controller: ${adminUserModel.status}");
          return;
        }
      }
    } catch (e) {
      log("AdminUser get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingAdminUser.value = false;
    }
  }

  static Future<void> sendWebsocketsMessageData(Map<String, dynamic> messagePayload) async {
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

  static void initWebsockets() async {
    if (authToken.isNotEmpty) {
      await HelperFunction.initWebSockets(authToken);
      _checkWebsocketsNotificationData();
      _checkWebsocketsMessageData();
    }
  }

  static void _checkWebsocketsMessageData() async {
    WebSocketService.to.on(WebsocketPayloadType.message.name, (payload) async {
      log("WebsocketsMessageResponse from AppDIController: ${payload['raw']}");
      final model = WebsocketMessageModel.fromMap(payload['raw']);
      message.value = model;
      _sendWebsocketsMessagesNotifications(message.value);
    });
  }

  static void _sendWebsocketsMessagesNotifications(WebsocketMessageModel wsMsg) async {
    log("LastChatRoomUserId: ${AppDIController.lastChatRoomUserId.value}");
    if (wsMsg.message == null) return;
    final msg = wsMsg.message!;
    final isBackground = appLifecycleState.value != AppLifecycleState.resumed;
    final isDifferentChatRoomUser = AppDIController.lastChatRoomUserId.value != msg.senderId;
    final isDifferentLoginUser = AppDIController.loginUserId != msg.senderId;
    if (isBackground || isDifferentChatRoomUser) {
      if (isDifferentLoginUser) {
        await NotificationService.showSimpleNotification(
          title: msg.senderName ?? "",
          body: msg.content ?? "",
          payload: jsonEncode(wsMsg.toMap()),
        );
      }
    }
  }

  static void _checkWebsocketsNotificationData() async {
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
        StorageHelper.setObject(StorageHelper.websocketVendorNotFoundResponse, vendor.notification?.parsedData);
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
          imageUrl: model.notification?.pictureUrl,
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
          imageUrl: model.notification?.pictureUrl,
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
          imageUrl: model.notification?.pictureUrl,
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

  static void getStorageValue() {
    authToken = StorageHelper.getValue(StorageHelper.authToken) ?? "";
    loginUserId = StorageHelper.getValue(StorageHelper.userId) ?? "";
    loginUsername = StorageHelper.getValue(StorageHelper.username) ?? "";
    log("LoggedInInfo: AuthToken: $authToken - LoginUserId: $loginUserId - LoginUsername: $loginUsername");
    dynamic websocketVendorFoundResponse = StorageHelper.getObject(StorageHelper.websocketVendorFoundResponse);
    log("WebsocketVendorFoundResponse: $websocketVendorFoundResponse");
    dynamic websocketVendorNotFoundResponse = StorageHelper.getObject(StorageHelper.websocketVendorNotFoundResponse);
    log("WebsocketVendorNotFoundResponse: $websocketVendorNotFoundResponse");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleState.value = state;
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<LocationService>();
    super.onClose();
  }
}
