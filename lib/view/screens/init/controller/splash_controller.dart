import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';

class SplashController extends GetxController {
  String authToken = "";

  @override
  Future<void> onInit() async {
    super.onInit();
    _getStorageValue();
    _checkLoggedIn();
  }

  void _checkLoggedIn() async {
    await Future.delayed(const Duration(seconds: 3));
    if (authToken.isEmpty) {
      Get.offAllNamed(AppRoutes.signUpScreen);
    } else {
      await HelperFunction.initWebSockets(authToken);
      Get.offAllNamed(AppRoutes.landingScreen);
    }
  }

  void _getStorageValue() {
    authToken = StorageHelper.getValue(StorageHelper.authToken);
  }
}
