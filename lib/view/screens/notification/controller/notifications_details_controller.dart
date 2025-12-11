import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/data/model/network/common/notification_model.dart';

class NotificationsDetailsController extends GetxController {
  NotificationModel notification = NotificationModel();

  @override
  void onInit() {
    _getArguments();
    super.onInit();
  }

  void goToImageViewerScreen(String imageUrl) {
    Get.toNamed(
      AppRoutes.imageViewerScreen,
      arguments: {"imageUrl": imageUrl},
    );
  }

  void _getArguments() {
    if (Get.arguments != null) {
      notification = Get.arguments["notification"] ?? NotificationModel();
    }
  }
}
