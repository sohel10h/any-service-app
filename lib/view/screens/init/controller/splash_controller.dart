import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/data/model/network/sign_in_model.dart';
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
      Get.offAllNamed(AppRoutes.landingScreen);
    }
  }

  void _getStorageValue() {
    authToken = StorageHelper.getValue(StorageHelper.authToken);
    dynamic signInResponse = StorageHelper.getObject(StorageHelper.signInResponse);
    if (signInResponse != null) {
      SignInModel signIn = SignInModel.fromJson(signInResponse);
      AppDIController.setSignInDetails(signIn);
    }
  }
}
