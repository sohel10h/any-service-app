import 'package:get/get.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';
import 'package:service_la/view/screens/init/controller/splash_controller.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';
import 'package:service_la/view/screens/auth/sign_in/controller/sign_in_controller.dart';
import 'package:service_la/view/screens/auth/sign_up/controller/sign_up_controller.dart';

class ViewModelBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<LandingController>(() => LandingController(), fenix: true);
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
