import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';

class SplashController extends GetxController {
  String authToken = "";

  @override
  Future<void> onInit() async {
    super.onInit();
    _checkLoggedIn();
  }

  void _checkLoggedIn() async {
    await Future.delayed(const Duration(seconds: 3));
    authToken.isEmpty ? Get.offAllNamed(AppRoutes.sigInScreen) : Get.offAllNamed(AppRoutes.landingScreen);
  }
}
