import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/common/utils/dialog_helper.dart';
import 'package:service_la/data/model/network/websocket_notification_model.dart';

class NotificationBottomSheetQueue {
  static final List<WebsocketNotificationModel> _queue = [];
  static bool _isShowing = false;
  static String? _allowedRoute;

  static void add(WebsocketNotificationModel notification) {
    _queue.add(notification);
    _tryShowNext();
  }

  static void _tryShowNext() {
    if (_isShowing || _queue.isEmpty) return;
    final currentRoute = Get.currentRoute;
    if (_allowedRoute != null && _allowedRoute != currentRoute) return;
    final notification = _queue.removeAt(0);
    _isShowing = true;
    if (Get.context != null) {
      DialogHelper.showNotificationBottomSheet(
        Get.context!,
        title: notification.title,
        message: notification.message ?? "",
        onClosed: () {
          _isShowing = false;
          _tryShowNext();
        },
        onPressed: notification.type == NotificationType.serviceRequest.typeValue
            ? () {
                Get.back();
                goToServiceDetailsScreen(notification.id ?? "");
              }
            : null,
        actionTitle: notification.type == NotificationType.serviceRequest.typeValue ? "Details" : null,
      );
    } else {
      _isShowing = false;
      _tryShowNext();
    }
  }

  static void goToServiceDetailsScreen(String serviceRequestId) {
    _allowedRoute = AppRoutes.landingScreen;
    Get.toNamed(
      AppRoutes.serviceDetailsScreen,
      arguments: {"serviceRequestId": serviceRequestId},
    )?.then((_) {
      _allowedRoute = null;
      _tryShowNext();
    });
  }
}
