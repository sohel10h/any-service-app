import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';

class SettingsController extends GetxController {
  @override
  void onInit() {
    // statement
    super.onInit();
  }

  void logOut() {
    StorageHelper.removeAllLocalData();
    _goToSignInScreen();
  }

  void _goToSignInScreen() => Get.offAllNamed(AppRoutes.sigInScreen);
}
