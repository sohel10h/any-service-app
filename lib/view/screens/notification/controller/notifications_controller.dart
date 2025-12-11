import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/data/model/network/websocket/websocket_notification_read_model.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/repository/notification_repo.dart';
import 'package:service_la/data/model/network/common/notification_model.dart';
import 'package:service_la/data/model/network/notification_response_model.dart';
import 'package:service_la/services/di/app_di_controller.dart';

class NotificationsController extends GetxController {
  final NotificationRepo _notificationRepo = NotificationRepo();
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxBool isLoadingNotifications = false.obs;
  RxBool isLoadingMoreNotifications = false.obs;
  int currentPageNotifications = 1;
  int totalPagesNotifications = 1;

  @override
  void onInit() {
    _getNotifications(isRefresh: true);
    ever(AppDIController.notificationRead, (notificationRead) {
      onWebsocketReceived(notificationRead);
    });
    super.onInit();
  }

  void onWebsocketReceived(WebsocketNotificationReadModel notificationRead) {
    notifications.singleWhere((notification) => notification.id == notificationRead.notificationId).isRead = true;
    notifications.refresh();
  }

  void sendNotificationStatus(String? notificationId) async {
    if (notificationId == null) return;
    final payload = {
      ApiParams.type: WebsocketPayloadType.markRead.typeValue,
      ApiParams.target: WebsocketPayloadType.notification.name,
      ApiParams.notificationId: notificationId,
    };
    try {
      await AppDIController.sendWebsocketsData(payload);
    } catch (e) {
      log("WebsocketsSendParams error from controller: ${e.toString()}");
    }
  }

  Future<void> loadNextPageNotifications() async {
    if (currentPageNotifications < totalPagesNotifications && !isLoadingMoreNotifications.value) {
      isLoadingMoreNotifications.value = true;
      currentPageNotifications++;
      await _getNotifications();
    }
  }

  Future<void> refreshNotifications({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    await _getNotifications(isRefresh: isRefresh, isLoadingEmpty: isLoadingEmpty);
  }

  Future<void> _getNotifications({bool isRefresh = false, bool isLoadingEmpty = false}) async {
    if (isLoadingEmpty) totalPagesNotifications = 1;
    if (isRefresh) {
      currentPageNotifications = 1;
      notifications.clear();
    }
    if (currentPageNotifications > totalPagesNotifications) return;
    if (isRefresh || isLoadingEmpty) {
      isLoadingNotifications.value = true;
    }
    try {
      Map<String, dynamic> queryParams = {
        ApiParams.page: currentPageNotifications,
      };
      var response = await _notificationRepo.getNotifications(queryParams: queryParams);
      if (response is String) {
        log("Notifications get failed from controller response: $response");
      } else {
        NotificationResponseModel notificationResponseData = response as NotificationResponseModel;
        if (notificationResponseData.status == 200 || notificationResponseData.status == 201) {
          final data = notificationResponseData.notificationData?.notifications ?? [];
          if (isRefresh) {
            notifications.assignAll(data);
          } else {
            notifications.addAll(data);
          }
          currentPageNotifications = notificationResponseData.notificationData?.meta?.page ?? currentPageNotifications;
          totalPagesNotifications = notificationResponseData.notificationData?.meta?.totalPages ?? totalPagesNotifications;
        } else {
          if (notificationResponseData.status == 401 ||
              (notificationResponseData.errors != null &&
                  notificationResponseData.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _notificationRepo.getNotifications(queryParams: queryParams),
            );
            if (retryResponse is NotificationResponseModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              final data = retryResponse.notificationData?.notifications ?? [];
              if (isRefresh) {
                notifications.assignAll(data);
              } else {
                notifications.addAll(data);
              }
              currentPageNotifications = retryResponse.notificationData?.meta?.page ?? currentPageNotifications;
              totalPagesNotifications = retryResponse.notificationData?.meta?.totalPages ?? totalPagesNotifications;
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("Notifications get failed from controller: ${notificationResponseData.status}");
          return;
        }
      }
    } catch (e) {
      log("Notifications get catch error from controller: ${e.toString()}");
    } finally {
      isLoadingNotifications.value = false;
      isLoadingMoreNotifications.value = false;
    }
  }
}
