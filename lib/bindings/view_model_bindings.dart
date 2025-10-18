import 'package:get/get.dart';
import 'package:service_la/view/screens/init/controller/splash_controller.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';

class ViewModelBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<LandingController>(() => LandingController(), fenix: true);
  }
}
