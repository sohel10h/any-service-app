import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    _checkLoggedIn();
  }

  void _checkLoggedIn() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(AppRoutes.landingScreen);
  }
}
